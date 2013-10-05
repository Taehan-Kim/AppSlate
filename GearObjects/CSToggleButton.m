//
//  CSToggleButton.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 01. 20..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSToggleButton.h"

@implementation CSToggleButton

-(id) object
{
    return ((BButton*)csView);
}

//===========================================================================
#pragma mark -

-(void) setOnTintColor:(UIColor*)color
{
    onColor = color;

    if( toggleValue && [color isKindOfClass:[UIColor class]] )
        [((BButton*)csView) setBackgroundColor:color];
}

-(UIColor*) getOnTintColor
{
    return onColor;
}

-(void) setOffTintColor:(UIColor*)color
{
    offColor = color;

    if( !toggleValue && [color isKindOfClass:[UIColor class]] )
        [((BButton*)csView) setBackgroundColor:color];
}

-(UIColor*) getOffTintColor
{
    return offColor;
}

-(void) setOnText:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        onText = txt;
    else if([txt isKindOfClass:[NSNumber class]] )
        onText = [((NSNumber*)txt) stringValue];

    if( toggleValue )
        [((BButton*)csView) setTitle:onText];
}

-(NSString*) getOnText
{
    return onText;
}

-(void) setOnValue:(NSNumber*) number
{
    if( [number isKindOfClass:[NSNumber class]] )
        outputOn = [number floatValue];
    else if( [number isKindOfClass:[NSString class]] )
        outputOn = [(NSString*)number length];
    else
        EXCLAMATION;
}

-(NSNumber*) getOnValue
{
    return @(outputOn);
}

-(void) setOffText:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        offText = txt;
    else if([txt isKindOfClass:[NSNumber class]] )
        offText = [((NSNumber*)txt) stringValue];

    if( !toggleValue )
        [((BButton*)csView) setTitle:offText];
}

-(NSString*) getOffText
{
    return offText;
}

-(void) setOffValue:(NSNumber*) number
{
    if( [number isKindOfClass:[NSNumber class]] )
        outputOff = [number floatValue];
    else if( [number isKindOfClass:[NSString class]] )
        outputOff = [(NSString*)number length];
    else
        EXCLAMATION;
}

-(NSNumber*) getOffValue
{
    return @(outputOff);
}

-(void) setTextColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((BButton*)csView) setTitleColor:color];
}

-(UIColor*) getTextColor
{
    return ((BButton*)csView).btn.titleLabel.textColor;
}

-(void) setFont:(UIFont*)font
{
    if( [font isKindOfClass:[UIFont class]] )
        [((BButton*)csView).btn.titleLabel setFont:font];
}

-(UIFont*) getFont
{
    return ((BButton*)csView).btn.titleLabel.font;
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;

    csView = [[BButton alloc] initWithFrame:CGRectMake(0, 0, 100, MINSIZE2)];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_BUTTON;
    toggleValue = NO;
    onColor = [UIColor blueColor];
    offColor = [UIColor grayColor];
    onText = @"Button On";
    offText = @"Button Off";
    outputOn = 1.0;
    outputOff = 0.0;

    [((BButton*)csView) setTitle:onText];
    [(BButton*)csView addTarget:self action:@selector(pushAction:)];

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"On Tint Color", P_COLOR, @selector(setOnTintColor:),@selector(getOnTintColor));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Off Tint Color", P_COLOR, @selector(setOffTintColor:),@selector(getOffTintColor));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Button On Text", P_TXT, @selector(setOnText:),@selector(getOnText));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"On Output Value", P_NUM, @selector(setOnValue:),@selector(getOnValue));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"Button Off Text", P_TXT, @selector(setOffText:),@selector(getOffText));
    NSDictionary *d6 = MAKE_PROPERTY_D(@"Off Output Value", P_NUM, @selector(setOffValue:),@selector(getOffValue));
    NSDictionary *d7 = MAKE_PROPERTY_D(@"Text Color", P_COLOR, @selector(setTextColor:),@selector(getTextColor));
    NSDictionary *d8 = MAKE_PROPERTY_D(@"Text Font", P_FONT, @selector(setFont:),@selector(getFont));

    pListArray = @[xc,yc,d0,d1,d2,d3,d4,d5,d6,d7,d8];

    NSMutableDictionary MAKE_ACTION_D(@"Button On", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Button Off", A_NUM, a2);
    NSMutableDictionary MAKE_ACTION_D(@"Changed", A_NUM, a3);
    actionArray = @[a1,a2,a3];

    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if( (self=[super initWithCoder:aDecoder]) ){
        toggleValue = [aDecoder decodeBoolForKey:@"toggleValue"];
        onColor = [aDecoder decodeObjectForKey:@"onColor"];
        offColor = [aDecoder decodeObjectForKey:@"offColor"];
        onText = [aDecoder decodeObjectForKey:@"onText"];
        offText = [aDecoder decodeObjectForKey:@"offText"];
        [(BButton*)csView addTarget:self action:@selector(pushAction:)];
        outputOn = [aDecoder decodeFloatForKey:@"outputOn"];
        outputOff = [aDecoder decodeFloatForKey:@"outputOff"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeBool:toggleValue forKey:@"toggleValue"];
    [encoder encodeObject:onColor forKey:@"onColor"];
    [encoder encodeObject:offColor forKey:@"offColor"];
    [encoder encodeObject:onText forKey:@"onText"];
    [encoder encodeObject:offText forKey:@"offText"];
    [encoder encodeFloat:outputOn forKey:@"outputOn"];
    [encoder encodeFloat:outputOff forKey:@"outputOff"];
}

#pragma mark - Gear's Unique Actions

-(void) pushAction:(id) sender
{
    SEL act;
    NSNumber *nsMagicNum;
    NSUInteger actNum;

    toggleValue = (toggleValue) ? NO : YES;

    // 1. State Changed
    act = ((NSValue*)((NSDictionary*)actionArray[2])[@"selector"]).pointerValue;
    nsMagicNum = ((NSDictionary*)actionArray[2])[@"mNum"];
    CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
    
    if( nil != gObj ){
        if( [gObj respondsToSelector:act] )
            [gObj performSelector:act withObject:@(toggleValue)];
        else
            EXCLAMATION;
    }

    // 2. On or Off actions
    actNum = ( toggleValue ) ? 1 : 0;

    act = ((NSValue*)((NSDictionary*)actionArray[actNum])[@"selector"]).pointerValue;
    nsMagicNum = ((NSDictionary*)actionArray[actNum])[@"mNum"];
    gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];

    if( nil != gObj ){
        if( [gObj respondsToSelector:act] ){
            [gObj performSelector:act withObject:@((toggleValue)?outputOn:outputOff)];
        }else
            EXCLAMATION;
    }

    // 버튼의 상태를 세팅한다.
    if( toggleValue ){
        [((BButton*)csView) setTitle:onText];
        [((BButton*)csView).layer setBackgroundColor:onColor.CGColor];
    }else{
        [((BButton*)csView) setTitle:offText];
        [((BButton*)csView).layer setBackgroundColor:offColor.CGColor];
    }
}


@end
