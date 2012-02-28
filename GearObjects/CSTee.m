//
//  CSTee.m
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 16..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSTee.h"

@implementation CSTee

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setInputValue:(NSNumber*) BoolValue
{
    CGFloat value;

    if( [BoolValue isKindOfClass:[NSString class]] )
        value = 1.0;
    else  if( [BoolValue isKindOfClass:[NSNumber class]] )
        value = [BoolValue floatValue];
    else
        return;

    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;

        act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[NSNumber numberWithFloat: value ]];
                else
                    EXCLAMATION;
            }
        }

        act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:1] objectForKey:@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:1]) objectForKey:@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[NSNumber numberWithFloat: value ]];
                else
                    EXCLAMATION;
            }
        }

    }
}

-(NSNumber*) getInputValue
{
    return [NSNumber numberWithBool:NO];
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_tee.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_TEE;

    csResizable = NO;
    csShow = NO;

    self.info = NSLocalizedString(@"Split input value", @"Tee");

    NSDictionary *d1 = MAKE_PROPERTY_D(@">Input", P_NUM, @selector(setInputValue:),@selector(getInputValue));
    pListArray = [NSArray arrayWithObjects:d1, nil];
    
    NSMutableDictionary MAKE_ACTION_D(@"Output #1", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Output #2", A_NUM, a2);
    actionArray = [NSArray arrayWithObjects:a1,a2, nil];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_tee.png"]];
    }
    return self;
}

@end
