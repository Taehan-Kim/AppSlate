//
//  CSTee.h
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 16..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSTee : CSGearObject

-(id) initGear;

-(void) setInputValue:(NSNumber*) BoolValue;
-(NSNumber*) getInputValue;

@end
