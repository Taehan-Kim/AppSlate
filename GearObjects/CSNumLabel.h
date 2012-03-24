//
//  CSNumLabel.h
//  AppSlate
//
//  Created by 김 태한 on 12. 3. 14..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSGearObject.h"

@interface CSNumLabel : CSGearObject
{
    BOOL showComma;
    CGFloat number;
}

-(id) initGear;


-(void) setNumber:(NSNumber*)num;
-(NSNumber*) getNumber;

-(void) setShowComma:(NSNumber*)BoolValue;
-(NSNumber*) getShowComma;

-(void) setTextColor:(UIColor*)color;
-(UIColor*) getTextColor;

-(void) setBackgroundColor:(UIColor*)color;
-(UIColor*) getBackgroundColor;

-(void) setFont:(UIFont*)font;
-(UIFont*) getFont;

-(void) setTextAlignment:(NSNumber*)alignNum;
-(NSNumber *) getTextAlignment;

-(void) setRoundBorder:(NSNumber*)BoolValue;
-(NSNumber*) getRoundBorder;

@end
