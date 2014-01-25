//
//  GameScene.h
//  DestructionOfRa
//
//  Created by John Saba on 1/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "HazardNode.h"

typedef NS_ENUM(NSUInteger, PlayerSkillType){
    kPlayerSkill_None,
    kPlayerSkill_Jump,
    kPlayerSkill_Duck,
    kPlayerSkill_Fire,
    kPlayerSkill_Shield,
};



@interface GameScene : CCNode

@property (nonatomic) BOOL hosting;
@property (nonatomic) PlayerSkillType skillType;
@property (nonatomic) HazardType hazardType;

@end
