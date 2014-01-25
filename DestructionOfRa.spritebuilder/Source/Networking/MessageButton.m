//
//  MessageButton.m
//  DestructionOfRa
//
//  Created by Christopher Cotton on 1/25/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "MessageButton.h"
#import "CCControlSubclass.h"
#import "SessionContainer.h"

NSString* const kMessageButtonDownPrefix = @"b:";
NSString* const kMessageButtonUpPrefix = @"B:";

@implementation MessageButton


- (void) touchEntered:(UITouch*) touch withEvent:(UIEvent*)event {
    [super touchEntered:touch withEvent:event];
    NSString* data = [kMessageButtonDownPrefix stringByAppendingString:self.message];
    [[SessionContainer sharedSession] sendMessage:data];
}

/**
 *  Used by sub-classes. Called when a touch exits the component.
 *
 *  @param touch Touch that exited the component
 *  @param event Event associated with the touch.
 */
- (void) touchExited:(UITouch*) touch withEvent:(UIEvent*) event {
    [super touchExited:touch withEvent:event];
    NSString* data = [kMessageButtonUpPrefix stringByAppendingString:self.message];
    [[SessionContainer sharedSession] sendMessage:data];
}

/**
 *  Used by sub-classes. Called when a touch that started inside the component is ended inside the component. E.g. for CCButton, this triggers the buttons callback action.
 *
 *  @param touch Touch that is released inside the component.
 *  @param event Event associated with the touch.
 */
- (void) touchUpInside:(UITouch*) touch withEvent:(UIEvent*) event {
    [super touchUpInside:touch withEvent:event];
    NSString* data = [kMessageButtonUpPrefix stringByAppendingString:self.message];
    [[SessionContainer sharedSession] sendMessage:data];
}

@end
