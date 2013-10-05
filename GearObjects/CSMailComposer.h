//
//  CSMailComposer.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 21..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "CSGearObject.h"

@interface CSMailComposer : CSGearObject <MFMailComposeViewControllerDelegate>
{
    NSString *titleStr, *textStr;
    NSString *toAddressStr, *ccAddressStr;
    UIImage *mailImage;
}

-(id) initGear;

-(void) setTitle:(NSString*)txt;
-(NSString*) getTitle;

-(void) setText:(NSString*)txt;
-(NSString*) getText;

-(void) setCcAddr:(NSString*)txt;
-(NSString*) getCcAddr;

-(void) setToAddr:(NSString*)txt;
-(NSString*) getToAddr;

-(void) setShow:(NSNumber*)BoolValue;
-(NSNumber*) getShow;

@end
