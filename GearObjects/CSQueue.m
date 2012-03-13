//
//  CSQueue.m
//  AppSlate
//
//  Created by 김태한 on 12. 3. 10..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSQueue.h"

@implementation CSQueue

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setPushValue:(id) object
{
    [queue addObject:object];
}

-(id) getPushValue
{
    return nil;
}

-(void) setPop:(NSNumber*) BoolValue
{
    if( 0 >= [queue count] ) return;

    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;

        act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[queue objectAtIndex:0]];
                else
                    EXCLAMATION;
            }
        }
        [queue removeObjectAtIndex:0];
    }
}

-(NSNumber*) getPop
{
    return nil;
}

// Stop 버튼 호출 후 항상 호출되어야 하는 메소드.
-(void) removeAll
{
    [queue removeAllObjects];
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_queue.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_QUEUE;
    
    csResizable = NO;
    csShow = NO;
    queue = [[NSMutableArray alloc] initWithCapacity:10];

    self.info = NSLocalizedString(@"Queue Data Structure", @"Queue");

    NSDictionary *d1 = MAKE_PROPERTY_D(@">Push", P_NUM, @selector(setPushValue:),@selector(getPushValue));
    NSDictionary *d2 = MAKE_PROPERTY_D(@">Get", P_NUM, @selector(setPop:),@selector(getPop));
    pListArray = [NSArray arrayWithObjects:d1,d2, nil];

    NSMutableDictionary MAKE_ACTION_D(@"Get Output", A_NUM, a1);
    actionArray = [NSArray arrayWithObjects:a1, nil];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_queue.png"]];
        queue = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

@end
