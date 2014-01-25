//
//  HazardNode.h
//  DestructionOfRa
//
//  Created by Christopher Cotton on 1/25/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef NS_ENUM(NSUInteger, HazardType){
    kPlayerHazard_None = 0,
    kPlayerHazard_Pit = 1,
    kPlayerHazard_Hanging = 2,
    kPlayerHazard_Monster = 3,
    kPlayerHazard_Burning = 4,
};

@interface HazardNode : CCSprite {
    
}

@property (nonatomic) HazardType hazardType;

@end
