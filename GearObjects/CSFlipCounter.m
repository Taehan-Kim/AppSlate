//
//  CSFlipCounter.m
//  AppSlate
//
//  Created by 김 태한 on 12. 1. 26..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSFlipCounter.h"
#define H_SIZE      87

@implementation CSFlipCounter

-(void) setNumber:(NSNumber*)number
{
    if( [number isKindOfClass:[NSNumber class]] )
        [(FlipCounterView*)csView setCounterValue:[number integerValue]];
    else if( [number isKindOfClass:[NSString class]] )
        [(FlipCounterView*)csView setCounterValue:[(NSString*)number length]];
    else
        return;

    [self _checkAndRun];
}

-(NSNumber*) getNumber
{
    return [NSNumber numberWithInteger:[(FlipCounterView*)csView counterValue]];
}

-(void) setAddNumber:(NSNumber*)number
{
    if( [number isKindOfClass:[NSNumber class]] )
        [(FlipCounterView*)csView add:[number integerValue]];
    else if( [number isKindOfClass:[NSString class]] )
        [(FlipCounterView*)csView add:[(NSString*)number length]];
    else
        return;

    [self _checkAndRun];
}

-(NSNumber*) getAddNumber
{
    return [NSNumber numberWithInt:0];
}

-(void) setSubtractNumber:(NSNumber*)number
{
    if( [number isKindOfClass:[NSNumber class]] )
        [(FlipCounterView*)csView subtract:[number integerValue]];
    else if( [number isKindOfClass:[NSString class]] )
        [(FlipCounterView*)csView subtract:[(NSString*)number length]];
    else
        return;

    [self _checkAndRun];
}

-(NSNumber*) getSubtractNumber
{
    return [NSNumber numberWithInt:0];
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[FlipCounterView alloc] initWithFrame:CGRectMake(0, 0, 160, H_SIZE)];
    [csView setBackgroundColor:[UIColor clearColor]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_FLIPCNT;
    csResizable = NO;
    
    [(FlipCounterView*)csView setCounterValue:10];
    checkNumber = 10;
    self.info = NSLocalizedString(@"Flip Counter", @"Flip Counter");

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Counter Number", P_NUM, @selector(setNumber:),@selector(getNumber));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Add Number Action", P_NUM, @selector(setAddNumber:),@selector(getAddNumber));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Subtract Number Action", P_NUM, @selector(setSubtractNumber:),@selector(getSubtractNumber));

    pListArray = [NSArray arrayWithObjects:xc,yc,d0,d1,d2,d3, nil];
    
    NSMutableDictionary MAKE_ACTION_D(@"Changed Value", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Number is Zero", A_NUM, a2);
    actionArray = [NSArray arrayWithObjects:a1, a2, nil];
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if( (self=[super initWithCoder:aDecoder]) ){
//        csView = [aDecoder decodeObjectForKey:@"cView"];
        checkNumber = [aDecoder decodeIntegerForKey:@"checkNumber"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
//    [encoder encodeObject:csView forKey:@"csView"];
    [encoder encodeInteger:checkNumber forKey:@"checkNumber"];
}

#pragma mark - Flip counter Delegate

-(void)flipCounterView:(FlipCounterView *)flipCounterView didExpand:(CGSize)newSize
{
    // 가로 크기를 숫자 자릿수에 맞춰 재설정한다.
    [csView setFrame:CGRectMake(csView.frame.origin.x, csView.frame.origin.y, newSize.width, H_SIZE)];
}


#pragma mark - Gear's Unique Actions

-(void) _checkAndRun
{
    checkNumber = ((FlipCounterView*)csView).counterValue;

//TODO: edit 모드에서는 아래 부분은 실행하지 않는 것이 좋다.    if( !csView. ) return;

    if( checkNumber != ((FlipCounterView*)csView).counterValue )
        [self valueChanged];

    if( 0 == ((FlipCounterView*)csView).counterValue )
        [self iAmZero];
}

// 값이 변경되는 모든 경우 설정된 액션을 수행한다.
-(void) valueChanged
{
    SEL act;
    NSNumber *nsMagicNum;
    NSUInteger myValue = ((FlipCounterView*)csView).counterValue;

    // 1. value changed
    act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:[NSNumber numberWithInteger:myValue]];
            else
                EXCLAMATION;
        }
    }
}

// 숫자가 0이 되는 경우 실행되도록 설정된 액션을 수행한다.
-(void) iAmZero
{
    SEL act;
    NSNumber *nsMagicNum;
    
    // 1. value set to 0.
    act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:1] objectForKey:@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:1]) objectForKey:@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:[NSNumber numberWithInteger:0]];
            else
                EXCLAMATION;
        }
    }
}

@end
