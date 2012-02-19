//
//  CSNand.m
//  AppSlate
//
//  Created by 김태한 on 12. 2. 16..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSNand.h"

@implementation CSNand

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setInput1Value:(NSNumber*) BoolValue
{    
    if( [BoolValue isKindOfClass:[NSString class]] )
        value1 = YES;
    else
        value1 = [BoolValue boolValue];

    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[NSNumber numberWithBool: !(value1 & value2)]];
                else
                    EXCLAMATION;
            }
        }
        
    }
}

-(NSNumber*) getInput1Value
{
    return [NSNumber numberWithBool:value1];
}

-(void) setInput2Value:(NSNumber*) BoolValue
{    
    if( [BoolValue isKindOfClass:[NSString class]] )
        value2 = YES;
    else
        value2 = [BoolValue boolValue];
    
    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[NSNumber numberWithBool: !(value1 & value2)]];
                else
                    EXCLAMATION;
            }
        }
        
    }
}

-(NSNumber*) getInput2Value
{
    return [NSNumber numberWithBool:value2];
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_none.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_NAND;

    csResizable = NO;
    csShow = NO;
    
    self.info = NSLocalizedString(@"Logical NAND", @"NAND");

    NSDictionary *d1 = MAKE_PROPERTY_D(@"Input #1", P_NUM, @selector(setInput1Value:),@selector(getInput1Value));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Input #2", P_NUM, @selector(setInput2Value:),@selector(getInput2Value));
    pListArray = [NSArray arrayWithObjects:d1,d2, nil];

    NSMutableDictionary MAKE_ACTION_D(@"Output", A_NUM, a1);
    actionArray = [NSArray arrayWithObjects:a1, nil];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_none.png"]];
    }
    return self;
}

@end
