//
//  CSNot.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 16..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSNot : CSGearObject

-(id) initGear;

-(void) setInputValue:(NSNumber*) BoolValue;
-(NSNumber*) getInputValue;

@end
