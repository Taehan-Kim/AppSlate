//
//  CSStrComp.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 2. 23..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSStrComp.h"

@implementation CSStrComp

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setInput1Str:(NSString*) value
{
    if( [value isKindOfClass:[NSString class]] )
        base = value;
    else  if( [value isKindOfClass:[NSNumber class]] )
        base = [(NSNumber*)value stringValue];
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
                NSComparisonResult result;
                result = [base compare:var];

                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@(result)];
                else
                    EXCLAMATION;
            }
        }        
    }
}

-(NSString*) getInput1Str
{
    return base;
}

-(void) setVariableStringAction:(NSString*) value
{
    if( [value isKindOfClass:[NSString class]] )
        var = value;
    else  if( [value isKindOfClass:[NSNumber class]] )
        var = [(NSNumber*)value stringValue];
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
                NSComparisonResult result = [base compare:var];
                
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@(result)];
                else
                    EXCLAMATION;
            }
        }        
    }
}

-(NSString*) getVariableString
{
    return var;
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_strcomp.png"]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_STRCOMP;

    csResizable = NO;
    csShow = NO;

    base = @"";
    var = @"";
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Base String", P_TXT, @selector(setInput1Str:),@selector(getInput1Str));
    NSDictionary *d2 = MAKE_PROPERTY_D(@">Input String", P_TXT, @selector(setVariableStringAction:),@selector(getVariableString));
    pListArray = @[d1,d2];

    NSMutableDictionary MAKE_ACTION_D(@"Result", A_NUM, a1);
    actionArray = @[a1];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_strcomp.png"]];
        base = [decoder decodeObjectForKey:@"base"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:base forKey:@"base"];
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
@property (assign)    CGFloat input1Value, input2Value;\n@end\n\n\
@property (nonatomic,retain)    NSString *input1Str, *input2Str;\n@end\n\n\
@implementation CSNumStrGate\n\n@synthesize input1Value, input2Value, input1Str, input2Str;\n\n\
@end\n\n";
    return r;
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    if( [apName isEqualToString:@"setVariableStringAction:"] ){
        SEL act;
        NSNumber *nsMagicNum;
        NSMutableString *rs = [[NSMutableString alloc] initWithCapacity:100];
        
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( act )
        {
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            const char *sel_name_c = sel_getName(act);
            [rs appendFormat:@"%@.input2Str = %@;\n    NSComparisonResult result = [%@.input1Str compare:%@.input2Str];\n",varName,val, varName,varName];
            [rs appendFormat:@"    [%@ %@@(result)];\n", [gObj getVarName], @(sel_name_c)];
            return rs;
        }
    }
    return nil;
}

@end
