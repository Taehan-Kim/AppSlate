//
//  CSSwitch.h
//  AppSlate
//
//  Created by 김태한 on 12. 01. 20..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSSwitch : CSGearObject
{
}

-(id) initGear;


-(void) setTintColor:(UIColor*)color;
-(UIColor*) getTintColor;

-(void) setOnValue:(NSNumber*)BoolValue;
-(NSNumber*) getOnValue;

@end
