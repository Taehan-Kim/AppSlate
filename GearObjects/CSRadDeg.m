//
//  CSRadDeg.m
//  AppSlate
//
//  Created by 김 태한 on 12. 3. 15..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSRadDeg.h"

@implementation CSRadDeg

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setDegreeValue:(NSNumber*) num
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
            CGFloat rad = value * M_PI / 180.0;
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@(rad)];
                else
                    EXCLAMATION;
            }
        }
    }
}

-(NSNumber*) getDegreeValue
{
    return @NO;
}

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

        act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            CGFloat deg = value * 180.0 / M_PI;
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@(deg)];
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
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_raddeg.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_RADDEG;

    csResizable = NO;
    csShow = NO;
    
    self.info = NSLocalizedString(@"Radian/Degree Converter", @"RadDeg");
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@">Degree Value", P_NUM, @selector(setDegreeValue:),@selector(getDegreeValue));
    NSDictionary *d2 = MAKE_PROPERTY_D(@">Radian Value", P_NUM, @selector(setRadianValue:),@selector(getRadianValue));
    pListArray = @[d1,d2];
    
    NSMutableDictionary MAKE_ACTION_D(@"Degree Output", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Radian Output", A_NUM, a2);
    actionArray = @[a1,a2];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_raddeg.png"]];
    }
    return self;
}

@end
