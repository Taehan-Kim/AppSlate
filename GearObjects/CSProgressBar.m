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

-(void) setProgressTintColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((UIProgressView*)csView) setProgressTintColor:color];
}

-(UIColor*) getProgressTintColor
{
    return ((UIProgressView*)csView).progressTintColor;
}

-(void) setTrackTintColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((UIProgressView*)csView) setTrackTintColor:color];
}


-(UIColor*) getTrackTintColor
{
    return ((UIProgressView*)csView).trackTintColor;
}


-(void) setProgress:(NSNumber*)number
{
    if( [number isKindOfClass:[NSNumber class]] )
        [((UIProgressView*)csView) setProgress:[number floatValue] animated:YES];
    else if( [number isKindOfClass:[NSString class]] )
        [((UIProgressView*)csView) setProgress:[(NSString*)number floatValue] animated:YES];
}

-(NSNumber*) getProgress
{
    return @( ((UIProgressView*)csView).progress );
}

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
    
    csView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, 400, MINSIZE)];
    [csView setBackgroundColor:[UIColor clearColor]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_PROGRESS;
    isUIObj = YES;

    [((UIProgressView*)csView) setProgressTintColor:[UIColor blueColor]];
    [((UIProgressView*)csView) setTrackTintColor:[UIColor lightGrayColor]];
    [((UIProgressView*)csView) setProgressViewStyle:UIProgressViewStyleDefault];
    [((UIProgressView*)csView) setProgress:0.5];
    
    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Bar Color", P_COLOR, @selector(setProgressTintColor:),@selector(getProgressTintColor));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Track Color", P_COLOR, @selector(setTrackTintColor:),@selector(getTrackTintColor));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Value", P_NUM, @selector(setProgress:),@selector(getProgress));

    pListArray = @[xc,yc,d0,d1,d2,d3];

    return self;
}

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"UIProgressView";
}

@end
