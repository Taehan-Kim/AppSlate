//
//  CSTime.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 3. 2..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSTime.h"

@implementation CSTime

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setNowAction:(NSNumber*) BoolValue
{
//    BOOL value;

//    if( [BoolValue isKindOfClass:[NSString class]] )
//        value = [(NSString*)BoolValue boolValue];
//    else if( [BoolValue isKindOfClass:[NSNumber class]] )
//        value = [BoolValue boolValue];
//    else
//        return;

    NSDate *now = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                [df setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"EdMMM" options:0
                                                                   locale:[NSLocale currentLocale]]];
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[df stringFromDate:now]];
                else
                    EXCLAMATION;
            }
        }

        act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                [df setDateFormat:@"yyyy"];
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@([[df stringFromDate:now] integerValue])];
                else
                    EXCLAMATION;
            }
        }

        act = ((NSValue*)((NSDictionary*)actionArray[2])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[2])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                [df setDateFormat:@"MM"];
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@([[df stringFromDate:now] integerValue])];
                else
                    EXCLAMATION;
            }
        }

        act = ((NSValue*)((NSDictionary*)actionArray[3])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[3])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                [df setDateFormat:@"dd"];
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@([[df stringFromDate:now] integerValue])];
                else
                    EXCLAMATION;
            }
        }
        act = ((NSValue*)((NSDictionary*)actionArray[4])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[4])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                [df setDateFormat:@"HH"];
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@([[df stringFromDate:now] integerValue])];
                else
                    EXCLAMATION;
            }
        }
        act = ((NSValue*)((NSDictionary*)actionArray[5])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[5])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                [df setDateFormat:@"mm"];
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@([[df stringFromDate:now] integerValue])];
                else
                    EXCLAMATION;
            }
        }
        act = ((NSValue*)((NSDictionary*)actionArray[6])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[6])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                [df setDateFormat:@"ss"];
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@([[df stringFromDate:now] integerValue])];
                else
                    EXCLAMATION;
            }
        }

    }
}

-(NSNumber*) getNowAction
{
    return @NO;
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_date.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_NOW;
    
    csResizable = NO;
    csShow = NO;
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@">Now Date & Time", P_NUM, @selector(setNowAction:),@selector(getNowAction));
    pListArray = @[d1];

    NSMutableDictionary MAKE_ACTION_D(@"Date String", A_TXT, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Year", A_NUM, a2);
    NSMutableDictionary MAKE_ACTION_D(@"Month", A_NUM, a3);
    NSMutableDictionary MAKE_ACTION_D(@"Day", A_NUM, a4);
    NSMutableDictionary MAKE_ACTION_D(@"Hour", A_NUM, a5);
    NSMutableDictionary MAKE_ACTION_D(@"Minute", A_NUM, a6);
    NSMutableDictionary MAKE_ACTION_D(@"Second", A_NUM, a7);
    actionArray = @[a1,a2,a3,a4,a5,a6,a7];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_date.png"]];
    }
    return self;
}

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    if( ![apName isEqualToString:@"setNowAction:"] ) return nil;

    NSMutableString *rs = [[NSMutableString alloc] initWithCapacity:100];
    SEL act;
    NSNumber *nsMagicNum;

    [rs appendString:@"    NSDate *now = [NSDate date];\n\
    NSDateFormatter *df = [[NSDateFormatter alloc] init];\n\n"];

    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];

        const char *sel_name_c = sel_getName(act);
        NSString *selNameStr = [NSString stringWithCString:sel_name_c encoding:NSUTF8StringEncoding];

        // Action Property 에 연결되는 경우는 각각 별도의 코드를 주문 받아서 수행한다.
        if( [selNameStr hasSuffix:@"Action:"] )
            [rs appendFormat:@"    %@\n",[gObj actionPropertyCode:selNameStr valStr:val]];
        else
            [rs appendFormat:@"    [df setDateFormat:[NSDateFormatter dateFormatFromTemplate:@\"EdMMM\" options:0 locale:[NSLocale currentLocale]]];\n\
    [%@ %@[df stringFromData:now]];\n\n",[gObj getVarName],@(sel_name_c)];
    }

    act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        const char *sel_name_c = sel_getName(act);
        NSString *selNameStr = [NSString stringWithCString:sel_name_c encoding:NSUTF8StringEncoding];
        
        // Action Property 에 연결되는 경우는 각각 별도의 코드를 주문 받아서 수행한다.
        if( [selNameStr hasSuffix:@"Action:"] )
            [rs appendFormat:@"    %@\n",[gObj actionPropertyCode:selNameStr valStr:val]];
        else
            [rs appendFormat:@"    [df setDateFormat:[NSDateFormatter dateFormatFromTemplate:@\"yyyy\" options:0 locale:[NSLocale currentLocale]]];\n\
             [%@ %@[df stringFromData:now]];\n\n",[gObj getVarName],@(sel_name_c)];
    }

    act = ((NSValue*)((NSDictionary*)actionArray[2])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[2])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        const char *sel_name_c = sel_getName(act);
        NSString *selNameStr = [NSString stringWithCString:sel_name_c encoding:NSUTF8StringEncoding];
        
        // Action Property 에 연결되는 경우는 각각 별도의 코드를 주문 받아서 수행한다.
        if( [selNameStr hasSuffix:@"Action:"] )
            [rs appendFormat:@"    %@\n",[gObj actionPropertyCode:selNameStr valStr:val]];
        else
            [rs appendFormat:@"    [df setDateFormat:[NSDateFormatter dateFormatFromTemplate:@\"MM\" options:0 locale:[NSLocale currentLocale]]];\n\
             [%@ %@[df stringFromData:now]];\n\n",[gObj getVarName],@(sel_name_c)];
    }

    act = ((NSValue*)((NSDictionary*)actionArray[3])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[3])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        const char *sel_name_c = sel_getName(act);
        NSString *selNameStr = [NSString stringWithCString:sel_name_c encoding:NSUTF8StringEncoding];
        
        // Action Property 에 연결되는 경우는 각각 별도의 코드를 주문 받아서 수행한다.
        if( [selNameStr hasSuffix:@"Action:"] )
            [rs appendFormat:@"    %@\n",[gObj actionPropertyCode:selNameStr valStr:val]];
        else
            [rs appendFormat:@"    [df setDateFormat:[NSDateFormatter dateFormatFromTemplate:@\"dd\" options:0 locale:[NSLocale currentLocale]]];\n\
             [%@ %@[df stringFromData:now]];\n\n",[gObj getVarName],@(sel_name_c)];
    }

    act = ((NSValue*)((NSDictionary*)actionArray[4])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[4])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        const char *sel_name_c = sel_getName(act);
        NSString *selNameStr = [NSString stringWithCString:sel_name_c encoding:NSUTF8StringEncoding];
        
        // Action Property 에 연결되는 경우는 각각 별도의 코드를 주문 받아서 수행한다.
        if( [selNameStr hasSuffix:@"Action:"] )
            [rs appendFormat:@"    %@\n",[gObj actionPropertyCode:selNameStr valStr:val]];
        else
            [rs appendFormat:@"    [df setDateFormat:[NSDateFormatter dateFormatFromTemplate:@\"HH\" options:0 locale:[NSLocale currentLocale]]];\n\
             [%@ %@[df stringFromData:now]];\n\n",[gObj getVarName],@(sel_name_c)];
    }
    
    act = ((NSValue*)((NSDictionary*)actionArray[5])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[5])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        const char *sel_name_c = sel_getName(act);
        NSString *selNameStr = [NSString stringWithCString:sel_name_c encoding:NSUTF8StringEncoding];
        
        // Action Property 에 연결되는 경우는 각각 별도의 코드를 주문 받아서 수행한다.
        if( [selNameStr hasSuffix:@"Action:"] )
            [rs appendFormat:@"    %@\n",[gObj actionPropertyCode:selNameStr valStr:val]];
        else
            [rs appendFormat:@"    [df setDateFormat:[NSDateFormatter dateFormatFromTemplate:@\"mm\" options:0 locale:[NSLocale currentLocale]]];\n\
             [%@ %@[df stringFromData:now]];\n\n",[gObj getVarName],@(sel_name_c)];
    }
    
    act = ((NSValue*)((NSDictionary*)actionArray[6])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[6])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        const char *sel_name_c = sel_getName(act);
        NSString *selNameStr = [NSString stringWithCString:sel_name_c encoding:NSUTF8StringEncoding];
        
        // Action Property 에 연결되는 경우는 각각 별도의 코드를 주문 받아서 수행한다.
        if( [selNameStr hasSuffix:@"Action:"] )
            [rs appendFormat:@"    %@\n",[gObj actionPropertyCode:selNameStr valStr:val]];
        else
            [rs appendFormat:@"    [df setDateFormat:[NSDateFormatter dateFormatFromTemplate:@\"ss\" options:0 locale:[NSLocale currentLocale]]];\n\
             [%@ %@[df stringFromData:now]];\n",[gObj getVarName],@(sel_name_c)];
    }

    return rs;
}

@end
