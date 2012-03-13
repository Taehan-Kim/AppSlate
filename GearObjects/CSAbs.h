//
//  CSAbs.h
//  AppSlate
//
//  Created by 김태한 on 12. 2. 28..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSAbs : CSGearObject

-(id) initGear;

-(void) setInputValue:(NSNumber*) num;
-(NSNumber*) getInputValue;

@end
