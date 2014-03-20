//
//  CSNote.h
//  AppSlate
//
//  Created by Taehan Kim on 12. 3. 20..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSNote : CSGearObject <UITextViewDelegate, UIAlertViewDelegate>
{
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

-(void) setSendTextAction:(NSNumber*)BoolValue;

@end
