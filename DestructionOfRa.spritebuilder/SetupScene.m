//
//  SetupScene.m
//  DestructionOfRa
//
//  Created by Christopher Cotton on 1/25/14.
//  Copyright 2014 Apportable. All rights reserved.
//

#import "SetupScene.h"
#import "SessionContainer.h"
#import "MessageButton.h"

@interface SetupScene () <MCBrowserViewControllerDelegate, SessionContainerDelegate>

@property (nonatomic) BOOL hosting;
@property (strong, nonatomic) NSMutableArray* players;
@property (strong, nonatomic) NSArray* playerButtons;

@end

@implementation SetupScene

-(void) onEnter {
    [super onEnter];
    self.ready.visible = NO;
    self.player1.visible = NO;
    self.player2.visible = NO;
    self.player3.visible = NO;
    self.player4.visible = NO;
    self.players = [NSMutableArray array];
    self.playerButtons = @[self.player1, self.player2, self.player3,
                           self.player4];
    
    [SessionContainer sharedSession].delegate = self;
}

-(void) onExit {
    [SessionContainer sharedSession].delegate = nil;
    [super onExit];
}

-(void) hostPressed:(id)sender {
    SessionContainer* sessionContainer = [SessionContainer sharedSession];
    self.hosting = YES;
    // Instantiate and present the MCBrowserViewController
    MCBrowserViewController *browserViewController = [[MCBrowserViewController alloc] initWithServiceType:sessionContainer.serviceType session:sessionContainer.session];
    
	browserViewController.delegate = self;
    browserViewController.minimumNumberOfPeers = kMCSessionMinimumNumberOfPeers;
    browserViewController.maximumNumberOfPeers = 4;
    [[CCDirector sharedDirector] presentViewController:browserViewController animated:YES completion:nil];
}

#pragma mark - MCBrowserViewControllerDelegate methods

// Override this method to filter out peers based on application specific needs
- (BOOL)browserViewController:(MCBrowserViewController *)browserViewController shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    return YES;
}

// Override this to know when the user has pressed the "done" button in the MCBrowserViewController
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

// Override this to know when the user has pressed the "cancel" button in the MCBrowserViewController
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    self.hosting = NO;
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

// Delegate protocol for updating UI when we receive data or resources from peers.
#pragma mark - @protocol SessionContainerDelegate <NSObject>

-(void)hostingConnection:(Transcript *)transcript {
    if (transcript.state == MCSessionStateConnected) {
        if (![self.players containsObject:transcript.peerID]) {
            [self.players addObject:transcript.peerID];
        }
        
    } else {
        [self.players removeObject:transcript.peerID];
    }
    
    if (self.players.count > 0) {
        self.player1.visible = YES;
    }
    if (self.players.count > 1) {
        self.player2.visible = YES;
    }
    if (self.players.count > 2) {
        self.player3.visible = YES;
    }
    if (self.players.count > 3) {
        self.player4.visible = YES;
    }
}

-(void)hostingReceived:(Transcript *)transcript {
    
    NSUInteger index = [self.players indexOfObject:transcript.peerID];
    if (index == NSNotFound) {
        return;
    }
    
    CCNode* player = self.playerButtons[index];
    NSLog(@"message: %@", transcript.message);
    
    if ([transcript.message hasPrefix:kMessageButtonDownPrefix]) {
        CCAction* action = [CCActionRepeatForever actionWithAction:[CCActionSequence actions: [CCActionScaleTo actionWithDuration:0.3 scale:2.0], [CCActionScaleTo actionWithDuration:0.3 scale:0.5], nil]];
        [player runAction:action];
        
    } else if ([transcript.message hasPrefix:kMessageButtonUpPrefix]) {
        [player stopAllActions];
        player.scale = 1.0;
    }

    for (MCPeerID* peer in [SessionContainer sharedSession].session.connectedPeers) {
        // is everyone ready?
        
        NSUInteger index = [self.players indexOfObject:transcript.peerID];
        if (index == NSNotFound) {
            return;
        }

        CCNode* player = self.playerButtons[index];

        if (player.numberOfRunningActions == 0) {
            return;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CCScene* scene = [CCBReader loadAsScene:@"GameScene"];
        [[CCDirector sharedDirector] presentScene:scene withTransition:[CCTransition transitionMoveInWithDirection:CCTransitionDirectionLeft duration:0.3] ];
    });
}

-(void)hostingTranscript:(Transcript *)transcript {
    
    if (transcript.direction == TRANSCRIPT_DIRECTION_LOCAL) {
        [self hostingConnection:transcript];
    } else {
        [self hostingReceived:transcript];
    }
}

-(void)clientTranscript:(Transcript *)transcript {
    
    if (transcript.direction == TRANSCRIPT_DIRECTION_LOCAL) {
        if (transcript.state == MCSessionStateConnected) {
            self.host.visible = NO;
            self.ready.visible = YES;
        } else {
            self.host.visible = YES;
            self.ready.visible = NO;
        }
    }
}


// Method used to signal to UI an initial message, incoming image resource has been received
- (void)receivedTranscript:(Transcript *)transcript {
    if (self.hosting) {
        [self hostingTranscript:transcript];
    } else {
        [self clientTranscript:transcript];
    }
}

// Method used to signal to UI an image resource transfer (send or receive) has completed
- (void)updateTranscript:(Transcript *)transcript {
    NSLog(@"Update transcript %@", transcript);    
}


@end
