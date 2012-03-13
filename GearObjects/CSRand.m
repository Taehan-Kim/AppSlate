//
//  CSRand.m
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 28..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSRand.h"
#import <stdlib.h>

#define RANDOMNUM(__MIN__,__MAX__) ((__MIN__)+arc4random()%((__MAX__+1)-(__MIN__)))

@implementation CSRand

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setRequest:(NSNumber*)BoolValue
{
    // YES 값인 경우만 반응하자.
    if( ![BoolValue boolValue] )
        return;

    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;

        act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];

            NSInteger output = RANDOMNUM(minValue,maxValue);
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[NSNumber numberWithInteger:output]];
                else
                    EXCLAMATION;
            }
        }
    }
}

-(NSNumber*) getRequest
{
    return [NSNumber numberWithBool:NO];
}

-(void) setMinValue:(NSNumber*)val
{
    if( ![val isKindOfClass:[NSNumber class]] )
        return;
    
    minValue = [val integerValue];
}

-(NSNumber*) getMinValue
{
    return [NSNumber numberWithInteger:minValue];
}

-(void) setMaxValue:(NSNumber*)val
{
    if( ![val isKindOfClass:[NSNumber class]] )
        return;

    maxValue = [val integerValue];
}

-(NSNumber*) getMaxValue
{
    return [NSNumber numberWithInteger:maxValue];
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_rand.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_RAND;
    
    csResizable = NO;
    csShow = NO;
    
    minValue = 0.0;
    maxValue = 10.0;

    self.info = NSLocalizedString(@"Random Number Generator", @"RAND");
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@">Output Request", P_BOOL, @selector(setRequest:),@selector(getRequest));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Minimum Int. Value", P_NUM, @selector(setMinValue:),@selector(getMinValue));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Maximum Int. Value", P_NUM, @selector(setMaxValue:),@selector(getMaxValue));
    pListArray = [NSArray arrayWithObjects:d1,d2,d3, nil];
    
    NSMutableDictionary MAKE_ACTION_D(@"Output", A_NUM, a1);
    actionArray = [NSArray arrayWithObjects:a1, nil];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_rand.png"]];
        minValue = [decoder decodeFloatForKey:@"minValue"];
        maxValue = [decoder decodeFloatForKey:@"maxValue"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeFloat:minValue forKey:@"minValue"];
    [encoder encodeFloat:maxValue forKey:@"maxValue"];
}

@end
