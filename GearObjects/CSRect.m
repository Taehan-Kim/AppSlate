//
//  CSRect.m
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 16..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSRect.h"

@implementation CSRect

-(id) object
{
    return (csView);
}

//===========================================================================
#pragma mark -

-(void) setWidth:(NSNumber*)num
{
    CGRect theRect = csView.frame;

    if( [num isKindOfClass:[NSNumber class]] )
        theRect.size.width = [num floatValue];
    else
        return;

    [csView setFrame:theRect];
}

-(NSNumber*) getWidth
{
    return [NSNumber numberWithFloat:csView.frame.size.width];
}

-(void) setHeight:(NSNumber*)num
{
    CGRect theRect = csView.frame;

    if( [num isKindOfClass:[NSNumber class]] )
        theRect.size.height = [num floatValue];
    else
        return;
    
    [csView setFrame:theRect];
}

-(NSNumber*) getHeight
{
    return [NSNumber numberWithFloat:csView.frame.size.height];
}

-(void) setRectColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [csView setBackgroundColor:color];
}

-(UIColor*) getRectColor
{
    return csView.backgroundColor;
}

-(void) setBorderColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [csView.layer setBorderColor:color.CGColor];
}

-(UIColor*) getBorderColor
{
    return[UIColor colorWithCGColor:csView.layer.borderColor];
}

-(void) setBorderWidth:(NSNumber*)num
{
    if( [num isKindOfClass:[NSNumber class]] )
        [csView.layer setBorderWidth:[num floatValue]];
}

-(NSNumber*) getBorderWidth
{
    return [NSNumber numberWithFloat:csView.layer.borderWidth];
}

-(void) setCornerRadius:(NSNumber*)num
{
    if( [num isKindOfClass:[NSNumber class]] )
        [csView.layer setCornerRadius:[num floatValue]];
}

-(NSNumber*) getCornerRadius
{
    return [NSNumber numberWithFloat:csView.layer.cornerRadius];
}

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    [csView setBackgroundColor:[UIColor grayColor]];
    [csView setUserInteractionEnabled:YES];
    [csView setClipsToBounds:YES];

    csCode = CS_RECT;

    self.info = NSLocalizedString(@"Rectangular", @"Rectangular");

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@">Width", P_NUM, @selector(setWidth:),@selector(getWidth));
    NSDictionary *d2 = MAKE_PROPERTY_D(@">Height", P_NUM, @selector(setHeight:),@selector(getHeight));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Rect Color", P_COLOR, @selector(setRectColor:),@selector(getRectColor));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Border Color", P_COLOR, @selector(setBorderColor:),@selector(getBorderColor));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"Border Width", P_NUM, @selector(setBorderWidth:),@selector(getBorderWidth));
    NSDictionary *d6 = MAKE_PROPERTY_D(@"Corner Radius", P_NUM, @selector(setCornerRadius:),@selector(getCornerRadius));
    pListArray = [NSArray arrayWithObjects:xc,yc,d0,d1,d2,d3,d4,d5,d6, nil];

    return self;
}

@end
