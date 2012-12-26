//
//  CSLabel.h
//  AppSlate
//
//  Created by Taehan Kim on 11. 11. 10..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSLabel : CSGearObject
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

-(void) setTextAlignment:(NSNumber*)alignNum;
-(NSNumber *) getTextAlignment;

-(void) setLineNumber:(NSNumber*)number;
-(NSNumber*) getLineNumber;

-(void) setRoundBorder:(NSNumber*)BoolValue;
-(NSNumber*) getRoundBorder;

@end
