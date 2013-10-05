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
    BOOL value;

    if( [BoolValue isKindOfClass:[NSString class]] )
        value = [(NSString*)BoolValue boolValue];
    else if( [BoolValue isKindOfClass:[NSNumber class]] )
        value = [BoolValue boolValue];
    else
        return;

    NSDate *now = [NSDate date];
//    NSDateComponents *nowCom = [[NSDateComponents alloc] init];
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
    if( ![super init] ) return nil;
    
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

@end
