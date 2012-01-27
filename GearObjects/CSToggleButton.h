//
//  CSToggleButton.h
//  AppSlate
//
//  Created by 김태한 on 12. 01. 20..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"
#import "BButton.h"

@interface CSToggleButton : CSGearObject
{
    BOOL toggleValue;
    UIColor *onColor;
    UIColor *offColor;
    NSString *onText;
    NSString *offText;
}

-(id) initGear;


-(void) setOnTintColor:(UIColor*)color;
-(UIColor*) getOnTintColor;

-(void) setOffTintColor:(UIColor*)color;
-(UIColor*) getOffTintColor;

-(void) setOnText:(NSString*)txt;
-(NSString*) getOnText;

-(void) setOffText:(NSString*)txt;
-(NSString*) getOffText;

-(void) setTextColor:(UIColor*)color;
-(UIColor*) getTextColor;

-(void) setFont:(UIFont*)font;
-(UIFont*) getFont;

@end
