//
//  GameScene.m
//  DestructionOfRa
//
//  Created by John Saba on 1/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "Checkpoint.h"
#import "SessionContainer.h"
#import "MessageButton.h"

@interface GameScene () <SessionContainerDelegate>


@property (weak, nonatomic) CCSprite *player;
@property (weak, nonatomic) CCLabelTTF *countDownLabel;

@property (assign) NSInteger countDownNumber;
@property (assign) CGFloat speedMultiplier;
@property (assign) CGPoint velocity;

@end

@implementation GameScene

- (id)init
{
    self = [super init];
    if (self) {
        self.speedMultiplier = 2.0;
        self.velocity = ccp(0.002f * self.speedMultiplier, 0.0f);
    }
    return self;
}

- (void)onEnter
{
    [super onEnter];
    [SessionContainer sharedSession].delegate = self;
    self.actionButton.visible = NO;

    // display items
    self.player.visible = self.hosting;
    for (CCNode *node in self.children) {
        if ([node isKindOfClass:[HazardNode class]]) {
            HazardNode* hazard = (HazardNode*)node;
            hazard.visible = hazard.hazardType == self.playerHazardType;
        }
    }

    
    // start countdown label
    self.countDownNumber = 1;
    CCLabelTTF *countDownLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", self.countDownNumber] fontName:@"Arial" fontSize:120];
    countDownLabel.color = [CCColor redColor];
    self.countDownLabel = countDownLabel;
    countDownLabel.positionType = CCPositionTypeNormalized;
    countDownLabel.position = ccp(0.5, 0.5);
    [self addChild:countDownLabel];
    [self schedule:@selector(countDown) interval:1.0f repeat:0 delay:1];
}

- (void)countDown
{
    self.countDownNumber -= 1;

    if (self.countDownNumber == 0) {
        self.countDownLabel.string = @"RA!!!";
    }
    else if (self.countDownNumber < 0) {
        [self unschedule:@selector(countDown)];
        [self removeChild:self.countDownLabel];
        [self startGame];
    }
    else {
        self.countDownLabel.string = [NSString stringWithFormat:@"%i", self.countDownNumber];
    }
}

- (void)startGame
{
    if (self.hosting) {
        [self schedule:@selector(movePlayer:) interval:1.0f/60.0f];
    } else {
        self.actionButton.visible = YES;
    }
}

- (void)movePlayer:(CCTime)dt
{
    self.player.position = ccpAdd(self.player.position, self.velocity);
    CGRect playerRect = self.player.boundingBox;
    // change direction at checkpointss
    for (CCNode *node in self.children) {
        if (CGRectIntersectsRect(node.boundingBox, playerRect)) {
            
            if ([node isKindOfClass:[Checkpoint class]]) {
                Checkpoint *checkpoint = (Checkpoint *)node;
                self.velocity = ccp(checkpoint.dx * self.speedMultiplier, checkpoint.dy * self.speedMultiplier);
            } else if ([node isKindOfClass:[HazardNode class]]) {
                
//                self.velocity = ccp(0, 0);
                
            }
        }
        
    }
}

#pragma mark - @protocol SessionContainerDelegate <NSObject>


-(void)hostingReceived:(Transcript *)transcript {
    
    if ([transcript.message hasPrefix:kMessageButtonDownPrefix]) {
        if ([transcript.message hasSuffix:@"A"]) {
            CCAction* action = [CCActionRepeatForever actionWithAction:[CCActionSequence actions: [CCActionScaleTo actionWithDuration:0.3 scale:2.0], [CCActionScaleTo actionWithDuration:0.3 scale:0.5], nil]];
            action.tag = kPlayerSkill_Shield;
            [self.player runAction:action];
        }
        
        
    } else if ([transcript.message hasPrefix:kMessageButtonUpPrefix]) {
        [self.player stopActionByTag:kPlayerSkill_Shield];
        self.player.scale = 1.0;
    }
}

-(void)clientTranscript:(Transcript *)transcript {
    
}


// Method used to signal to UI an initial message, incoming image resource has been received
- (void)receivedTranscript:(Transcript *)transcript {
    NSLog(@"Received %@", transcript.message);
    if (self.hosting) {
        [self hostingReceived:transcript];
    } else {
        [self clientTranscript:transcript];
    }
}

// Method used to signal to UI an image resource transfer (send or receive) has completed
- (void)updateTranscript:(Transcript *)transcript {
    NSLog(@"Update transcript %@", transcript);
}



@end
