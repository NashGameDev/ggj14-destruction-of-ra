//
//  SetupScene.h
//  DestructionOfRa
//
//  Created by Christopher Cotton on 1/25/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SetupScene : CCNode {
    
}

@property (weak, nonatomic) CCButton* host;
@property (weak, nonatomic) CCButton* ready;

@property (weak, nonatomic) CCNode* player1;
@property (weak, nonatomic) CCNode* player2;
@property (weak, nonatomic) CCNode* player3;
@property (weak, nonatomic) CCNode* player4;

@end
