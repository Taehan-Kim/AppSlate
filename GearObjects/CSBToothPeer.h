//
//  CSBToothPeer.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 9. 3..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "CSGearObject.h"

@interface CSBToothPeer : CSGearObject <GKSessionDelegate, GKPeerPickerControllerDelegate>
{
    GKSession *session;
    BOOL isPickerShow;
    NSString *receivedPeerID;
}

-(id) initGear;

-(void) setActivate:(NSNumber*) BoolVlaue;
-(NSNumber*) getActivate;

-(void) setDisconnect:(NSNumber*) BoolVlaue;
-(NSNumber*) getDisconnect;


@end
