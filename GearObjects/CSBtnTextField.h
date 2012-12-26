//
//  CSBtnTextField.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 11. 11. 14..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"
#import "BButton.h"

@interface CSBtnTextField : CSGearObject <UITextFieldDelegate>
{
    UITextField *txtField;
    BButton *confirmButton;
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

-(void) setTextAlignment:(NSNumber*)alignNum;
-(NSNumber *) getTextAlignment;

-(void) setButtonBackgroundColor:(UIColor*)color;
-(UIColor*) getButtonBackgroundColor;

-(void) setButtonText:(NSString*)txt;
-(NSString*) getButtonText;

@end
