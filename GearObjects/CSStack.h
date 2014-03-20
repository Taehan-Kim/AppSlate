//
//  CSStack.h
//  AppSlate
//
//  Created by Taehan Kim on 12. 3. 10..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSStack : CSGearObject
{
    NSMutableArray *stack;
}

-(id) initGear;

-(void) setPushValueAction:(id) object;
-(id) getPushValue;

-(void) setPopAction:(NSNumber*) BoolValue;
-(NSNumber*) getPop;

-(void) removeAll;

@end
