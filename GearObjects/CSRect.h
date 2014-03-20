//
//  CSRect.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 16..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSRect : CSGearObject

-(id) initGear;

-(void) setWidthAction:(NSNumber*)num;
-(NSNumber*) getWidth;

-(void) setHeightAction:(NSNumber*)num;
-(NSNumber*) getHeight;

-(void) setBackgroundColor:(UIColor*)color;
-(UIColor*) getBackgroundColor;

-(void) setBorderColor:(UIColor*)color;
-(UIColor*) getBorderColor;

-(void) setBorderWidth:(NSNumber*)num;
-(NSNumber*) getBorderWidth;

-(void) setCornerRadius:(NSNumber*)num;
-(NSNumber*) getCornerRadius;

@end
