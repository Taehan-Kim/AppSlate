//
//  CSNot.m
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 16..
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
        value = YES;
    else
        value = [BoolValue boolValue];

    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;

        act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[NSNumber numberWithBool: !value ]];
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
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_not.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_ALERT;
    
    csResizable = NO;
    csShow = NO;

    self.info = NSLocalizedString(@"Logical NOT", @"Not");

    NSDictionary *d1 = MAKE_PROPERTY_D(@"Input", P_NUM, @selector(setInputValue:),@selector(getInputValue));
    pListArray = [NSArray arrayWithObjects:d1, nil];
    
    NSMutableDictionary MAKE_ACTION_D(@"Output", A_NUM, a1);
    actionArray = [NSArray arrayWithObjects:a1, nil];

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
