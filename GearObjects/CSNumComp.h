//
//  CSNumComp.h
//  AppSlate
//
//  Created by Taehan Kim on 12. 2. 23..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSNumComp : CSGearObject
{
    CGFloat base, var;
}

-(id) initGear;

-(void) setInput1Value:(NSNumber*) value;
-(NSNumber*) getInput1Value;

-(void) setVariableValueAction:(NSNumber*) value;
-(NSNumber*) getVariableValue;

@end
