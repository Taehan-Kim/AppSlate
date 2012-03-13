//
//  CSAbs.m
//  AppSlate
//
//  Created by 김태한 on 12. 2. 28..
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
    NSInteger value;

    if( [num isKindOfClass:[NSString class]] )
        value = [(NSString*)num integerValue];
    else if( [num isKindOfClass:[NSNumber class]] )
        value = [num integerValue];
    else
        return;

    if( HUGE_VAL == value || -HUGE_VAL == value ){
        EXCLAMATION;
        return;
    }
    
    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;

        act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[NSNumber numberWithInteger:value]];
                else
                    EXCLAMATION;
            }
        }
        act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:1] objectForKey:@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:1]) objectForKey:@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                CGFloat val = [num floatValue];
                if( val < 0.0 ) val = val * -1;
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[NSNumber numberWithFloat:val]];
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
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_abs.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_ABS;
    
    csResizable = NO;
    csShow = NO;

    self.info = NSLocalizedString(@"ABS and INT function", @"ABS");
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@">Input Value", P_NUM, @selector(setInputValue:),@selector(getInputValue));
    pListArray = [NSArray arrayWithObjects:d1, nil];
    
    NSMutableDictionary MAKE_ACTION_D(@"INT Output Number", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"ABS Output Number", A_NUM, a2);
    actionArray = [NSArray arrayWithObjects:a1,a2, nil];
    
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
