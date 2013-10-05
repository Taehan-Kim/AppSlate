//
//  CSTouchButton.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 2. 19..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSTouchButton.h"

@implementation CSTouchButton

-(id) object
{
    return ((BButton*)csView);
}

//===========================================================================
#pragma mark -

-(void) setTintColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((BButton*)csView).layer setBackgroundColor:color.CGColor];
}

-(UIColor*) getTintColor
{
    return [UIColor colorWithCGColor:((BButton*)csView).layer.backgroundColor];
}

-(void) setText:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        [((BButton*)csView) setTitle:txt];
    
    else if([txt isKindOfClass:[NSNumber class]] )
        [((BButton*)csView) setTitle:[((NSNumber*)txt) stringValue]];
}

-(NSString*) getText
{
    return ((BButton*)csView).btn.titleLabel.text;
}

-(void) setTextColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((BButton*)csView) setTitleColor:color];
}

-(void) setOutputValue:(NSNumber*) number
{
    if( [number isKindOfClass:[NSNumber class]] )
        output = [number floatValue];
    else if( [number isKindOfClass:[NSString class]] )
        output = [(NSString*)number length];
    else
        EXCLAMATION;
}

-(NSNumber*) getOutputValue
{
    return @(output);
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
    
    csView = [[BButton alloc] initWithFrame:CGRectMake(0, 0, 130, MINSIZE2)];
    [csView setUserInteractionEnabled:YES];
    [((BButton*)csView).layer setBackgroundColor:[UIColor lightGrayColor].CGColor];

    csCode = CS_TOUCHBTN;
    output = 1.0;

    [((BButton*)csView) setTitle:NSLocalizedString(@"Touch Button", @"Touch Button")];
    [((BButton*)csView).btn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchDown];
    [((BButton*)csView).btn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpInside];
    [((BButton*)csView).btn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpOutside];

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Tint Color", P_COLOR, @selector(setTintColor:),@selector(getTintColor));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Button Text", P_TXT, @selector(setText:),@selector(getText));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Output Value", P_NUM, @selector(setOutputValue:),@selector(getOutputValue));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Text Color", P_COLOR, @selector(setTextColor:),@selector(getTextColor));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"Text Font", P_FONT, @selector(setFont:),@selector(getFont));
    
    pListArray = @[xc,yc,d0,d1,d2,d3,d4,d5];
    
    NSMutableDictionary MAKE_ACTION_D(@"Push Up & Down", A_NUM, a1);
    actionArray = @[a1];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [((BButton*)csView).btn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchDown];
        [((BButton*)csView).btn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpInside];
        [((BButton*)csView).btn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpOutside];
        output = [decoder decodeFloatForKey:@"output"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeFloat:output forKey:@"output"];
}

#pragma mark - Gear's Unique Actions

-(void) pushAction
{
    SEL act;
    NSNumber *nsMagicNum;
    
    // 3. Did Turn Off
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    
    nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
    CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
    
    if( nil != gObj ){
        if( [gObj respondsToSelector:act] )
            [gObj performSelector:act withObject:@(output)];
        else
            EXCLAMATION;
    }
}

-(void) releaseAction
{
    SEL act;
    NSNumber *nsMagicNum;
    
    // 3. Did Turn Off
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    
    nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
    CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
    
    if( nil != gObj ){
        if( [gObj respondsToSelector:act] )
            [gObj performSelector:act withObject:@NO];
        else
            EXCLAMATION;
    }
}

@end
