//
//  CSProgressBar.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 23..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSProgressBar : CSGearObject

-(id) initGear;

-(void) setBarColor:(UIColor*)color;
-(UIColor*) getBarColor;

-(void) setTrackColor:(UIColor*)color;
-(UIColor*) getTrackColor;

-(void) setBarValue:(NSNumber*)num;
-(NSNumber*) getBarValue;

@end
