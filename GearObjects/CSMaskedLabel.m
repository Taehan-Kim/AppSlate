//
//  CSMaskedLabel.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 01. 10..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSMaskedLabel.h"

@implementation CSMaskedLabel

-(id) object
{
    return ((RSMaskedLabel*)csView);
}

//===========================================================================
#pragma mark -

-(void) setText:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        [((RSMaskedLabel*)csView) setText:txt];
    
    else if([txt isKindOfClass:[NSNumber class]] )
        [((RSMaskedLabel*)csView) setText:[((NSNumber*)txt) stringValue]];
}

-(NSString*) getText
{
    return ((RSMaskedLabel*)csView).text;
}

-(void) setBackgroundColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((RSMaskedLabel*)csView).layer setBackgroundColor:color.CGColor];
}

-(UIColor*) getBackgroundColor
{
    return[UIColor colorWithCGColor:((RSMaskedLabel*)csView).layer.backgroundColor];
}

-(void) setFont:(UIFont*)font
{
    if( [font isKindOfClass:[UIFont class]] )
        [((RSMaskedLabel*)csView) setFont:font];
}

-(UIFont*) getFont
{
    return[ ((RSMaskedLabel*)csView) getFont];
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[RSMaskedLabel alloc] initWithFrame:CGRectMake(0, 0, 300, MINSIZE2)];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_MASKEDLABEL;

    [((RSMaskedLabel*)csView) setFont:CS_FONT(30)];
    [(RSMaskedLabel*)csView setText:@"Masked Label"];
    [(RSMaskedLabel*)csView setClipsToBounds:YES];
    
    self.info = NSLocalizedString(@"Masked Label", @"Masked Label");

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Text", P_TXT, @selector(setText:),@selector(getText));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Background Color", P_COLOR, @selector(setBackgroundColor:),@selector(getBackgroundColor));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Text Font", P_FONT, @selector(setFont:),@selector(getFont));
//    NSDictionary *d5 = MAKE_PROPERTY_D(@"L/R Alignment", P_ALIGN, @selector(setTextAlignment:),@selector(getTextAlignment));

    pListArray = @[xc,yc,d0,d1,d2,d3];

    return self;
}

@end
