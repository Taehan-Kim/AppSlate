//
//  CSBToothPeer.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 13. 12. 20..
//  Copyright (c) 2013년 ChocolateSoft. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "CSGearObject.h"

@interface CSBToothPeer : CSGearObject <MCBrowserViewControllerDelegate, MCSessionDelegate>
{
    NSString *peerName;
    MCSession *session;
    MCAdvertiserAssistant *advertiser;
    MCPeerID *myPeerID;
    BOOL isPickerShow;
    UIAlertView *waitAlert;
}

-(id) initGear;

-(void) setMyName:(NSString*) strValue;
-(NSString*) getMyName;

-(void) setShowBrowserAction:(NSNumber*) boolValue;
-(NSNumber*) getShowBrowser;

-(void) setAdvertiserAction:(NSNumber*) boolValue;
-(NSNumber*) getAdvertiser;

-(void) setDisconnectAction:(NSNumber*) BoolVlaue;
-(NSNumber*) getDisconnect;


@end
