//
//  CSBToothPeer.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 9. 3..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSBToothPeer.h"

#define PEERID  @"com.chocolatesoft.appslate"

@implementation CSBToothPeer

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setActivate:(NSNumber*) BoolValue
{
    if( nil == session ) return;

    if( [BoolValue isKindOfClass:[NSString class]] )
        session.available = [(NSString*)BoolValue boolValue];
    else  if( [BoolValue isKindOfClass:[NSNumber class]] )
        session.available = [BoolValue boolValue];
    else
        return;
}

-(NSNumber*) getActivate
{
    if( nil == session ) return @(NO);

    return @(session.isAvailable);
}

-(void) setShowPeerList:(NSNumber*) BoolValue
{
    if( USERCONTEXT.imRunning && !isPickerShow ){
        GKPeerPickerController *picker = [[GKPeerPickerController alloc] init];
        [picker setDelegate:self];
        [picker setConnectionTypesMask:GKPeerPickerConnectionTypeNearby];
        [picker show];
        isPickerShow = YES;
    }
}

-(NSNumber*) getShowPeerList
{
    return @(NO);
}

-(void) setSendData:(NSString*) str
{
    NSError* error = nil;

    // 지정된 피어로 데이터 전송
    if( USERCONTEXT.imRunning && nil != receivedPeerID )
    {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];

        [session sendData:data toPeers:@[receivedPeerID] withDataMode:GKSendDataReliable error:&error];
        // TODO:Error handling
    }
}

-(NSNumber*) getSendData
{
    return @(NO);
}

-(void) setDisconnect:(NSNumber*) BoolVlaue
{
    // 지정된 피어로 데이터 전송
    if( USERCONTEXT.imRunning && nil != session
       && [BoolVlaue boolValue] )
    {
        [session disconnectFromAllPeers];
    }
}

-(NSNumber*) getDisconnect
{
    return @(NO);
}


//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;

    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_bluetooth.png"]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_BTOOTH;

    csResizable = NO;
    csShow  = NO;

    isPickerShow = NO;
    receivedPeerID = nil;
    NSString *devKind;
    devKind = [NSString stringWithFormat:@"AppSlate - %@",[UIDevice currentDevice].model];

    self.info = NSLocalizedString(@"Bluetooth P2P connect", @"Bluetooth");


    NSDictionary *d1 = MAKE_PROPERTY_D(@"> Available", P_BOOL, @selector(setActivate:),@selector(getActivate));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"> Show peer list", P_BOOL, @selector(setShowPeerList:),@selector(getShowPeerList));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"> Send data", P_TXT, @selector(setSendData:),@selector(getSendData));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"> Disconnect", P_BOOL, @selector(setDisconnect:),@selector(getDisconnect));
    pListArray = @[d1,d2,d3,d4];

    NSMutableDictionary MAKE_ACTION_D(@"Received Data", A_NUM, a1);
    actionArray = @[a1];

    return self;
}

- (id) initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_bluetooth.png"]];
        session = [[GKSession alloc] initWithSessionID:PEERID displayName:[NSString stringWithFormat:@"AppSlate - %@",[UIDevice currentDevice].model] sessionMode:GKSessionModePeer];
        [session setDelegate:self];
        [session setAvailable:[decoder decodeBoolForKey:@"isAvailable"]];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeBool:session.isAvailable forKey:@"isAvailable"];
}

#pragma mark - GKSession Delegate

- (void)session:(GKSession *)sess peer:(NSString*)peerID didChangeState:(GKPeerConnectionState)inState
{
	if( inState == GKPeerStateAvailable ) {
		[sess connectToPeer:peerID withTimeout:100];
		sess.available = YES;
	} else if( GKPeerStateDisconnected == inState )
    {
        receivedPeerID = nil;
        session = nil;
    }
}

- (void)session:(GKSession *)comeSession didReceiveConnectionRequestFromPeer:(NSString *)peerID
{

    NSError* error;
    receivedPeerID = peerID;

    if (![comeSession acceptConnectionFromPeer:peerID error:&error]) {
        NSLog(@"%@", [error localizedDescription]);
		[comeSession denyConnectionFromPeer:peerID];
    }
}

- (void)receiveData:(NSData*)data fromPeer:(NSString*)peer inSession:(GKSession*)theSession context:(void *)context
{
	// Data handling
    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;

        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];

            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
                else
                    EXCLAMATION;
            }
        }
    }
}

#pragma mark - GKPeerPickerControllerDelegate

// The controller connected a peer to the session.
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)comeSession
{
    session = comeSession;
    receivedPeerID = peerID;
    [session setDelegate:self];
    [session setDataReceiveHandler:self withContext:NULL];

    [picker dismiss];
    isPickerShow = NO;
    picker.delegate = nil;
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type
{
    NSString *devKind;
    devKind = [NSString stringWithFormat:@"AppSlate - %@",[UIDevice currentDevice].model];
    GKSession *insession = [[GKSession alloc] initWithSessionID:PEERID displayName:devKind sessionMode:GKSessionModePeer];
//    [session setDelegate:self];

	return insession;
}

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker
{
    isPickerShow = NO;
}

@end
