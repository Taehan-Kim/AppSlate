//
//  CSAbs.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 2. 28..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSAbs.h"

@implementation CSAbs

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setInputValue:(NSNumber*) num
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
                    [gObj performSelector:act withObject:@(roundf(value))];
                else
                    EXCLAMATION;
            }
        }
        act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                CGFloat val = abs([num floatValue]);
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@(val)];
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
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_abs.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_ABS;
    
    csResizable = NO;
    csShow = NO;

    self.info = NSLocalizedString(@"ABS and INT function", @"ABS");
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@">Input Value", P_NUM, @selector(setInputValue:),@selector(getInputValue));
    pListArray = @[d1];
    
    NSMutableDictionary MAKE_ACTION_D(@"INT Output Number", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"ABS Output Number", A_NUM, a2);
    actionArray = @[a1,a2];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_abs.png"]];
    }
    return self;
}

@end
