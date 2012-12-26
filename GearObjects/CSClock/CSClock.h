//
//  CSClock.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 3. 22..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"
#import "ClockView.h"

@interface CSClock : CSGearObject
{
    ClockView *clock;
    BOOL bStart;
}

-(id) initGear;

-(void) setAddHour:(NSNumber*)hour;
-(NSNumber*) getAddHour;

-(void) setAddMin:(NSNumber*)hour;
-(NSNumber*) getAddMin;

-(void) setAddSec:(NSNumber*)hour;
-(NSNumber*) getAddSec;

-(void) setMoveHour:(NSNumber*)hour;
-(NSNumber*) getMoveHour;

-(void) setMoveMin:(NSNumber*)hour;
-(NSNumber*) getMoveMin;

-(void) setMoveSec:(NSNumber*)hour;
-(NSNumber*) getMoveSec;


-(void) turnOnClock;
-(void) turnOffClock;

@end
