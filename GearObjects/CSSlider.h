//
//  CSSlider.h
//  AppSlate
//
//  Created by Taehan Kim on 12. 01. 27..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSSlider : CSGearObject
{
}

-(id) initGear;


-(void) setMinimumBarColor:(UIColor*)color;
-(UIColor*) getMinimumBarColor;

-(void) setMaximumBarColor:(UIColor*)color;
-(UIColor*) getMaximumBarColor;

-(void) setThumbColor:(UIColor*)color;
-(UIColor*) getThumbColor;

-(void) setMinimumValue:(NSNumber*)number;
-(NSNumber*) getMinimumValue;

-(void) setMaximumValue:(NSNumber*)number;
-(NSNumber*) getMaximumValue;

-(void) setThumbValue:(NSNumber*)number;
-(NSNumber*) getThumbValue;

-(void) setContinuosChange:(NSNumber*)boolVal;
-(NSNumber*) getContinuosChange;

@end
