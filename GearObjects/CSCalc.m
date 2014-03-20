//
//  CSCalc.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 24..
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

-(void) setPlusValueAction:(NSNumber*) Value
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

-(void) setMinusValueAction:(NSNumber*) Value
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

-(void) setMultiValueAction:(NSNumber*) Value
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


-(void) setDivValueAction:(NSNumber*) Value
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
    if( !(self = [super init]) ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_calc.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_CALC;

    csResizable = NO;
    csShow = NO;
    resultSave = NO;
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Input #1", P_NUM, @selector(setInput1Value:),@selector(getInput1Value));
    NSDictionary *d2 = MAKE_PROPERTY_D(@">Input for Plus", P_NUM, @selector(setPlusValueAction:),@selector(getInput2Value));
    NSDictionary *d3 = MAKE_PROPERTY_D(@">Input for Minus", P_NUM, @selector(setMinusValueAction:),@selector(getInput2Value));
    NSDictionary *d4 = MAKE_PROPERTY_D(@">Input for Multiplication", P_NUM, @selector(setMultiValueAction:),@selector(getInput2Value));
    NSDictionary *d5 = MAKE_PROPERTY_D(@">Input for Division", P_NUM, @selector(setDivValueAction:),@selector(getInput2Value));
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

#pragma mark - Code Generator

-(NSArray*) importLinesCode
{
    return @[@"\"CSLGate.h\""];
}

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"CSLGate";
}

// viewDidLoad 에서 alloc - init 하지 않을 것일때는 NO_FIRST_ALLOC 을 리턴하자.
-(NSString*) customClass
{
    NSString *r = @"\n\n// CSLGate class\n//\n@interface CSLGate : NSObject\n\{\n}\n\n\
@property (assign)    BOOL input1Value, input2Value;\n@end\n\n\
@implementation CSLGate\n\n@synthesize input1Value, input2Value;\n\n\
@end\n\n";
    return r;
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    SEL act;
    NSNumber *nsMagicNum;
    NSMutableString *rs = [[NSMutableString alloc] initWithCapacity:100];

    if( [apName isEqualToString:@"setPlusValueAction:"] ){
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( act )
        {
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            const char *sel_name_c = sel_getName(act);
            [rs appendFormat:@"%@.input2Value = %@;\n    [%@ %@(%@.input1Value+%@.input2Value)];\n",varName,val, [gObj getVarName],@(sel_name_c),varName,varName];
            if( resultSave )
                [rs appendFormat:@"    %@.input1Value = (%@.input1Value+%@.input2Value);\n",varName,varName,varName];
        }
    }

    if( [apName isEqualToString:@"setMinusValueAction:"] ){
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( act )
        {
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            const char *sel_name_c = sel_getName(act);
            [rs appendFormat:@"%@.input2Value = %@;\n    [%@ %@(%@.input1Value-%@.input2Value)];\n",varName,val, [gObj getVarName],@(sel_name_c),varName,varName];
            if( resultSave )
                [rs appendFormat:@"    %@.input1Value = (%@.input1Value-%@.input2Value);\n",varName,varName,varName];
        }
    }

    if( [apName isEqualToString:@"setMultiValueAction:"] ){
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( act )
        {
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            const char *sel_name_c = sel_getName(act);
            [rs appendFormat:@"%@.input2Value = %@;\n    [%@ %@(%@.input1Value*%@.input2Value)];\n",varName,val, [gObj getVarName],@(sel_name_c),varName,varName];
            if( resultSave )
                [rs appendFormat:@"    %@.input1Value = (%@.input1Value*%@.input2Value);\n",varName,varName,varName];
        }
    }

    if( [apName isEqualToString:@"setDivValueAction:"] ){
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( act )
        {
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            const char *sel_name_c = sel_getName(act);
            [rs appendFormat:@"%@.input2Value = %@;\n    [%@ %@(%@.input1Value/%@.input2Value)];\n",varName,val, [gObj getVarName],@(sel_name_c),varName,varName];
            if( resultSave )
                [rs appendFormat:@"    %@.input1Value = (%@.input1Value/%@.input2Value);\n",varName,varName,varName];
        }
    }

    if( [rs length] ) return rs;
    return nil;
}

@end
