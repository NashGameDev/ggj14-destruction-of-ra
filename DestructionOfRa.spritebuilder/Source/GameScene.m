//
//  GameScene.m
//  DestructionOfRa
//
//  Created by John Saba on 1/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()

@property (weak, nonatomic) CCSprite *player;
@property (weak, nonatomic) CCLabelTTF *countDownLabel;

@property (assign) NSInteger countDownNumber;

@end

@implementation GameScene

- (id)init
{
    self = [super init];
    if (self) {
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
    }
    else {
        self.countDownLabel.string = [NSString stringWithFormat:@"%i", self.countDownNumber];
    }
}


@end
