//
//  CSTrigonometric.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 3. 15..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSTrigonometric.h"

@implementation CSTrigonometric

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setRadianValueAction:(NSNumber*) num
{
    CGFloat value;
    
    if( [num isKindOfClass:[NSString class]] )
        value = [(NSString*)num floatValue];
    else if( [num isKindOfClass:[NSNumber class]] )
        value = [num floatValue];
    else
        return;
    
    if( HUGE_VALF == value || -HUGE_VALF == value ){
        EXCLAMATION;
        return;
    }
    
    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;

        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@(sinf(value))];
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
                    [gObj performSelector:act withObject:@(cosf(value))];
                else
                    EXCLAMATION;
            }
        }
        act = ((NSValue*)((NSDictionary*)actionArray[2])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[2])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@(tanf(value))];
                else
                    EXCLAMATION;
            }
        }
    }
}

-(NSNumber*) getRadianValue
{
    return @NO;
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_trigono.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_TRI;
    
    csResizable = NO;
    csShow = NO;
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@">Radian Value", P_NUM, @selector(setRadianValueAction:),@selector(getRadianValue));
    pListArray = @[d1];
    
    NSMutableDictionary MAKE_ACTION_D(@"Sine Output", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Cosine Output", A_NUM, a2);
    NSMutableDictionary MAKE_ACTION_D(@"Tangent Output", A_NUM, a3);
    actionArray = @[a1,a2,a3];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_trigono.png"]];
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
    if( [apName isEqualToString:@"setRadianValueAction:"] ){
        SEL act;
        NSNumber *nsMagicNum;
        NSMutableString *rs = [[NSMutableString alloc] initWithCapacity:100];
        
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( act )
        {
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            const char *sel_name_c = sel_getName(act);
            [rs appendFormat:@"[%@ %@@(sinf(%@))];\n    ",[gObj getVarName],@(sel_name_c),val];
        }

        act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
        if( act )
        {
            nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            const char *sel_name_c = sel_getName(act);
            [rs appendFormat:@"[%@ %@@(cosf(%@))];\n    ",[gObj getVarName],@(sel_name_c),val];
        }

        act = ((NSValue*)((NSDictionary*)actionArray[2])[@"selector"]).pointerValue;
        if( act )
        {
            nsMagicNum = ((NSDictionary*)actionArray[2])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            const char *sel_name_c = sel_getName(act);
            [rs appendFormat:@"[%@ %@@(tanf(%@))];\n",[gObj getVarName],@(sel_name_c),val];
        }

        return rs;
    }
    return nil;
}

@end
