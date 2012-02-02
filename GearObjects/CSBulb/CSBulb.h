//
//  CSBulb.h
//  AppSlate
//
//  Created by 김 태한 on 12. 1. 31..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSBulb : CSGearObject
{
    BOOL onValue;
    UIView *light;
}

-(id) initGear;
-(void) drawBulb;

-(void) setLightColor:(UIColor*)color;
-(UIColor*) getLightColor;

-(void) setOnValue:(NSNumber*)BoolValue;
-(NSNumber*) getOnValue;

@end
