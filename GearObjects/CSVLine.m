//
//  CSVLine.m
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 28..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSVLine.h"

@implementation CSVLine

-(id) object
{
    return (csView);
}

//===========================================================================
#pragma mark -

-(void) setHeight:(NSNumber*)num
{
    if( [num isKindOfClass:[NSNumber class]] )
        [csView setFrame:CGRectMake(csView.frame.origin.x, csView.frame.origin.y, csView.frame.size.width, [num floatValue])];
}

-(NSNumber*) getHeight
{
    return [NSNumber numberWithFloat:csView.frame.size.height];
}

-(void) setLineColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [(UIView*)[[csView subviews] objectAtIndex:0] setBackgroundColor:color];
}

-(UIColor*) getLineColor
{
    return [(UIView*)[[csView subviews] objectAtIndex:0] backgroundColor];
}

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 200)];
    [csView setBackgroundColor:[UIColor clearColor]];
    [csView setUserInteractionEnabled:YES];
    [csView setClipsToBounds:YES];
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 200)];
    [lv setBackgroundColor:[UIColor lightGrayColor]];
    [lv setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [csView addSubview:lv];

    csCode = CS_LINE_V;

    self.info = NSLocalizedString(@"Vertical Line", @"V Line");
    
    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@">Length", P_NUM, @selector(setWidth:),@selector(getWidth));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Line Color", P_COLOR, @selector(setLineColor:),@selector(getLineColor));
    pListArray = [NSArray arrayWithObjects:xc,yc,d0,d1,d2, nil];
    
    return self;
}

@end
