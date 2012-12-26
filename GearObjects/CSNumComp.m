//
//  CSNumComp.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 2. 23..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSNumComp.h"

@implementation CSNumComp

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setBaseValue:(NSNumber*)num
{
    if( [num isKindOfClass:[NSString class]] )
        base = [(NSString*)num floatValue];
    else  if( [num isKindOfClass:[NSNumber class]] )
        base = [num floatValue];
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
                NSInteger result = 0;
                if( base > var ) result = -1;
                else if( base < var ) result = 1;

                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@(result)];
                else
                    EXCLAMATION;
            }
        }        
    }
}

-(NSNumber*) getBaseValue
{
    return @(base);
}

-(void) setVariableValue:(NSNumber*) num
{
    if( [num isKindOfClass:[NSString class]] )
        var = [(NSString*)num floatValue];
    else  if( [num isKindOfClass:[NSNumber class]] )
        var = [num floatValue];
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
                NSInteger result = 0;
                if( base > var ) result = -1;
                else if( base < var ) result = 1;
                
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@(result)];
                else
                    EXCLAMATION;
            }
        }        
    }
}

-(NSNumber*) getVariableValue
{
    return @(var);
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_numcomp.png"]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_NUMCOMP;

    csResizable = NO;
    csShow = NO;

    self.info = NSLocalizedString(@"Number Compare", @"Num Comp");
    base = 0.0;
    var = 0.0;
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Base Number", P_NUM, @selector(setBaseValue:),@selector(getBaseValue));
    NSDictionary *d2 = MAKE_PROPERTY_D(@">Input Number", P_NUM, @selector(setVariableValue:),@selector(getVariableValue));
    pListArray = @[d1,d2];

    NSMutableDictionary MAKE_ACTION_D(@"Result", A_NUM, a1);
    actionArray = @[a1];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_numcomp.png"]];
        base = [decoder decodeFloatForKey:@"base"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeFloat:base forKey:@"base"];
}

@end
