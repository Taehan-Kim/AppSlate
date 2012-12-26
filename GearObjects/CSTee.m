//
//  CSTee.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 16..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSTee.h"

@implementation CSTee

//-(id) object
//{
//    return (csView);
//}

//===========================================================================

-(void) setInputValue:(id)inValue
{
//    CGFloat value;

//    if( [inValue isKindOfClass:[NSString class]] )
//        value = [(NSString*)BoolValue floatValue];
//    else  if( [BoolValue isKindOfClass:[NSNumber class]] )
//        value = [BoolValue floatValue];
//    else
//        return;

    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;

        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:inValue];
                else
                    EXCLAMATION;
            }
        }

        act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:inValue];
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
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_tee.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_TEE;

    csResizable = NO;
    csShow = NO;

    self.info = NSLocalizedString(@"Split input value", @"Tee");

    NSDictionary *d1 = MAKE_PROPERTY_D(@">Input", P_NUM, @selector(setInputValue:),@selector(getInputValue));
    pListArray = @[d1];
    
    NSMutableDictionary MAKE_ACTION_D(@"Output #1", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Output #2", A_NUM, a2);
    actionArray = @[a1,a2];

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
