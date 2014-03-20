//
//  CSTee.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 16..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSTee.h"

@implementation CSTee

//-(id) object
//{
//    return (csView);
//}

//===========================================================================

-(void) setInputValueAction:(id)inValue
{
//    CGFloat value;

//    if( [inValue isKindOfClass:[NSString class]] )
//        value = [(NSString*)BoolValue floatValue];
//    else  if( [BoolValue isKindOfClass:[NSNumber class]] )
//        value = [BoolValue floatValue];
//    else
//        return;

    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;

        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:inValue];
                else
                    EXCLAMATION;
            }
        }

        act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:inValue];
                else
                    EXCLAMATION;
            }
        }

    }
}

-(NSNumber*) getInputValue
{
    return @NO;
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_tee.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_TEE;

    csResizable = NO;
    csShow = NO;

    NSDictionary *d1 = MAKE_PROPERTY_D(@">Input", P_NUM, @selector(setInputValueAction:),@selector(getInputValue));
    pListArray = @[d1];
    
    NSMutableDictionary MAKE_ACTION_D(@"Output #1", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Output #2", A_NUM, a2);
    actionArray = @[a1,a2];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_tee.png"]];
    }
    return self;
}

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return YES;
}

// viewDidLoad 에서 alloc - init 하지 않을 것일때는 NO_FIRST_ALLOC 을 리턴하자.
-(NSString*) customClass
{
    return NO_FIRST_ALLOC;
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    if( [apName isEqualToString:@"setInputValueAction:"] ){
        SEL act;
        NSNumber *nsMagicNum;
        NSMutableString *rs = [[NSMutableString alloc] initWithCapacity:100];

        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( act )
        {
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            const char *sel_name_c = sel_getName(act);
            [rs appendFormat:@"[%@ %@%@];\n",[gObj getVarName],@(sel_name_c),val];
        }

        act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
        if( act )
        {
            nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            const char *sel_name_c = sel_getName(act);
            [rs appendFormat:@"[%@ %@%@];\n",[gObj getVarName],@(sel_name_c),val];
        }

        return rs;
    }
    return nil;
}

@end
