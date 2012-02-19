//
//  CSRect.h
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 16..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSRect : CSGearObject

-(id) initGear;

-(void) setWidth:(NSNumber*)num;
-(NSNumber*) getWidth;

-(void) setHeight:(NSNumber*)num;
-(NSNumber*) getHeight;

-(void) setRectColor:(UIColor*)color;
-(UIColor*) getRectColor;

-(void) setBorderColor:(UIColor*)color;
-(UIColor*) getBorderColor;

-(void) setBorderWidth:(NSNumber*)num;
-(NSNumber*) getBorderWidth;

-(void) setCornerRadius:(NSNumber*)num;
-(NSNumber*) getCornerRadius;

@end
