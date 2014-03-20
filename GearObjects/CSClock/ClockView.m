//
//  ClockView.m
//  clock
//
//  2012 Modified for AppSlate

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


- (void) drawRect:(CGRect)rect
{
    UIColor *niddleColor;

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);

    if( !night_view ){
        CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
        niddleColor = [UIColor blackColor];
    }else{
        CGContextSetRGBFillColor(context, 0.2, 0.2, 0.2, 1.0);
        niddleColor = [UIColor whiteColor];
    }
    CGContextSetLineWidth(context, 1.0);
    CGContextFillEllipseInRect (context, CGRectInset(rect, 12, 12));
    CGContextStrokeEllipseInRect(context, CGRectInset(rect, 12, 12));

    CGPoint tip = CGPointMake( sinf(secAngle)*(self.center.x*0.7)+self.center.x , cosf(secAngle)*(self.center.y*-0.7)+self.center.y);
    draw1PxStroke(UIGraphicsGetCurrentContext(), self.center, tip, [UIColor redColor].CGColor, 1.3);
    tip = CGPointMake( sinf(minAngle)*(self.center.x*0.6)+self.center.x , cosf(minAngle)*(self.center.y*-0.6)+self.center.y);
    draw1PxStroke(UIGraphicsGetCurrentContext(), self.center, tip, niddleColor.CGColor, 2.0);
    tip = CGPointMake( sinf(hourAngle)*(self.center.x*0.45)+self.center.x , cosf(hourAngle)*(self.center.y*-0.45)+self.center.y);
    draw1PxStroke(UIGraphicsGetCurrentContext(), self.center, tip, niddleColor.CGColor, 5.0);

    CGContextFillPath(context);
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

// 타이머 동작하지 않을 때 강제로 시계를 갱신하도록 할 경우 사용한다.
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
        night_view = YES;
    }
    else if(( hours < 19 & hours >= 6 ) && YES == night_view ) {
        night_view = NO;
    }

    NSUInteger temphours = hours;
	if (hours > 12) temphours -=12; //PM

	//set angles for each of the hands
	secAngle = Degrees2Radians(seconds/60.0*360);
	minAngle = Degrees2Radians(minutes/60.0*360);
	hourAngle = Degrees2Radians(temphours/12.0*360) + minAngle/12.0;
	
	//reflect the rotations + 180 degres since CALayers coordinate system is inverted
    [self setNeedsDisplay];
}

#pragma mark - Overrides

- (void) layoutSubviews
{
	[super layoutSubviews];

	containerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	containerLayer.anchorPoint = CGPointMake(0.5, 0.5);
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		
		containerLayer = [CALayer layer];
        timer = nil;

		//default appearance
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8.0;
		
		//add all created sublayers
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
        
		//default appearance
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8.0;
		
		//add all created sublayers
		[self.layer addSublayer:containerLayer];
    }
    return self;
}


@end