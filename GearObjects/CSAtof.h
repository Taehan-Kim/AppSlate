//
//  CSAtof.h
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 24..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSAtof : CSGearObject

-(id) initGear;

-(void) setInputString:(NSString*) str;
-(NSString*) getInputString;

@end
