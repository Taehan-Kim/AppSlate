//
//  CSAccelero.h
//  AppSlate
//
//  Created by 김태한 on 12. 3. 3..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSAccelero : CSGearObject <UIAccelerometerDelegate>
{
    UIAccelerometer *ac;
//	UIAccelerationValue x, y, z;
    BOOL isRun;
}

-(id) initGear;

-(void) setActivate:(NSNumber*) BoolValue;
-(NSNumber*) getActivate;

@end
