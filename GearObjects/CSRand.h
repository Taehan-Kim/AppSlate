//
//  CSRand.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 28..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSGearObject.h"

@interface CSRand : CSGearObject
{
    NSInteger minValue, maxValue;
}

-(id) initGear;

-(void) setRequest:(NSNumber*)BoolValue;
-(NSNumber*) getRequest;

-(void) setMinValue:(NSNumber*)val;
-(NSNumber*) getMinValue;

-(void) setMaxValue:(NSNumber*)val;
-(NSNumber*) getMaxValue;

@end
