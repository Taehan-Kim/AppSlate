//
//  CSLabel.m
//  AppSlate
//
//  Created by 김태한 on 11. 11. 10..
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
    [((UILabel*)csView) setText:txt];
}

-(NSString*) getText
{
    return ((UILabel*)csView).text;
}

-(void) setTextColor:(UIColor*)color
{
    [((UILabel*)csView) setTextColor:color];
}

-(UIColor*) getTextColor
{
    return ((UILabel*)csView).textColor;
}

-(void) setBackgroundColor:(UIColor*)color
{
    [((UILabel*)csView) setBackgroundColor:color];
}

-(UIColor*) getBackgroundColor
{
    return ((UILabel*)csView).backgroundColor;
}

-(void) setFont:(UIFont*)font
{
    [((UILabel*)csView) setFont:font];
}
-(UIFont*) getFont
{
    return ((UILabel*)csView).font;
}

-(void) setTextAlignment:(NSNumber*)alignNum
{
    UITextAlignment align = [alignNum integerValue];
    [((UILabel*)csView) setTextAlignment:align];
}

-(NSNumber *) getTextAlignment
{
    return [NSNumber numberWithInteger:((UILabel*)csView).textAlignment];
}

//===========================================================================

#pragma mark -

-(NSArray*) getInStringProperties
{
    return [NSArray arrayWithObjects:@"setText", nil];
}

-(NSArray*) getOutStringProperties
{
    return [NSArray arrayWithObjects:@"text", nil];
}

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

    self.info = NSLocalizedString(@"Text Label", @"Text Label");

    NSDictionary *d1 = MAKE_PROPERTY_D(@"Default Text", P_TXT, @selector(setText:),@selector(getText));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Text Color", P_COLOR, @selector(setTextColor:),@selector(getTextColor));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Background Color", P_COLOR, @selector(setBackgroundColor:),@selector(getBackgroundColor));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Text Font", P_FONT, @selector(setFont:),@selector(getFont));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"L/R Alignment", P_ALIGN, @selector(setTextAlignment:),@selector(getTextAlignment));

    pListArray = [NSArray arrayWithObjects:d1,d2,d3,d4,d5, nil];

    return self;
}

// 설정될 수 있는 속성 목록.
-(NSArray*) getPropertiesList
{
    return pListArray;
}

@end
