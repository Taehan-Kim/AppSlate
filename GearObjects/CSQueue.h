//
//  CSQueue.h
//  AppSlate
//
//  Created by Taehan Kim on 12. 3. 10..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSQueue : CSGearObject
{
    NSMutableArray *queue;
}

-(id) initGear;

-(void) setPushValue:(id) object;
-(id) getPushValue;

-(void) setPop:(NSNumber*) BoolValue;
-(NSNumber*) getPop;

-(void) removeAll;

@end
