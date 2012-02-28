//
//  CSTick.h
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 28..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSGearObject.h"

@interface CSTick : CSGearObject
{
    CGFloat outputNum;
    BOOL    run;
    CGFloat interval;
    NSTimer *mTimer;
}

-(id) initGear;

-(void) setRun:(NSNumber*)BoolValue;
-(NSNumber*) getRun;

-(void) setInterval:(NSNumber*)time;
-(NSNumber*) getInterval;

-(void) setOutputValue:(NSNumber*)output;
-(NSNumber*) getOutputValue;

@end
