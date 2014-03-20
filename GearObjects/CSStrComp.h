//
//  CSStrComp.h
//  AppSlate
//
//  Created by Taehan Kim on 12. 2. 23..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSStrComp : CSGearObject
{
    NSString *base, *var;
}

-(id) initGear;

-(void) setInput1Str:(NSString*) value;
-(NSString*) getInput1Str;

-(void) setVariableStringAction:(NSString*) value;
-(NSString*) getVariableString;

@end
