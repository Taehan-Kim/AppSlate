//
//  CSNumComp.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 2. 23..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSNumComp.h"

@implementation CSNumComp

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setInput1Value:(NSNumber*)num
{
    if( [num isKindOfClass:[NSString class]] )
        base = [(NSString*)num floatValue];
    else  if( [num isKindOfClass:[NSNumber class]] )
        base = [num floatValue];
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
                NSInteger result = 0;
                if( base > var ) result = -1;
                else if( base < var ) result = 1;

                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@(result)];
                else
                    EXCLAMATION;
            }
        }        
    }
}

-(NSNumber*) getInput1Value
{
    return @(base);
}

-(void) setVariableValueAction:(NSNumber*) num
{
    if( [num isKindOfClass:[NSString class]] )
        var = [(NSString*)num floatValue];
    else  if( [num isKindOfClass:[NSNumber class]] )
        var = [num floatValue];
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
                NSInteger result = 0;
                if( base > var ) result = -1;
                else if( base < var ) result = 1;
                
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@(result)];
                else
                    EXCLAMATION;
            }
        }        
    }
}

-(NSNumber*) getVariableValue
{
    return @(var);
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_numcomp.png"]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_NUMCOMP;

    csResizable = NO;
    csShow = NO;

    base = 0.0;
    var = 0.0;
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Base Number", P_NUM, @selector(setInput1Value:),@selector(getInput1Value));
    NSDictionary *d2 = MAKE_PROPERTY_D(@">Input Number", P_NUM, @selector(setVariableValueAction:),@selector(getVariableValue));
    pListArray = @[d1,d2];

    NSMutableDictionary MAKE_ACTION_D(@"Result", A_NUM, a1);
    actionArray = @[a1];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_numcomp.png"]];
        base = [decoder decodeFloatForKey:@"base"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeFloat:base forKey:@"base"];
}

#pragma mark - Code Generator

-(NSArray*) importLinesCode
{
    return @[@"\"CSNumStrGate.h\""];
}

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"CSNumStrGate";
}

// viewDidLoad 에서 alloc - init 하지 않을 것일때는 NO_FIRST_ALLOC 을 리턴하자.
-(NSString*) customClass
{
    NSString *r = @"\n\n// CSNumStrGate class\n//\n@interface CSNumStrGate : NSObject\n\{\n}\n\n\
@property (assign)    CGFloat input1Value, *input2Value;\n@end\n\n\
@property (nonatomic,retain)    NSString *input1Str, input2Str;\n@end\n\n\
@implementation CSNumStrGate\n\n@synthesize input1Value, input2Value, input1Str, input2Str;\n\n\
@end\n\n";
    return r;
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    if( [apName isEqualToString:@"setVariableValueAction:"] ){
        SEL act;
        NSNumber *nsMagicNum;
        NSMutableString *rs = [[NSMutableString alloc] initWithCapacity:100];

        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( act )
        {
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            const char *sel_name_c = sel_getName(act);
            [rs appendFormat:@"%@.input2Value = %@;\n    if(%@.input1Value == %@.input2Value) [%@ %@@(0)];\n",varName,val, varName,varName,[gObj getVarName],@(sel_name_c)];
            [rs appendFormat:@"    else [%@ %@((%@.input1Value>%@.input2Value)?@(-1):@(1))];\n", [gObj getVarName], @(sel_name_c),varName,varName];
            return rs;
        }
    }
    return nil;
}

@end
