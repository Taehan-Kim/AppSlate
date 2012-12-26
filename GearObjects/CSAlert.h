//
//  CSAlert.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 16..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSAlert : CSGearObject <UIAlertViewDelegate>
{
    NSString *message, *btn1, *btn2;
}

-(id) initGear;

-(void) setText:(NSString*)txt;
-(NSString*) getText;

-(void) setButton1Text:(NSString*)txt;
-(NSString*) getButton1Text;

-(void) setButton2Text:(NSString*)txt;
-(NSString*) getButton2Text;

-(void) setShow:(NSNumber*)BoolValue;
-(NSNumber*) getShow;

@end
