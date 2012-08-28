//
//  CSCalc.m
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 24..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSCalc.h"

@implementation CSCalc

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setInput1Value:(NSNumber*) Value
{
    if( [Value isKindOfClass:[NSString class]] )
        value1 = [(NSString*)Value floatValue];
    else if( [Value isKindOfClass:[NSNumber class]] )
        value1 = [Value floatValue];
}

-(NSNumber*) getInput1Value
{
    return @(value1);
}

-(void) setPlusValue:(NSNumber*) Value
{
    if( [Value isKindOfClass:[NSString class]] )
        value2 = [(NSString*)Value floatValue];
    else if( [Value isKindOfClass:[NSNumber class]] )
        value2 = [Value floatValue];
    else
        return;
    
    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] ){
                    [gObj performSelector:act withObject:@(value1 + value2)];
                    if( resultSave )
                        value1 = (value1 + value2);
                }else
                    EXCLAMATION;
            }
        }
    }
}

-(NSNumber*) getInput2Value
{
    return @(value2);
}

-(void) setMinusValue:(NSNumber*) Value
{
    if( [Value isKindOfClass:[NSString class]] )
        value2 = [(NSString*)Value floatValue];
    else if( [Value isKindOfClass:[NSNumber class]] )
        value2 = [Value floatValue];
    else
        return;
    
    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] ){
                    [gObj performSelector:act withObject:@(value1 - value2)];
                    if( resultSave )
                        value1 = (value1 - value2);
                }else
                    EXCLAMATION;
            }
        }
    }
}

-(void) setMultiValue:(NSNumber*) Value
{
    if( [Value isKindOfClass:[NSString class]] )
        value2 = [(NSString*)Value floatValue];
    else if( [Value isKindOfClass:[NSNumber class]] )
        value2 = [Value floatValue];
    else
        return;
    
    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] ){
                    [gObj performSelector:act withObject:@(value1 * value2)];
                    if( resultSave )
                        value1 = (value1 * value2);
                }else
                    EXCLAMATION;
            }
        }
    }
}


-(void) setDivValue:(NSNumber*) Value
{
    if( [Value isKindOfClass:[NSString class]] )
        value2 = [(NSString*)Value floatValue];
    else if( [Value isKindOfClass:[NSNumber class]] )
        value2 = [Value floatValue];
    else
        return;

    if( 0 == value2 ){
        EXCLAMATION;
        return;   // divide by zero ?
    }

    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] ){
                    [gObj performSelector:act withObject:@(value1 / value2)];
                    if( resultSave )
                        value1 = (value1 / value2);
                }else
                    EXCLAMATION;
            }
        }
    }
}

-(void) setResultSave:(NSNumber*) BoolValue
{
    if( [BoolValue isKindOfClass:[NSString class]] )
        resultSave = [(NSString*)BoolValue boolValue];
    else  if( [BoolValue isKindOfClass:[NSNumber class]] )
        resultSave = [BoolValue boolValue];
}

-(NSNumber*) getResultSave
{
    return @(resultSave);
}


//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_calc.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_CALC;

    csResizable = NO;
    csShow = NO;

    self.info = NSLocalizedString(@"Calculator + - x /", @"calc");
    resultSave = NO;
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Input #1", P_NUM, @selector(setInput1Value:),@selector(getInput1Value));
    NSDictionary *d2 = MAKE_PROPERTY_D(@">Input for Plus", P_NUM, @selector(setPlusValue:),@selector(getInput2Value));
    NSDictionary *d3 = MAKE_PROPERTY_D(@">Input for Minus", P_NUM, @selector(setMinusValue:),@selector(getInput2Value));
    NSDictionary *d4 = MAKE_PROPERTY_D(@">Input for Multiplication", P_NUM, @selector(setMultiValue:),@selector(getInput2Value));
    NSDictionary *d5 = MAKE_PROPERTY_D(@">Input for Division", P_NUM, @selector(setDivValue:),@selector(getInput2Value));
    NSDictionary *d6 = MAKE_PROPERTY_D(@"Output Value Set Input #1 Also", P_BOOL, @selector(setResultSave:),@selector(getResultSave));
    pListArray = @[d1,d2,d3,d4,d5,d6];
    
    NSMutableDictionary MAKE_ACTION_D(@"Output", A_NUM, a1);
    actionArray = @[a1];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_calc.png"]];
        value1 = [decoder decodeFloatForKey:@"value1"];
        resultSave = [decoder decodeBoolForKey:@"resultSave"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeFloat:value1 forKey:@"value1"];
    [encoder encodeBool:resultSave forKey:@"resultSave"];
}

@end
