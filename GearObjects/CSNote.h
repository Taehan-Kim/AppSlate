//
//  CSNote.h
//  AppSlate
//
//  Created by 김태한 on 12. 3. 20..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"
#import "UserStore.h"

@interface CSNote : CSGearObject <UITextViewDelegate, UIAlertViewDelegate>
{
    NSString *userid;
    NSString *passwd;
    NSString *title;

    EDAMUser * user;
    NSString * shardId; 
    NSString * authToken;
}

-(id) initGear;


-(void) setText:(NSString*)txt;
-(NSString*) getText;

-(void) setTextColor:(UIColor*)color;
-(UIColor*) getTextColor;

-(void) setBackgroundColor:(UIColor*)color;
-(UIColor*) getBackgroundColor;

-(void) setFont:(UIFont*)font;
-(UIFont*) getFont;

-(void) setUsername:(NSString*)txt;
-(NSString*) getUsername;

-(void) setPassword:(NSString*)txt;
-(NSString*) getPassword;

-(void) setEvernote:(NSNumber*)BoolValue;
-(NSNumber*) getEvernote;

-(void) setSendText:(NSNumber*)BoolValue;

@end
