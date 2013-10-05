//
//  ClockView.h
//  clock
//
//  Created by Ignacio Enriquez Gutierrez on 1/31/11.
//  Copyright 2011 Nacho4D. All rights reserved.
//  See the file License.txt for copying permission.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ClockView : UIView {

	CALayer *containerLayer;
	CALayer *hourHand;
	CALayer *minHand;
	CALayer *secHand;
	NSTimer *timer;

    NSInteger seconds;
    NSInteger minutes;
    NSInteger hours;

    CGFloat secAngle, minAngle, hourAngle;
    BOOL night_view;
}

@property (nonatomic) NSInteger addHour, addMin, addSec;
@property (nonatomic) NSInteger hours, minutes, seconds;

//basic methods
- (void)start;
- (void)stop;
-(BOOL) isStarted;
- (void) updateForceClock;

//to customize hands size: adjust following values in .m file
//HOURS_HAND_LENGTH
//MIN_HAND_LENGTH
//SEC_HAND_LENGTH
//HOURS_HAND_WIDTH
//MIN_HAND_WIDTH
//SEC_HAND_WIDTH

@end
