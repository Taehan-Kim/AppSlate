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
    if( !(self = [super init]) ) return nil;
    
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

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"NSTimer";
}

-(NSString*) customClass
{
    NSString *r = [NSString stringWithFormat:@"    %@ = [NSTimer timerWithTimeInterval:%.2f target:self\n\
        selector:@selector(%@Tick:) userInfo:nil repeat:YES];\n\
    [[NSRunLoop mainRunLoop] addTimer:mTimer forMode:NSDefaultRunLoopMode];\n\
    [%@ fire];\n",
                   varName,interval,varName,varName];
    return r;
}

-(NSString*) actionCode
{
    NSMutableString *code = [[NSMutableString alloc] initWithFormat:@"-(void)%@Tick\n{\n",varName];
    
    SEL act;
    NSNumber *nsMagicNum;
    
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        NSString *selNameStr = [NSString stringWithCString:sel_name_c encoding:NSUTF8StringEncoding];
        
        // Action Property 에 연결되는 경우는 각각 별도의 코드를 주문 받아서 수행한다.
        if( [selNameStr hasSuffix:@"Action:"] )
        {
            [code appendFormat:@"    %@\n",[gObj actionPropertyCode:selNameStr valStr:[NSString stringWithFormat:@"%.2f",outputNum]]];
        }
        else
            [code appendFormat:@"    [%@ %@%.2f];\n",[gObj getVarName],@(sel_name_c),outputNum];
    }
    [code appendString:@"}\n"];

    return code;
}

@end
