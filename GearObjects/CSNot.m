//
//  CSNot.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 16..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSNot.h"

@implementation CSNot

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setInputValue:(NSNumber*) BoolValue
{
    BOOL value;

    if( [BoolValue isKindOfClass:[NSString class]] )
        value = [(NSString*)BoolValue boolValue];
    else if( [BoolValue isKindOfClass:[NSNumber class]] )
        value = [BoolValue boolValue];
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
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@(!value)];
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
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_not.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_NOT;
    
    csResizable = NO;
    csShow = NO;

    NSDictionary *d1 = MAKE_PROPERTY_D(@">Input", P_NUM, @selector(setInputValue:),@selector(getInputValue));
    pListArray = @[d1];
    
    NSMutableDictionary MAKE_ACTION_D(@"Output", A_NUM, a1);
    actionArray = @[a1];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_not.png"]];
    }
    return self;
}

@end
