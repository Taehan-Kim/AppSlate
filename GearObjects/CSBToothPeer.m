//
//  CSBToothPeer.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 13. 12. 20..
//  Copyright (c) 2013년 ChocolateSoft. All rights reserved.
//

#import "CSBToothPeer.h"
#import "CSAppDelegate.h"
#import "CSMainViewController.h"
#import "UIBAlertView.h"

#define _SERVICE  @"appslate-p2p"

@implementation CSBToothPeer

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setMyName:(NSString*) strValue
{
    if( nil == strValue || ![strValue length] ) return;

    peerName = strValue;
}

-(NSString*) getMyName
{
    return peerName;
}

-(void) setShowBrowserAction:(NSNumber*) boolValue
{
    if( nil == peerName || [peerName length] < 1 || [boolValue isEqualToNumber:@(NO)] ) return;

    if( nil != session && [session.connectedPeers count] > 0 ) {
        [session disconnect];
        session = nil;
    }
    myPeerID = [[MCPeerID alloc] initWithDisplayName:peerName];
    session = [[MCSession alloc] initWithPeer:myPeerID];
    [session setDelegate:self];

    if( USERCONTEXT.imRunning ){
        MCBrowserViewController *browserVC = [[MCBrowserViewController alloc]
                                              initWithServiceType:_SERVICE session:session];
        [browserVC setDelegate:self];
        [[(CSAppDelegate*)([UIApplication sharedApplication].delegate) mainViewController] presentViewController:browserVC animated:YES completion:nil];
        isPickerShow = YES;
    }
}

-(NSNumber*) getShowBrowser
{
    return @(NO);
}

-(void) setAdvertiserAction:(NSNumber*) boolValue
{
    if( nil == peerName || [peerName length] < 1 || [boolValue isEqualToNumber:@(NO)] ) return;

    if( nil != session && [session.connectedPeers count] > 0 ) {
        [session disconnect];
        session = nil;
    }
    myPeerID = [[MCPeerID alloc] initWithDisplayName:peerName];
    session = [[MCSession alloc] initWithPeer:myPeerID];
    [session setDelegate:self];

    advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:_SERVICE discoveryInfo:nil session:session];
    [advertiser start];

    if( nil == waitAlert )
        waitAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Wait", @"Wait") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles: nil];
}

-(NSNumber*) getAdvertiser
{
    return @(NO);
}

-(void) setSendDataAction:(NSString*) str
{
    NSError* error = nil;

    // 지정된 피어로 데이터 전송
    if( USERCONTEXT.imRunning && nil != session )
    {
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];

        [session sendData:data toPeers:session.connectedPeers withMode:MCSessionSendDataReliable error:&error];
        // TODO:Error handling
    }
}

-(NSNumber*) getSendData
{
    return @(NO);
}

-(void) setDisconnectAction:(NSNumber*) BoolVlaue
{
    // 지정된 피어로 데이터 전송
    if( USERCONTEXT.imRunning && nil != session
       && [BoolVlaue boolValue] )
    {
        [session disconnect];
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
    if( !(self = [super init]) ) return nil;

    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_bluetooth.png"]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_BTOOTH;

    csResizable = NO;
    csShow  = NO;
    isPickerShow = NO;

    peerName = [NSString stringWithFormat:@"AppSlate - %@",[UIDevice currentDevice].model];

    self.info = NSLocalizedString(@"Multipeer connect", @"MultiConnect");


    NSDictionary *d1 = MAKE_PROPERTY_D(@"My Name", P_TXT, @selector(setMyName:),@selector(getMyName));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"> Show peer list", P_BOOL, @selector(setShowBrowserAction:),@selector(getShowBrowser));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"> Wait connect", P_BOOL, @selector(setAdvertiserAction:),@selector(getAdvertiser));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"> Send data", P_TXT, @selector(setSendDataAction:),@selector(getSendData));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"> Disconnect", P_BOOL, @selector(setDisconnectAction:),@selector(getDisconnect));
    pListArray = @[d1,d2,d3,d4,d5];

    NSMutableDictionary MAKE_ACTION_D(@"Received Text", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Connected", A_NUM, a2);
    NSMutableDictionary MAKE_ACTION_D(@"Disconnected", A_NUM, a3);
    actionArray = @[a1,a2,a3];

    return self;
}

- (id) initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_bluetooth.png"]];
        peerName = [decoder decodeObjectForKey:@"peerName"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:peerName forKey:@"peerName"];
}

#pragma mark - MCBrowserViewControllerDelegate
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserVC
{
    [browserVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserVC
{
    [browserVC dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MCSessionDelegate

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if( nil != waitAlert ) [waitAlert dismissWithClickedButtonIndex:0 animated:NO];

    if( MCSessionStateConnected == state ) {
        if( USERCONTEXT.imRunning ){
            SEL act;
            NSNumber *nsMagicNum;
            
            act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
            if( nil != act ){
                nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
                CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
                
                if( nil != gObj ){
                    if( [gObj respondsToSelector:act] )
                        [gObj performSelector:act withObject:[[NSString alloc] initWithData:nil encoding:NSUTF8StringEncoding]];
                    else
                        EXCLAMATION;
                }
            }
        }
    }

    if( MCSessionStateNotConnected == state ) {
        UIBAlertView *alertV = [[UIBAlertView alloc] initWithTitle:@"AppSlate" message:@"Disconnected." cancelButtonTitle:NSLocalizedString(@"Confirm", @"Confirm") otherButtonTitles: nil];
        [alertV showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
            if( USERCONTEXT.imRunning ){
                SEL act;
                NSNumber *nsMagicNum;
                
                act = ((NSValue*)((NSDictionary*)actionArray[2])[@"selector"]).pointerValue;
                if( nil != act ){
                    nsMagicNum = ((NSDictionary*)actionArray[2])[@"mNum"];
                    CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
                    
                    if( nil != gObj ){
                        if( [gObj respondsToSelector:act] )
                            [gObj performSelector:act withObject:[[NSString alloc] initWithData:nil encoding:NSUTF8StringEncoding]];
                        else
                            EXCLAMATION;
                    }
                }
            }
        }];
    }
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    // Data handling
    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                if( nil != gObj ){
                    if( [gObj respondsToSelector:act] )
                        [gObj performSelector:act withObject:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
                    else
                        EXCLAMATION;
                }

            });
        }
    }
}

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"MCSession";
}

-(NSArray*) importLinesCode
{
    return @[@"<MultipeerConnectivity/MultipeerConnectivity.h>"];
}

-(NSString*) delegateName
{
    return @"MCBrowserViewControllerDelegate, MCSessionDelegate";
}

-(NSString*) customClass
{
    return [NSString stringWithFormat:@"    %@ = [[MCSession alloc] initWithPeer:[[MCPeerID alloc] initWithDisplayName:%@]];\n    [%@ setDelegate:self];\n",varName,peerName,varName];
}

-(NSArray*) delegateCodes
{
    SEL act;
    NSNumber *nsMagicNum;
    
    NSMutableString *code = [[NSMutableString alloc] initWithCapacity:100];
    // code 추가. actionArray 에 연결된 CSGearObject 의 메소드를 호출하는 코드 작성 & 삽입.
    act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        
        [code appendFormat:@"    if( MCSessionStateConnected == state ) {\n        [%@ %@[[NSString alloc] initWithData:nil encoding:NSUTF8StringEncoding]];\n    }\n",[gObj getVarName],@(sel_name_c)];
    }

    act = ((NSValue*)((NSDictionary*)actionArray[2])[@"selector"]).pointerValue;
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[2])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        
        [code appendFormat:@"    if( MCSessionStateNotConnected == state ) {\n        [%@ %@[[NSString alloc] initWithData:nil encoding:NSUTF8StringEncoding]];\n    }\n",[gObj getVarName],@(sel_name_c)];
    }

    NSMutableString *code2 = [[NSMutableString alloc] initWithCapacity:100];
    // code 추가. actionArray 에 연결된 CSGearObject 의 메소드를 호출하는 코드 작성 & 삽입.
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        
        [code2 appendFormat:@"    [%@ %@[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];\n",[gObj getVarName],@(sel_name_c)];
    }

    return @[@"- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserVC{\n",@"    [browserVC dismissViewControllerAnimated:YES completion:nil];\n",@"}\n",@"- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserVC{\n",@"    [browserVC dismissViewControllerAnimated:YES completion:nil];\n",@"}\n",
     @"- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress\n{\n}\n\n- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error\n{\n}\n\n- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state\n{\n",code,@"}\n\n",
     @"- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID\n{",code2,@"}\n",
     @"- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID\n{\n",@"\n",@"}\n"];
}

@end
