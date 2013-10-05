//
//  CSNumLabel.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 3. 14..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSNumLabel.h"

@implementation CSNumLabel

-(id) object
{
    return ((UILabel*)csView);
}

//===========================================================================
#pragma mark -

-(void) setNumber:(NSNumber*)txt;
{
    CGFloat value;

    if( [txt isKindOfClass:[NSString class]] )
        value = [(NSString*)txt floatValue];

    else if([txt isKindOfClass:[NSNumber class]] )
        value = [txt floatValue];
    else {
        EXCLAMATION;
        return;
    }

    if( HUGE_VALF == value || -HUGE_VALF == value ){
        EXCLAMATION;
        return;
    }

    number = value;

    if( showComma ) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        [((UILabel*)csView) setText:[numberFormatter stringFromNumber:@(number)] ];
    }
    else 
        [((UILabel*)csView) setText:[NSString stringWithFormat:@"%f",number]];
}

-(NSNumber*) getNumber
{
    return @(number);
}

-(void) setShowComma:(NSNumber*)BoolValue
{
    if( [BoolValue isKindOfClass:[NSNumber class]] )
        showComma = [BoolValue boolValue];
    else {
        EXCLAMATION; return;
    }

    // refresh.
    if( showComma ) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        [((UILabel*)csView) setText:[numberFormatter stringFromNumber:@(number)] ];
    }
    else 
        [((UILabel*)csView) setText:[NSString stringWithFormat:@"%f",number]];
}

-(NSNumber*) getShowComma
{
    return @(showComma);
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
    NSTextAlignment align;
    
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
    
    return @(isRound);
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, MINSIZE)];
    [csView setBackgroundColor:[UIColor whiteColor]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_NUMLABEL;
    
    ((UILabel*)csView).textColor = [UIColor blackColor];
    ((UILabel*)csView).font = CS_FONT(16);
    [(UILabel*)csView setText:@"0"];
    [(UILabel*)csView setClipsToBounds:YES];

    showComma = NO;
    number = 0.0;
    
    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Number", P_NUM, @selector(setNumber:),@selector(getNumber));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Text Color", P_COLOR, @selector(setTextColor:),@selector(getTextColor));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Currency Style", P_BOOL, @selector(setShowComma:),@selector(getShowComma));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Background Color", P_COLOR, @selector(setBackgroundColor:),@selector(getBackgroundColor));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"Text Font", P_FONT, @selector(setFont:),@selector(getFont));
    NSDictionary *d6 = MAKE_PROPERTY_D(@"L/R Alignment", P_ALIGN, @selector(setTextAlignment:),@selector(getTextAlignment));
    NSDictionary *d7 = MAKE_PROPERTY_D(@"Rounded Border", P_BOOL, @selector(setRoundBorder:),@selector(getRoundBorder));
    
    pListArray = @[xc,yc,d0,d1,d2,d3,d4,d5,d6,d7];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        showComma = [decoder decodeBoolForKey:@"showComma"];
        number = [decoder decodeFloatForKey:@"number"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeBool:showComma forKey:@"showComma"];
    [encoder encodeFloat:number forKey:@"number"];
}
@end
