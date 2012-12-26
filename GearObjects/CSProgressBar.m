//
//  CSProgressBar.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 23..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSProgressBar.h"

@implementation CSProgressBar

-(id) object
{
    return ((UISlider*)csView);
}

//===========================================================================
#pragma mark -

-(void) setBarColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((UIProgressView*)csView) setProgressTintColor:color];
}

-(UIColor*) getBarColor
{
    return ((UIProgressView*)csView).progressTintColor;
}

-(void) setTrackColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((UIProgressView*)csView) setTrackTintColor:color];
}


-(UIColor*) getTrackColor
{
    return ((UIProgressView*)csView).trackTintColor;
}


-(void) setBarValue:(NSNumber*)number
{
    if( [number isKindOfClass:[NSNumber class]] )
        [((UIProgressView*)csView) setProgress:[number floatValue] animated:YES];
    else if( [number isKindOfClass:[NSString class]] )
        [((UIProgressView*)csView) setProgress:[(NSString*)number floatValue] animated:YES];
}

-(NSNumber*) getBarValue
{
    return @( ((UIProgressView*)csView).progress );
}

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 400, MINSIZE)];
    [csView setBackgroundColor:[UIColor clearColor]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_PROGRESS;
    isUIObj = YES;

    [((UIProgressView*)csView) setProgressTintColor:[UIColor blueColor]];
    [((UIProgressView*)csView) setTrackTintColor:[UIColor lightGrayColor]];
    [((UIProgressView*)csView) setProgressViewStyle:UIProgressViewStyleDefault];
    [((UIProgressView*)csView) setProgress:0.5];
    
    self.info = NSLocalizedString(@"Progress Bar", @"Progress Bar");

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Bar Color", P_COLOR, @selector(setBarColor:),@selector(getBarColor));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Track Color", P_COLOR, @selector(setTrackColor:),@selector(getTrackColor));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Value", P_NUM, @selector(setBarValue:),@selector(getBarValue));

    pListArray = @[xc,yc,d0,d1,d2,d3];

    return self;
}

@end
