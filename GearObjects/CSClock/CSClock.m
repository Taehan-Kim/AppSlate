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
    if( ![super init] ) return nil;
    
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

@end
