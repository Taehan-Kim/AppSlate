//
//  CSBulb.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 1. 31..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSBulb.h"

@implementation CSBulb

-(id) object
{
    return ((UIView*)csView);
}

//===========================================================================
#pragma mark -

-(void) setLightColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [light setBackgroundColor:color];

//    [self drawBulb];
}

-(UIColor*) getLightColor
{
    return light.backgroundColor;
}

-(void) setOnValue:(NSNumber*)BoolValue
{
    onValue = [BoolValue boolValue];
    
    [self drawBulb];
}

-(NSNumber*) getOnValue
{    
    return @(onValue);
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;

    csView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [csView setClipsToBounds:YES];
    [csView.layer setCornerRadius:15];
    [csView setBackgroundColor:[UIColor lightGrayColor]];
    [csView setUserInteractionEnabled:YES];

    light = [[UIView alloc] initWithFrame:CGRectMake(9, 9, 12, 12)];
    [light setClipsToBounds:YES];
    [light.layer setCornerRadius:6];
    [light setBackgroundColor:[UIColor redColor]];
    [csView addSubview:light];
    
    onValue = YES;

    csCode = CS_BULB;
    csResizable = NO;

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Light Color", P_COLOR, @selector(setLightColor:),@selector(getLightColor));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"On Value", P_BOOL, @selector(setOnValue:),@selector(getOnValue));
    pListArray = @[xc,yc,d0,d1,d2];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        light = [csView subviews][0];
//        light = [[UIView alloc] initWithFrame:CGRectMake(8, 8, 12, 12)];
        [light setClipsToBounds:YES];
        [light.layer setCornerRadius:6];
//        [light setBackgroundColor:[UIColor redColor]];
        [csView addSubview:light];
    }
    return self;
}

-(void) drawBulb
{
    if( onValue ){
        [light setAlpha:1.0];
        UIView *flar = [[UIView alloc] initWithFrame:light.frame];
        [flar setClipsToBounds:YES];
        [flar.layer setCornerRadius:6.0];
        [flar setBackgroundColor:CSCLEAR];
        [flar.layer setBorderColor:light.backgroundColor.CGColor];
        [flar.layer setBorderWidth:2.0];
        [csView addSubview:flar];
        [UIView animateWithDuration:0.3 animations:^(){
            CGAffineTransform sct = CGAffineTransformMakeScale(3.0, 3.0);
            [flar setTransform:sct];
            [flar setAlpha:0.0];
        } completion:^(BOOL finished){
            [flar removeFromSuperview];
        }];
    } else
        [light setAlpha:0.0];
}

@end
