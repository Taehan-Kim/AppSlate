//
//  CSFBSend.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 3. 13..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSFBSend.h"
#import <Social/Social.h>
#import "CSAppDelegate.h"

@implementation CSFBSend

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setName:(NSString*)txt
{
    if( [txt isKindOfClass:[NSString class]] )
        name = txt;
    
    else if([txt isKindOfClass:[NSNumber class]] )
        name = [((NSNumber*)txt) stringValue];
}

-(NSString*) getName
{
    return name;
}

-(void) setCaption:(NSString*)txt
{
    if( [txt isKindOfClass:[NSString class]] )
        caption = txt;

    else if([txt isKindOfClass:[NSNumber class]] )
        caption = [((NSNumber*)txt) stringValue];
}

-(NSString*) getCaption
{
    return caption;
}

-(void) setText:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        message = txt;
    
    else if([txt isKindOfClass:[NSNumber class]] )
        message = [((NSNumber*)txt) stringValue];
}

-(NSString*) getText
{
    return message;
}

-(void) setLink:(NSString*)txt
{
    if( [txt isKindOfClass:[NSString class]] )
        link = txt;
}

-(NSString*) getLink
{
    return link;
}

-(void) setImage:(UIImage*)image
{
    if( ![image isKindOfClass:[UIImage class]] )
    {
        EXCLAMATION;
        return;
    }

    img = image;
}

-(UIImage*) getImage
{
    return img;
}

-(void) setShow:(NSNumber*)BoolValue
{
    // YES 값인 경우만 반응하자.
    if( ![BoolValue boolValue] )
        return;

    if( USERCONTEXT.imRunning &&
       [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook] )
    {
        SLComposeViewController *fbCntrlr = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        if( [link length] > 5 && [link hasPrefix:@"http"] )
            [fbCntrlr addURL:[NSURL URLWithString:link]];
        if( [message length] > 1 )
            [fbCntrlr setInitialText:message];
        if( nil != img )
            [fbCntrlr addImage:img];

        [((CSAppDelegate*)([UIApplication sharedApplication].delegate)).window.rootViewController presentViewController:fbCntrlr animated:YES completion:NULL];
    }
}

-(NSNumber*) getShow
{
    return @NO;
}

-(void) setSendFeed:(NSNumber*)BoolValue
{
    if( ![BoolValue boolValue] )
        return;

    if( USERCONTEXT.imRunning )
    {
        // 인증 연결되어 있는지 확인해서 SSO 처리.
//        if (![USERCONTEXT.facebook isSessionValid]) {
//            NSArray *permissions =  [NSArray arrayWithObjects:@"read_stream", @"publish_stream", @"offline_access",nil];
//            [USERCONTEXT.facebook authorize:permissions];
//            return;
//        }
//
//        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       @"post", @"type",
//                                       link, @"link",
//                                       name, @"name",
//                                       caption, @"caption",
////                                       postDescription, @"description",
//                                       message, @"message",
////                                       propStr, @"properties",
//                                       nil];
//        if( nil != img ){
//            [params setObject:img forKey:@"picture"];
////            [params setObject:@"large" forKey:@"type"];
//            [USERCONTEXT.facebook requestWithGraphPath:@"me/photos"
//                                             andParams:params
//                                         andHttpMethod:@"POST" andDelegate:self];
//        }
//        else
//        {
//            [USERCONTEXT.facebook requestWithGraphPath:@"me/feed"
//                                             andParams:params
//                                         andHttpMethod:@"POST" andDelegate:self];
//        }
//        START_WAIT_VIEW;
    }
}

-(NSNumber*) getSendFeed
{
    return @NO;
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_fbook.png"]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_FBSEND;
    
    csResizable = NO;
    csShow = NO;

    name = @"AppSlate";
    caption = @"Check this app.";
    message = @"";
    link = @"http://www.facebook.com/AppSlate";
    img = nil;
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Feed Name", P_TXT, @selector(setName:),@selector(getName));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Feed Caption", P_TXT, @selector(setCaption:),@selector(getCaption));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Text Message", P_TXT, @selector(setText:),@selector(getText));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Link URL", P_TXT, @selector(setLink:),@selector(getLink));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"Image", P_IMG, @selector(setImage:),@selector(getImage));
    NSDictionary *d6 = MAKE_PROPERTY_D(@">Show Action", P_BOOL, @selector(setShow:),@selector(getShow));
    NSDictionary *d7 = MAKE_PROPERTY_D(@">Send Feed Action", P_BOOL, @selector(setSendFeed:),@selector(getSendFeed));
    pListArray = @[d1,d2,d3,d4,d5,d6,d7];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_fbook.png"]];
        message = [decoder decodeObjectForKey:@"message"];
        name = [decoder decodeObjectForKey:@"name"];
        caption = [decoder decodeObjectForKey:@"caption"];
        link = [decoder decodeObjectForKey:@"link"];
        img = [decoder decodeObjectForKey:@"img"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:message forKey:@"message"];
    [encoder encodeObject:name forKey:@"name"];
    [encoder encodeObject:caption forKey:@"caption"];
    [encoder encodeObject:link forKey:@"link"];
    [encoder encodeObject:img forKey:@"img"];
}

#pragma mark - Delegate
//
//- (void)dialogDidNotComplete:(FBDialog *)dialog
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error" message:@"Do not completed to feed." delegate:nil cancelButtonTitle:@"Confirm" otherButtonTitles: nil];
//    [alert show];
//}
//
//- (void)request:(FBRequest *)request didLoad:(id)result
//{
//    STOP_WAIT_VIEW;
//    NSLog(@"F did %@",result);
//    NSLog(@"token;%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"FBAccessTokenKey"]);
//}
//
//- (void) request:(FBRequest *)request didFailWithError:(NSError *)error
//{
//    STOP_WAIT_VIEW;
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error" message:@"Do not completed to feed." delegate:nil cancelButtonTitle:@"Confirm" otherButtonTitles: nil];
//    [alert show];
//    NSLog(@"F err %@",[error description]);
//}

@end
