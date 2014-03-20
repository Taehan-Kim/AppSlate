//
//  CSClock.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 3. 22..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSClock.h"

@implementation CSClock

-(id) object
{
    return ((UIView*)csView);
}

//===========================================================================
#pragma mark -

-(void) setAddHour:(NSNumber*)hour
{
    if( [hour isKindOfClass:[NSString class]] )
        clock.addHour = [(NSString*)hour integerValue];
    else  if( [hour isKindOfClass:[NSNumber class]] )
        clock.addHour = [hour integerValue];
}

-(NSNumber*) getAddHour
{
    return @(clock.addHour);
}

-(void) setAddMin:(NSNumber*)min
{
    if( [min isKindOfClass:[NSString class]] )
        clock.addMin = [(NSString*)min integerValue];
    else  if( [min isKindOfClass:[NSNumber class]] )
        clock.addMin = [min integerValue];
}

-(NSNumber*) getAddMin
{
    return @(clock.addMin);
}

-(void) setAddSec:(NSNumber*)sec
{
    if( [sec isKindOfClass:[NSString class]] )
        clock.addSec = [(NSString*)sec integerValue];
    else  if( [sec isKindOfClass:[NSNumber class]] )
        clock.addSec = [sec integerValue];
}

-(NSNumber*) getAddSec
{
    return @(clock.addSec);
}

-(void) setOnValue:(NSNumber*)BoolValue
{
    bStart = [BoolValue boolValue];

    if( USERCONTEXT.imRunning ){
        if( bStart )
            [clock start];
        else
            [clock stop];
    }
}

-(NSNumber*) getOnValue
{
    return @(bStart);
}

-(void) setMoveHour:(NSNumber*)hour
{
    NSUInteger value;
    
    if( [hour isKindOfClass:[NSString class]] )
        value = [(NSString*)hour integerValue];
    else
        value = [hour integerValue];

    if( 24 < value ) value = 24;
    
    clock.hours = value;
    [clock updateForceClock];
}

-(NSNumber*) getMoveHour
{
    return @(clock.hours);
}

-(void) setMoveMin:(NSNumber*)min
{
    NSUInteger value;
    
    if( [min isKindOfClass:[NSString class]] )
        value = [(NSString*)min integerValue];
    else
        value = [min integerValue];

    if( 60 < value ) value = 60;
    
    clock.minutes = value;
    [clock updateForceClock];
}

-(NSNumber*) getMoveMin
{
    return @(clock.minutes);
}

-(void) setMoveSec:(NSNumber*)sec
{
    NSUInteger value;

    if( [sec isKindOfClass:[NSString class]] )
        value = [(NSString*)sec integerValue];
    else  value = [sec integerValue];

    if( 60 < value ) value = 60;

    clock.seconds = value;
    [clock updateForceClock];
}

-(NSNumber*) getMoveSec
{
    return @(clock.seconds);
}


#pragma mark -

-(void) turnOnClock
{
    if( bStart )
        [clock start];
}

-(void) turnOffClock
{
    [clock stop];
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
    
    csView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [csView setUserInteractionEnabled:YES];

    clock = [[ClockView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [clock setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    clock.addHour = 0;
    clock.addMin = 0;
    clock.addSec = 0;

    [csView addSubview:clock];

    csCode = CS_CLOCK;
    
    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Add Hour", P_NUM, @selector(setAddHour:),@selector(getAddHour));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Add Min", P_NUM, @selector(setAddMin:),@selector(getAddMin));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Add Second", P_NUM, @selector(setAddSec:),@selector(getAddSec));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"On Now", P_BOOL, @selector(setOnValue:),@selector(getOnValue));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"Move Hour hand", P_NUM, @selector(setMoveHour:),@selector(getMoveHour));
    NSDictionary *d6 = MAKE_PROPERTY_D(@"Move Min hand", P_NUM, @selector(setMoveMin:),@selector(getMoveMin));
    NSDictionary *d7 = MAKE_PROPERTY_D(@"Move Sec hand", P_NUM, @selector(setMoveSec:),@selector(getMoveSec));
    pListArray = @[xc,yc,d0,d1,d2,d3,d4,d5,d6,d7];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        clock = [csView subviews][0];
        clock.addHour = [decoder decodeIntegerForKey:@"addHour"];
        clock.addMin = [decoder decodeIntegerForKey:@"addMin"];
        clock.addSec = [decoder decodeIntegerForKey:@"addSec"];
        bStart = [decoder decodeBoolForKey:@"bStart"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeInteger:clock.addHour forKey:@"addHour"];
    [encoder encodeInteger:clock.addMin forKey:@"addMin"];
    [encoder encodeInteger:clock.addSec forKey:@"addSec"];
    [encoder encodeBool:bStart forKey:@"bStart"];
}

#pragma mark - Code Generator

-(NSArray*) importLinesCode
{
    return @[@"\"CSClock.h\""];
}

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"CSClock";
}

// 커스텀 클래스가 필요한 경우. 이 클래스의 get/set 메소드들은 모두 실제 CSGear 에서 사용하는 것과 같은 이름으로 사용하도록 한다. 코드 자동 생성기가 메소드 이름을 가지고 코드를 만들 수 있게 하기 위해서이다.
-(NSString*) customClass
{
    NSString *r = @"\n\n// CSClock class\n//\n#import <QuartzCore/QuartzCore.h>\n\
@interface CSClock : UIView\n\{\n\
    CALayer *containerLayer;\n    CALayer *hourHand;\n\
    CALayer *minHand;\n    CALayer *secHand;\n\
    NSTimer *timer;\n    BOOL night_view;\n\
    NSInteger seconds, minutes, hours;\n\
}\n\
@property (nonatomic)    NSInteger moveHour, moveMin, moveSec;\n\
@property (nonatomic)    NSInteger addHour, addMin, addSec;\n\
@property (nonatomic)    BOOL onValue;\n\
- (void)stop;\n\
-(void) setMoveHour:(NSNumber*)hour;\n-(void) setMoveMin:(NSNumber*)min;\n-(void) setMoveSec:(NSNumber*)sec;\n@end\n\n\
@implementation CSClock\n\n@synthesize addHour, addMin, addSec;\n@synthesize onValue;\n\n\
float Degrees2Radians(float degrees) { return degrees * M_PI / 180; }\n\
- (void)setOnValue:(NSNumber*)bValue\n{\n\
    if( nil == timer && bValue.boolValue )\n    {\n\
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateClock:) userInfo:nil repeats:YES];\n\
    } else if( timer ){\n\
        [self stop];\n    }\n}\n\n\
-(BOOL)getOnValue\n{\n\
    return ( timer == nil );\n}\n\n\
- (void) drawRect:(CGRect)rect\n{\n\
    UIColor *niddleColor;\n\n\
    CGContextRef context = UIGraphicsGetCurrentContext();\n\
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);\n\n\
    if( !night_view ){\n\
        CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);\n\
        niddleColor = [UIColor blackColor];\n    }else{\n\
        CGContextSetRGBFillColor(context, 0.2, 0.2, 0.2, 1.0);\n\
        niddleColor = [UIColor whiteColor];\n    }\n\
    CGContextSetLineWidth(context, 1.0);\n\
    CGContextFillEllipseInRect (context, CGRectInset(rect, 12, 12));\n\
    CGContextStrokeEllipseInRect(context, CGRectInset(rect, 12, 12));\n\n\
    CGPoint tip = CGPointMake( sinf(secAngle)*(self.center.x*0.7)+self.center.x , cosf(secAngle)*(self.center.y*-0.7)+self.center.y);\n\
    draw1PxStroke(UIGraphicsGetCurrentContext(), self.center, tip, [UIColor redColor].CGColor, 1.3);\n\
    tip = CGPointMake( sinf(minAngle)*(self.center.x*0.6)+self.center.x , cosf(minAngle)*(self.center.y*-0.6)+self.center.y);\n\
    draw1PxStroke(UIGraphicsGetCurrentContext(), self.center, tip, niddleColor.CGColor, 2.0);\n\
    tip = CGPointMake( sinf(hourAngle)*(self.center.x*0.45)+self.center.x , cosf(hourAngle)*(self.center.y*-0.45)+self.center.y);\n\
    draw1PxStroke(UIGraphicsGetCurrentContext(), self.center, tip, niddleColor.CGColor, 5.0);\n\n\
    CGContextFillPath(context);\n\
}\n\n\
- (void)stop\n{\n\
    if( timer ){\n\
        [timer invalidate];\n        timer = nil;\n\
    }\n}\n\n\
#define HOURS_HAND_LENGTH 0.45\n\
#define MIN_HAND_LENGTH 0.65\n\
#define SEC_HAND_LENGTH 0.65\n\
#define HOURS_HAND_WIDTH 8\n\
#define MIN_HAND_WIDTH 8\n\
#define SEC_HAND_WIDTH 2\n\n\
-(void) setMoveHour:(NSNumber*)hour\n{\n\
    NSUInteger value;\n\
    if( [hour isKindOfClass:[NSString class]] )\n\
        value = [(NSString*)hour integerValue];\n\
    else\n\
        value = [hour integerValue];\n\
    if( 24 < value ) value = 24;\n\
    hours = value;\n\
    [self updateClock];\n}\n\n\
-(void) setMoveMin:(NSNumber*)min\n{\n\
    NSUInteger value;\n\
    if( [min isKindOfClass:[NSString class]] )\n\
        value = [(NSString*)min integerValue];\n\
    else\n\
        value = [min integerValue];\n\
    if( 60 < value ) value = 60;\n\
    minutes = value;\n\
    [self updateClock];\n}\n\n\
-(void) setMoveSec:(NSNumber*)sec\n{\n\
    NSUInteger value;\n\
    if( [sec isKindOfClass:[NSString class]] )\n\
        value = [(NSString*)sec integerValue];\n\
    else  value = [sec integerValue];\n\
    if( 60 < value ) value = 60;\n\
    seconds = value;\n\
    [self updateClock];\n}\n\n\
- (void) updateClock:(NSTimer *)theTimer\n{\n\
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];\n\n\
    if( nil != theTimer )\n    {\n\
        seconds = [dateComponents second] + addSec;\n\
        minutes = [dateComponents minute] + addMin;\n\
        hours = [dateComponents hour] + addHour;\n\
    }\n    else {\n\
        seconds += addSec;\n        minutes += addMin;\n        hours += addHour;\n\
    }\n\n\
    if( minutes < 0 ) minutes *= -1;\n\
    if( seconds < 0 ) seconds *= -1;\n\n\
    if( hours > 24 || hours < -24 ) hours %= 24;\n\
    if( minutes > 60 ) minutes %= 60;\n\
    if( seconds > 60 ) seconds %= 60;\n\n\
    if( hours < 0 ) hours += 24;\n\n\
    if(( hours >= 19 || hours < 6 ) && NO == night_view ) {\n\
        night_view = YES;\n\
    }\n\
    else if(( hours < 19 & hours >= 6 ) && YES == night_view ) {\n\
        night_view = NO;\n\
    }\n\n\
    NSUInteger temphours = hours;\n\
    if (hours > 12) temphours -=12; //PM\n\n\
    //set angles for each of the hands\n\
    secAngle = Degrees2Radians(seconds/60.0*360);\n\
    minAngle = Degrees2Radians(minutes/60.0*360);\n\
    hourAngle = Degrees2Radians(temphours/12.0*360) + minAngle/12.0;\n\n\
    //reflect the rotations + 180 degres since CALayers coordinate system is inverted\n\
    [self setNeedsDisplay];\n}\n\n\
- (void) layoutSubviews\n{\n\
    [super layoutSubviews];\n\
    containerLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);\n\
    containerLayer.anchorPoint = CGPointMake(0.5, 0.5);\n}\n\n\
- (id)initWithFrame:(CGRect)frame\n{\n\
    self = [super initWithFrame:frame];\n\
    if (self) {\n\
        containerLayer = [CALayer layer];\n\
        timer = nil;\n\n\
        //default appearance\n\
        self.clipsToBounds = YES;\n\
        self.layer.cornerRadius = 8.0;\n\n\
        //add all created sublayers\n\
        [self.layer addSublayer:containerLayer];\n    }\n    return self;\n}\n\n\
- (void)dealloc\n{\n\
    [self stop];\n}\n\n\
@end\n\n";

    return r;
}

@end
