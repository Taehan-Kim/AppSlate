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

-(void) setRadianValue:(NSNumber*) num
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
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_trigono.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_TRI;
    
    csResizable = NO;
    csShow = NO;
    
    self.info = NSLocalizedString(@"Trigonometric Functions", @"Trigonometric");
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@">Radian Value", P_NUM, @selector(setRadianValue:),@selector(getRadianValue));
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

@end
