//
//  GameScene.m
//  DestructionOfRa
//
//  Created by John Saba on 1/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "Checkpoint.h"

@interface GameScene ()

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
    
    // start countdown label
    self.countDownNumber = 3;
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
    [self schedule:@selector(movePlayer:) interval:1.0f/60.0f];
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

@end
