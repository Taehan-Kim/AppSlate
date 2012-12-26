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

-(void) setBaseString:(NSString*) value;
-(NSString*) getBaseString;

-(void) setVariableString:(NSString*) value;
-(NSString*) getVariableString;

@end
