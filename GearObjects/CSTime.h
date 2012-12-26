//
//  CSTime.h
//  AppSlate
//
//  Created by Taehan Kim on 12. 3. 2..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSTime : CSGearObject

-(id) initGear;

-(void) setNowAction:(NSNumber*) BoolValue;
-(NSNumber*) getNowAction;

@end
