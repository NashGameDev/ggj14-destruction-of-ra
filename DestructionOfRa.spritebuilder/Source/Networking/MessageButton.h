//
//  MessageButton.h
//  DestructionOfRa
//
//  Created by Christopher Cotton on 1/25/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

FOUNDATION_EXPORT NSString* const kMessageButtonDownPrefix;
FOUNDATION_EXPORT NSString* const kMessageButtonUpPrefix;

@interface MessageButton : CCButton {
    
}

@property (strong,nonatomic) NSString* message;

@end
