//
//  HazardNode.m
//  DestructionOfRa
//
//  Created by Christopher Cotton on 1/25/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "HazardNode.h"
#import "CCParticleExamples.h"

@implementation HazardNode

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)onEnter {
    [super onEnter];
    
    if (self.hazardType == kPlayerHazard_Burning) {
        CCParticleFire* fire = [[CCParticleFire alloc] initWithTotalParticles:50];
        fire.position = ccp(0, 0);
        [self addChild:fire];

    }
}

@end
