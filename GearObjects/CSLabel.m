//
//  CSLabel.m
//  AppSlate
//
//  Created by Taehan Kim on 11. 11. 10..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "CSLabel.h"

@implementation CSLabel

-(id) object
{
    return ((UILabel*)csView);
}

//===========================================================================
#pragma mark -

-(void) setText:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        [((UILabel*)csView) setText:txt];

    else if([txt isKindOfClass:[NSNumber class]] )
        [((UILabel*)csView) setText:[((NSNumber*)txt) stringValue]];
}

-(NSString*) getText
{
    return ((UILabel*)csView).text;
}

-(void) setTextColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((UILabel*)csView) setTextColor:color];
}

-(UIColor*) getTextColor
{
    return ((UILabel*)csView).textColor;
}

-(void) setBackgroundColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((UILabel*)csView) setBackgroundColor:color];
}

-(UIColor*) getBackgroundColor
{
    return ((UILabel*)csView).backgroundColor;
}

-(void) setFont:(UIFont*)font
{
    if( [font isKindOfClass:[UIFont class]] )
        [((UILabel*)csView) setFont:font];
}

-(UIFont*) getFont
{
    return ((UILabel*)csView).font;
}

-(void) setTextAlignment:(NSNumber*)alignNum
{
    UITextAlignment align;

    if( [alignNum isKindOfClass:[NSNumber class]] )
        align = [alignNum integerValue];
    else
        align = NSTextAlignmentLeft;

    [((UILabel*)csView) setTextAlignment:align];
}

-(NSNumber *) getTextAlignment
{
    return @( ((UILabel*)csView).textAlignment );
}

-(void) setLineNumber:(NSNumber*)number
{
    if( [number isKindOfClass:[NSNumber class]] )
        [((UILabel*)csView) setNumberOfLines:[number integerValue]];
    else if( [number isKindOfClass:[NSString class]] )
        [((UILabel*)csView) setNumberOfLines:[(NSString*)number integerValue]];
}

-(NSNumber*) getLineNumber
{
    return @( ((UILabel*)csView).numberOfLines );
}


-(void) setRoundBorder:(NSNumber*)BoolValue
{
    BOOL isRound;

    if( [BoolValue isKindOfClass:[NSNumber class]] )
        isRound = [BoolValue boolValue];
    else {
        EXCLAMATION; return;
    }

    if( isRound ){
        [((UILabel*)csView).layer setCornerRadius:6.0];
    }else{
        [((UILabel*)csView).layer setCornerRadius:0.0];
    }
}

-(NSNumber*) getRoundBorder
{
    BOOL isRound = (((UILabel*)csView).layer.cornerRadius > 0.0) ? YES : NO;

    return @( isRound );
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;

    csView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, MINSIZE)];
    [csView setBackgroundColor:[UIColor whiteColor]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_LABEL;

    ((UILabel*)csView).textColor = [UIColor blackColor];
    ((UILabel*)csView).font = CS_FONT(16);
    [(UILabel*)csView setText:@"Text Label"];
    [(UILabel*)csView setClipsToBounds:YES];

    self.info = NSLocalizedString(@"Text Label", @"Text Label");

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Text", P_TXT, @selector(setText:),@selector(getText));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Text Color", P_COLOR, @selector(setTextColor:),@selector(getTextColor));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Background Color", P_COLOR, @selector(setBackgroundColor:),@selector(getBackgroundColor));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Text Font", P_FONT, @selector(setFont:),@selector(getFont));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"L/R Alignment", P_ALIGN, @selector(setTextAlignment:),@selector(getTextAlignment));
    NSDictionary *d6 = MAKE_PROPERTY_D(@"Line Number", P_NUM, @selector(setLineNumber:),@selector(getLineNumber));
    NSDictionary *d7 = MAKE_PROPERTY_D(@"Rounded Border", P_BOOL, @selector(setRoundBorder:),@selector(getRoundBorder));

    pListArray = @[xc,yc,d0,d1,d2,d3,d4,d5,d6,d7];

    return self;
}

@end
