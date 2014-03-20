//
//  CSAbs.h
//  AppSlate
//
//  Created by Taehan Kim on 12. 2. 28..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSAbs : CSGearObject

-(id) initGear;

-(void) setInputValueAction:(NSNumber*) num;
-(NSNumber*) getInputValue;

@end
