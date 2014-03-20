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

-(void) setProgressTintColor:(UIColor*)color;
-(UIColor*) getProgressTintColor;

-(void) setTrackTintColor:(UIColor*)color;
-(UIColor*) getTrackTintColor;

-(void) setProgress:(NSNumber*)num;
-(NSNumber*) getProgress;

@end
