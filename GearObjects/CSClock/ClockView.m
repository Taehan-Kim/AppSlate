//
//  ClockView.m
//  clock
//
//  Created by Ignacio Enriquez Gutierrez on 1/31/11.
//  Copyright 2011 Nacho4D. All rights reserved.
//  See the file License.txt for copying permission.
//

#import "ClockView.h"


@implementation ClockView

@synthesize addHour, addMin, addSec;
@synthesize hours, minutes, seconds;


float Degrees2Radians(float degrees);

#pragma mark - Public Methods

- (void)start
{
    if( nil == timer )
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateClock:) userInfo:nil repeats:YES];
    }
}

- (void)stop
{
    if( timer ){
        [timer invalidate];
        timer = nil;
    }
}

-(BOOL) isStarted
{
    return ( timer == nil );
}

//customize appearence
- (void)setHourHandImage:(CGImageRef)image
{
	if (image == NULL) {
		hourHand.backgroundColor = [UIColor blackColor].CGColor;
		hourHand.cornerRadius = 3;
	}else{
		hourHand.backgroundColor = [UIColor clearColor].CGColor;
		hourHand.cornerRadius = 0.0;
		
	}
	hourHand.contents = (__bridge id)image;
}

- (void)setMinHandImage:(CGImageRef)image
{
	if (image == NULL) {
		minHand.backgroundColor = [UIColor grayColor].CGColor;
	}else{
		minHand.backgroundColor = [UIColor clearColor].CGColor;
	}
	minHand.contents = (__bridge id)image;
}

- (void)setSecHandImage:(CGImageRef)image
{
	if (image == NULL) {
		secHand.backgroundColor = [UIColor whiteColor].CGColor;
		secHand.borderWidth = 1.0;
		secHand.borderColor = [UIColor grayColor].CGColor;
	}else{
		secHand.backgroundColor = [UIColor clearColor].CGColor;
		secHand.borderWidth = 0.0;
		secHand.borderColor = [UIColor clearColor].CGColor;
	}
	secHand.contents = (__bridge id)image;
}

- (void)setClockBackgroundImage:(CGImageRef)image
{
	if (image == NULL) {
		containerLayer.borderColor = [UIColor blackColor].CGColor;
		containerLayer.borderWidth = 1.0;
		containerLayer.cornerRadius = 5.0;
	}else{
		containerLayer.borderColor = [UIColor clearColor].CGColor;
		containerLayer.borderWidth = 0.0;
		containerLayer.cornerRadius = 0.0;
	}
	containerLayer.contents = (__bridge id)image;
}

#pragma mark - Private Methods

//Default sizes of hands:
//in percentage (0.0 - 1.0)
#define HOURS_HAND_LENGTH 0.45
#define MIN_HAND_LENGTH 0.65
#define SEC_HAND_LENGTH 0.65
//in pixels
#define HOURS_HAND_WIDTH 8
#define MIN_HAND_WIDTH 8
#define SEC_HAND_WIDTH 2

float Degrees2Radians(float degrees) { return degrees * M_PI / 180; }

// ㄷ타이머 동작하지 않을 때 강제로 시계를 갱신하도록 할 경우 사용한다.
- (void) updateForceClock
{
    [self updateClock:nil];
}

//timer callback
- (void) updateClock:(NSTimer *)theTimer
{	
	NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];

    if( nil != theTimer )
    {
        seconds = [dateComponents second] + addSec;
        minutes = [dateComponents minute] + addMin;
        hours = [dateComponents hour] + addHour;
    }
    else {
        seconds += addSec;
        minutes += addMin;
        hours += addHour;
    }

	//NSLog(@"raw: hours:%d min:%d secs:%d", hours, minutes, seconds);

    if( minutes < 0 ) minutes *= -1;
    if( seconds < 0 ) seconds *= -1;

    if( hours > 24 || hours < -24 ) hours %= 24;
    if( minutes > 60 ) minutes %= 60;
    if( seconds > 60 ) seconds %= 60;

    if( hours < 0 ) hours += 24;

    if(( hours >= 19 || hours < 6 ) && NO == night_view ) {
        [self setClockBackgroundImage:[UIImage imageNamed:@"clock-background-night.png"].CGImage];
		[self setHourHandImage:[UIImage imageNamed:@"clock-hour-wg.png"].CGImage];
		[self setMinHandImage:[UIImage imageNamed:@"clock-min-wg.png"].CGImage];
        night_view = YES;
    }
    else if(( hours < 19 & hours >= 6 ) && YES == night_view ) {
        [self setClockBackgroundImage:[UIImage imageNamed:@"clock-background-day.png"].CGImage];
		[self setHourHandImage:[UIImage imageNamed:@"clock-hour-bg.png"].CGImage];
		[self setMinHandImage:[UIImage imageNamed:@"clock-min-bg.png"].CGImage];
        night_view = NO;
    }
    NSUInteger temphours = hours;
	if (hours > 12) temphours -=12; //PM

	//set angles for each of the hands
	CGFloat secAngle = Degrees2Radians(seconds/60.0*360);
	CGFloat minAngle = Degrees2Radians(minutes/60.0*360);
	CGFloat hourAngle = Degrees2Radians(temphours/12.0*360) + minAngle/12.0;
	
	//reflect the rotations + 180 degres since CALayers coordinate system is inverted
	secHand.transform = CATransform3DMakeRotation (secAngle+M_PI, 0, 0, 1);
	minHand.transform = CATransform3DMakeRotation (minAngle+M_PI, 0, 0, 1);
	hourHand.transform = CATransform3DMakeRotation (hourAngle+M_PI, 0, 0, 1);
}

#pragma mark - Overrides

- (void) layoutSubviews
{
	[super layoutSubviews];

	containerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);

	float length = MIN(self.frame.size.width, self.frame.size.height)/2;
	CGPoint c = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
	hourHand.position = minHand.position = secHand.position = c;

	CGFloat w, h;

//	if (hourHand.contents == NULL){
		w = HOURS_HAND_WIDTH;
		h = length*HOURS_HAND_LENGTH;
//	}else{
//		w = CGImageGetWidth((__bridge CGImageRef)hourHand.contents);
//		h = CGImageGetHeight((__bridge CGImageRef)hourHand.contents);
//	}
	hourHand.bounds = CGRectMake(0,0,w,h);
	
//	if (minHand.contents == NULL){
		w = MIN_HAND_WIDTH;
		h = length*MIN_HAND_LENGTH;
//	}else{
//		w = CGImageGetWidth((__bridge CGImageRef)minHand.contents);
//		h = CGImageGetHeight((__bridge CGImageRef)minHand.contents);
//	}
	minHand.bounds = CGRectMake(0,0,w,h);
	
//	if (secHand.contents == NULL){
		w = SEC_HAND_WIDTH;
		h = length*SEC_HAND_LENGTH;
//	}else{
//		w = CGImageGetWidth((__bridge CGImageRef)secHand.contents);
//		h = CGImageGetHeight((__bridge CGImageRef)secHand.contents);
//	}
	secHand.bounds = CGRectMake(0,0,w,h);

	hourHand.anchorPoint = CGPointMake(0.5,0.0);
	minHand.anchorPoint = CGPointMake(0.5,0.0);
	secHand.anchorPoint = CGPointMake(0.5,0.0);
	containerLayer.anchorPoint = CGPointMake(0.5, 0.5);
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		
		containerLayer = [CALayer layer];
		hourHand = [CALayer layer];
		minHand = [CALayer layer];
		secHand = [CALayer layer];
        timer = nil;

		//default appearance
		[self setClockBackgroundImage:NULL];
		[self setHourHandImage:[UIImage imageNamed:@"clock-hour-bg.png"].CGImage];
		[self setMinHandImage:[UIImage imageNamed:@"clock-min-bg.png"].CGImage];
		[self setSecHandImage:[UIImage imageNamed:@"clock-sec-bg.png"].CGImage];
		
		//add all created sublayers
		[containerLayer addSublayer:hourHand];
		[containerLayer addSublayer:minHand];
		[containerLayer addSublayer:secHand];
		[self.layer addSublayer:containerLayer];
	}
	return self;
}

- (void)dealloc
{
	[self stop];
}

#pragma mark -

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
		containerLayer = [CALayer layer];
		hourHand = [CALayer layer];
		minHand = [CALayer layer];
		secHand = [CALayer layer];
        
		//default appearance
		[self setClockBackgroundImage:NULL];
		[self setHourHandImage:[UIImage imageNamed:@"clock-hour-bg.png"].CGImage];
		[self setMinHandImage:[UIImage imageNamed:@"clock-min-bg.png"].CGImage];
		[self setSecHandImage:[UIImage imageNamed:@"clock-sec-bg.png"].CGImage];
		
		//add all created sublayers
		[containerLayer addSublayer:hourHand];
		[containerLayer addSublayer:minHand];
		[containerLayer addSublayer:secHand];
		[self.layer addSublayer:containerLayer];
    }
    return self;
}


@end