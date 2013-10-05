//
//  CSTick.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 28..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSTick.h"

@implementation CSTick

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setRun:(NSNumber*)BoolValue
{
    if( [BoolValue isKindOfClass:[NSString class]] )
        run = [(NSString*)BoolValue boolValue];
    else  if( [BoolValue isKindOfClass:[NSNumber class]] )
        run = [BoolValue boolValue];
    else
        return;

    if( run ){
        mTimer = [NSTimer timerWithTimeInterval:interval target:self
                                       selector:@selector(tickMethod:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:mTimer forMode:NSDefaultRunLoopMode];
        [mTimer fire];
    } else {
        [mTimer invalidate];
        mTimer = nil;
    }
}

-(NSNumber*) getRun
{
    return @(run);
}

-(void) setInterval:(NSNumber*)time
{
    if( ![time isKindOfClass:[NSNumber class]] )
        return;

    interval = [time floatValue];

    if( run ){
        [mTimer invalidate];
        mTimer = [NSTimer timerWithTimeInterval:interval target:self
                                       selector:@selector(tickMethod:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:mTimer forMode:NSDefaultRunLoopMode];
        [mTimer fire];
    }
}

-(NSNumber*) getInterval
{
    return @(interval);
}

-(void) setOutputValue:(NSNumber*)output
{
    if( [output isKindOfClass:[NSString class]] )
        outputNum = [(NSString*)output floatValue];
    else if( [output isKindOfClass:[NSNumber class]] )
        outputNum = [output floatValue];
    else
        return;

    outputNum = [output floatValue];
}

-(NSNumber*) getOutputValue
{
    return @(outputNum);
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_tick.png"]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_TICK;

    csResizable = NO;
    csShow = NO;

    interval = 1.0;
    outputNum = 1.0;
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Timer Run", P_BOOL, @selector(setRun:),@selector(getRun));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Interval seconds", P_NUM, @selector(setInterval:),@selector(getInterval));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Output Value", P_NUM, @selector(setOutputValue:),@selector(getOutputValue));
    pListArray = @[d1,d2,d3];
    
    NSMutableDictionary MAKE_ACTION_D(@"Output", A_NUM, a1);
    actionArray = @[a1];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_tick.png"]];
        run = [decoder decodeBoolForKey:@"run"];
        outputNum = [decoder decodeFloatForKey:@"outputNum"];
        interval = [decoder decodeFloatForKey:@"interval"];
        if( run ){
            mTimer = [NSTimer timerWithTimeInterval:interval target:self
                                           selector:@selector(tickMethod:) userInfo:nil repeats:YES];
            [mTimer fire];
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeFloat:interval forKey:@"interval"];
    [encoder encodeBool:run forKey:@"run"];
    [encoder encodeFloat:outputNum forKey:@"outputNum"];
}

#pragma mark -

- (void) tickMethod:(NSTimer*)timer
{
    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@(outputNum)];
                else
                    EXCLAMATION;
            }
        }
    }
}

@end
