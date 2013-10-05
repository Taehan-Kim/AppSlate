//
//  CSAccelero.h
//  AppSlate
//
//  Created by Taehan Kim on 12. 3. 3..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "CSGearObject.h"

@interface CSAccelero : CSGearObject
{
    CMMotionManager *ac;
//	UIAccelerationValue x, y, z;
    BOOL isRun;
}

-(id) initGear;

-(void) setActivate:(NSNumber*) BoolValue;
-(NSNumber*) getActivate;

@end
