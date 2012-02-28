//
//  CSCalc.h
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 24..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSCalc : CSGearObject
{
    CGFloat value1;
    CGFloat value2;
}

-(id) initGear;

-(void) setInput1Value:(NSNumber*) Value;
-(NSNumber*) getInput1Value;

-(void) setPlusValue:(NSNumber*) Value;
-(NSNumber*) getInput2Value;

-(void) setMinusValue:(NSNumber*) Value;

-(void) setMultiValue:(NSNumber*) Value;

-(void) setDivValue:(NSNumber*) Value;

@end
