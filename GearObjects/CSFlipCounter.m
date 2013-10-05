//
//  CSFlipCounter.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 1. 26..
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
        [(FlipCounterView*)csView setCounterValue:[(NSString*)number integerValue]];
    else
        return;

    [self _checkAndRun];
}

-(NSNumber*) getNumber
{
    return @([(FlipCounterView*)csView counterValue]);
}

-(void) setAddNumber:(NSNumber*)number
{
    if( [number isKindOfClass:[NSNumber class]] )
        [(FlipCounterView*)csView add:[number integerValue]];
    else if( [number isKindOfClass:[NSString class]] )
        [(FlipCounterView*)csView add:[(NSString*)number integerValue]];
    else
        return;

    [self _checkAndRun];
}

-(NSNumber*) getAddNumber
{
    return @(0);
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
    return @(0);
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[FlipCounterView alloc] initWithFrame:CGRectMake(0, 0, 110, H_SIZE)];
    [csView setBackgroundColor:[UIColor clearColor]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_FLIPCNT;
    csResizable = NO;
    
    [(FlipCounterView*)csView setCounterValue:10];
    checkNumber = 10;

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Counter Number", P_NUM, @selector(setNumber:),@selector(getNumber));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Add Number Action", P_NUM, @selector(setAddNumber:),@selector(getAddNumber));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Subtract Number Action", P_NUM, @selector(setSubtractNumber:),@selector(getSubtractNumber));

    pListArray = @[xc,yc,d0,d1,d2,d3];
    
    NSMutableDictionary MAKE_ACTION_D(@"Changed Value", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Number is Zero", A_NUM, a2);
    actionArray = @[a1, a2];
    
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
    // re-calc the object's width
    [csView setFrame:CGRectMake(csView.frame.origin.x, csView.frame.origin.y, newSize.width, H_SIZE)];
}


#pragma mark - Gear's Unique Actions

-(void) _checkAndRun
{

//TODO: on edit mode   if( !csView. ) return;

    if( checkNumber != ((FlipCounterView*)csView).counterValue )
        [self valueChanged];

    if( 0 == ((FlipCounterView*)csView).counterValue )
        [self iAmZero];

    checkNumber = ((FlipCounterView*)csView).counterValue;
}

// if number is changed, do the linked action
-(void) valueChanged
{
    SEL act;
    NSNumber *nsMagicNum;
    NSUInteger myValue = ((FlipCounterView*)csView).counterValue;

    // 1. value changed
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:@(myValue)];
            else
                EXCLAMATION;
        }
    }

    CGSize Se = [FlipCounterView sizeForNumberOfDigits:[((FlipCounterView*)csView).digits count]];
    [csView setFrame:CGRectMake(csView.frame.origin.x, csView.frame.origin.y, Se.width, H_SIZE)];
}

// it number is be 0, do the linked action
-(void) iAmZero
{
    SEL act;
    NSNumber *nsMagicNum;
    
    // 1. value set to 0.
    act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:@(0)];
            else
                EXCLAMATION;
        }
    }
}

@end
