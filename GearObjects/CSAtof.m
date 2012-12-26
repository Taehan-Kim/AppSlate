//
//  CSAtof.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 24..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSAtof.h"

@implementation CSAtof

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setInputString:(NSString*) str
{
    if( [str isKindOfClass:[NSNumber class]] )
        return;

    CGFloat value = [str floatValue];

    if( HUGE_VAL == value || -HUGE_VAL == value ){
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
                    [gObj performSelector:act withObject:@(value)];
                else
                    EXCLAMATION;
            }
        }
    }
}

-(NSString*) getInputString
{
    return @"";
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_atof.png"]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_ATOF;

    csResizable = NO;
    csShow = NO;

    self.info = NSLocalizedString(@"Convert string to number", @"ATOF");

    NSDictionary *d1 = MAKE_PROPERTY_D(@">Input Text", P_TXT, @selector(setInputString:),@selector(getInputString));
    pListArray = @[d1];

    NSMutableDictionary MAKE_ACTION_D(@"Output Number", A_NUM, a1);
    actionArray = @[a1];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_atof.png"]];
    }
    return self;
}

@end
