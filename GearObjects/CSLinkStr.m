//
//  CSLinkStr.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 3. 5..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSLinkStr.h"

@implementation CSLinkStr

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setInput1Str:(NSString*)string
{
    if( [string isKindOfClass:[NSString class]] )
        str1 = string;
    else if( [string isKindOfClass:[NSNumber class]] )
        str1 = [((NSNumber*)string) stringValue];
    else
        EXCLAMATION;
}

-(NSString*) getInput1Str
{
    return str1;
}

-(void) setInput2Str:(NSString*)string
{
    if( [string isKindOfClass:[NSString class]] )
        str2 = string;
    else if( [string isKindOfClass:[NSNumber class]] )
        str2 = [((NSNumber*)string) stringValue];
    else
        EXCLAMATION;
}

-(NSString*) getInput2Str
{
    return str2;
}

-(void) setInput3Str:(NSString*)string
{
    if( [string isKindOfClass:[NSString class]] )
        str3 = string;
    else if( [string isKindOfClass:[NSNumber class]] )
        str3 = [((NSNumber*)string) stringValue];
    else
        EXCLAMATION;
}

-(NSString*) getInput3Str
{
    return str3;
}

-(void) setInput4Str:(NSString*)string
{
    if( [string isKindOfClass:[NSString class]] )
        str4 = string;
    else if( [string isKindOfClass:[NSNumber class]] )
        str4 = [((NSNumber*)string) stringValue];
    else
        EXCLAMATION;
}

-(NSString*) getInput4Str
{
    return str4;
}

-(void) setInput5Str:(NSString*)string
{
    if( [string isKindOfClass:[NSString class]] )
        str5 = string;
    else if( [string isKindOfClass:[NSNumber class]] )
        str5 = [((NSNumber*)string) stringValue];
    else
        EXCLAMATION;
}

-(NSString*) getInput5Str
{
    return str5;
}

-(void) setStringAction:(NSNumber*)BoolValue
{
//    BOOL value;

//    if( [BoolValue isKindOfClass:[NSString class]] )
//        value = [(NSString*)BoolValue boolValue];
//    else if( [BoolValue isKindOfClass:[NSNumber class]] )
//        value = [BoolValue boolValue];
//    else
//        return;

    SEL act;
    NSNumber *nsMagicNum;
    
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] ){
                NSString *result = [NSString stringWithFormat:@"%@%@%@%@%@",str1,str2,str3,str4,str5];
                [gObj performSelector:act withObject:result];
            }else
                EXCLAMATION;
        }
    }
}

-(NSNumber*) getStringAct
{
    return @NO;
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_strcat.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_STRCAT;

    csResizable = NO;
    csShow = NO;

    str1 = @"";
    str2 = @"";
    str3 = @"";
    str4 = @"";
    str5 = @"";
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Input String #1", P_TXT, @selector(setInput1Str:),@selector(getInput1Str));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Input String #2", P_TXT, @selector(setInput2Str:),@selector(getInput2Str));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Input String #3", P_TXT, @selector(setInput3Str:),@selector(getInput3Str));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Input String #4", P_TXT, @selector(setInput4Str:),@selector(getInput4Str));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"Input String #5", P_TXT, @selector(setInput5Str:),@selector(getInput5Str));
    NSDictionary *d6 = MAKE_PROPERTY_D(@">Output Linked String", P_NUM, @selector(setStringAction:),@selector(getStringAct));
    pListArray = @[d1,d2,d3,d4,d5,d6];

    NSMutableDictionary MAKE_ACTION_D(@"Output", A_TXT, a1);
    actionArray = @[a1];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_strcat.png"]];
        str1 = [decoder decodeObjectForKey:@"str1"];
        str2 = [decoder decodeObjectForKey:@"str2"];
        str3 = [decoder decodeObjectForKey:@"str3"];
        str4 = [decoder decodeObjectForKey:@"str4"];
        str5 = [decoder decodeObjectForKey:@"str5"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:str1 forKey:@"str1"];
    [encoder encodeObject:str2 forKey:@"str2"];
    [encoder encodeObject:str3 forKey:@"str3"];
    [encoder encodeObject:str4 forKey:@"str4"];
    [encoder encodeObject:str5 forKey:@"str5"];
}

#pragma mark - Code Generator

-(NSArray*) importLinesCode
{
    return @[@"\"CSStrGate.h\""];
}

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"CSStrGate";
}

// viewDidLoad 에서 alloc - init 하지 않을 것일때는 NO_FIRST_ALLOC 을 리턴하자.
-(NSString*) customClass
{
    NSString *r = @"\n\n// CSStrGate class\n//\n@interface CSStrGate : NSObject\n\{\n}\n\n\
@property (nonatomic,retain)    NSString *input1Str, *input2Str;\n\
@property (nonatomic,retain)    NSString *input3Str, *input4Str, *input5Str;\n@end\n\n\
@implementation CSStrGate\n\n@synthesize input1Str, input2Str, input3Str, input4Str, input5Str;\n\
@end\n\n";
    return r;
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    if( [apName isEqualToString:@"setStringAction:"] ){
        SEL act;
        NSNumber *nsMagicNum;
        NSMutableString *rs = [[NSMutableString alloc] initWithCapacity:100];
        
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( act )
        {
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            const char *sel_name_c = sel_getName(act);
            [rs appendFormat:@"[%@ %@ [NSString stgringWithFormat@\"%%@%%@%%@%%@%%@\",%@.input1Str,%@.input2Str,%@.input3Str,%@.input4Str,%@.input5Str]];\n", [gObj getVarName], @(sel_name_c),varName,varName,varName,varName,varName];
            return rs;
        }
    }
    return nil;
}

@end
