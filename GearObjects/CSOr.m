//
//  CSOr.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 2. 17..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSOr.h"

@implementation CSOr

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setInput1Value:(NSNumber*) BoolValue
{    
    if( [BoolValue isKindOfClass:[NSString class]] )
        value1 = [(NSString*)BoolValue boolValue];
    else if( [BoolValue isKindOfClass:[NSNumber class]] )
        value1 = [BoolValue boolValue];
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
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@(value1 | value2)];
                else
                    EXCLAMATION;
            }
        }
        
    }
}

-(NSNumber*) getInput1Value
{
    return @(value1);
}

-(void) setInput2ValueAction:(NSNumber*) BoolValue
{    
    if( [BoolValue isKindOfClass:[NSString class]] )
        value2 = [(NSString*)BoolValue boolValue];
    else if( [BoolValue isKindOfClass:[NSNumber class]] )
        value2 = [BoolValue boolValue];
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
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@(value1 | value2)];
                else
                    EXCLAMATION;
            }
        }        
    }
}

-(NSNumber*) getInput2Value
{
    return @(value2);
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_or.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_OR;
    
    csResizable = NO;
    csShow = NO;
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Input #1", P_NUM, @selector(setInput1Value:),@selector(getInput1Value));
    NSDictionary *d2 = MAKE_PROPERTY_D(@">Input #2", P_NUM, @selector(setInput2ValueAction:),@selector(getInput2Value));
    pListArray = @[d1,d2];
    
    NSMutableDictionary MAKE_ACTION_D(@"Output", A_NUM, a1);
    actionArray = @[a1];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_or.png"]];
        value1 = [decoder decodeBoolForKey:@"value1"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeBool:value1 forKey:@"value1"];
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
    if( [apName isEqualToString:@"setInput2ValueAction:"] ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( act )
        {
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            const char *sel_name_c = sel_getName(act);
            return [NSString stringWithFormat:@"%@.input2Value = %@;\n    [%@ %@ %@.input1Value|%@.input2Value];\n",varName,val, [gObj getVarName],@(sel_name_c),varName,varName];
        }
    }
    return nil;
}

@end
