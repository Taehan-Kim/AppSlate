//
//  CSSlider.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 01. 26..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSSlider.h"

@implementation CSSlider

-(id) object
{
    return ((UISlider*)csView);
}

//===========================================================================
#pragma mark -

-(void) setMinimumBarColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((UISlider*)csView) setMinimumTrackTintColor:color];
}

-(UIColor*) getMinimumBarColor
{
    return ((UISlider*)csView).minimumTrackTintColor;
}

-(void) setMaximumBarColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((UISlider*)csView) setMaximumTrackTintColor:color];
}

-(UIColor*) getMaximumBarColor
{
    return ((UISlider*)csView).maximumTrackTintColor;
}

-(void) setThumbColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((UISlider*)csView) setThumbTintColor:color];
}

-(UIColor*) getThumbColor
{
    return ((UISlider*)csView).thumbTintColor;
}

-(void) setMinimumValue:(NSNumber*)number
{
    if( [number isKindOfClass:[NSNumber class]] )
        [((UISlider*)csView) setMinimumValue:[number floatValue]];
    else if( [number isKindOfClass:[NSString class]] )
        [((UISlider*)csView) setMinimumValue:[(NSString*)number length]];
}

-(NSNumber*) getMinimumValue
{
    return @( ((UISlider*)csView).minimumValue );
}

-(void) setMaximumValue:(NSNumber*)number
{
    if( [number isKindOfClass:[NSNumber class]] )
        [((UISlider*)csView) setMaximumValue:[number floatValue]];
    else if( [number isKindOfClass:[NSString class]] )
        [((UISlider*)csView) setMaximumValue:[(NSString*)number length]];
}

-(NSNumber*) getMaximumValue
{
    return @( ((UISlider*)csView).maximumValue );
}

-(void) setThumbValue:(NSNumber*)number
{
    CGFloat toValue;
    if( [number isKindOfClass:[NSNumber class]] )
        toValue = [number floatValue];
    else if( [number isKindOfClass:[NSString class]] )
        toValue = [(NSString*)number length];
    else{
        EXCLAMATION;
        return;
    }

    if( toValue > ((UISlider*)csView).maximumValue )
        toValue = ((UISlider*)csView).maximumValue;

    if( toValue < ((UISlider*)csView).minimumValue )
        toValue = ((UISlider*)csView).minimumValue;

    [((UISlider*)csView) setValue:toValue animated:YES];
}

-(NSNumber*) getThumbValue
{
    return @( ((UISlider*)csView).value );
}

-(void) setContinuosChange:(NSNumber*)boolVal
{
    if( [boolVal isKindOfClass:[NSNumber class]] )
        [((UISlider*)csView) setContinuous:[boolVal boolValue]];
}

-(NSNumber*) getContinuosChange
{
    return@( ((UISlider*)csView).continuous );
}

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;

    csView = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 400, MINSIZE)];
    [csView setBackgroundColor:[UIColor clearColor]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_SLIDER;
    isUIObj = YES;

    [((UISlider*)csView) setMinimumValue:0];
    [((UISlider*)csView) setMaximumValue:10];
    [((UISlider*)csView) setValue:5];
    [((UISlider*)csView) setContinuous:NO];
    [((UISlider*)csView) setMinimumTrackTintColor:[UIColor darkGrayColor]];
    [((UISlider*)csView) setMaximumTrackTintColor:[UIColor whiteColor]];
    [((UISlider*)csView) setThumbTintColor:[UIColor whiteColor]];
    [((UISlider*)csView) addTarget:self action:@selector(changedValue:) forControlEvents:UIControlEventValueChanged];

    self.info = NSLocalizedString(@"Slider", @"Slider");

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Value", P_NUM, @selector(setThumbValue:),@selector(getThumbValue));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Minimum Value", P_NUM, @selector(setMinimumValue:),@selector(getMinimumValue));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Maximum Value", P_NUM, @selector(setMaximumValue:),@selector(getMaximumValue));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Minimum Bar Color", P_COLOR, @selector(setMinimumBarColor:),@selector(getMinimumBarColor));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"Maximum Bar Color", P_COLOR, @selector(setMaximumBarColor:),@selector(getMaximumBarColor));
    NSDictionary *d6 = MAKE_PROPERTY_D(@"Thumb Color", P_COLOR, @selector(setThumbColor:),@selector(getThumbColor));
    NSDictionary *d7 = MAKE_PROPERTY_D(@"Continuos Change", P_BOOL, @selector(setContinuosChange:),@selector(getContinuosChange));

    pListArray = @[xc,yc,d0,d1,d2,d3,d4,d5,d6,d7];

    NSMutableDictionary MAKE_ACTION_D(@"Changed Value", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Minimum Value", A_NUM, a2);
    NSMutableDictionary MAKE_ACTION_D(@"Maximum Value", A_NUM, a3);
    actionArray = @[a1, a2, a3];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [((UISlider*)csView) addTarget:self action:@selector(changedValue:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

#pragma mark - Gear's Unique Actions

-(void) changedValue:(id) sender
{
    SEL act;
    NSNumber *nsMagicNum;
    CGFloat myValue = ((UISlider*)sender).value;

    // 1. value changed
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:@(myValue)];
            else
                EXCLAMATION;
        }
    }

    // 2. did min value
    act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
    if( nil != act && myValue == ((UISlider*)sender).minimumValue )
    {
        nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:@(myValue)];
            else
                EXCLAMATION;
        }
    }

    // 3. did max value
    act = ((NSValue*)((NSDictionary*)actionArray[2])[@"selector"]).pointerValue;
    if( nil != act && myValue == (NSUInteger)((UISlider*)sender).maximumValue )
    {
        nsMagicNum = ((NSDictionary*)actionArray[2])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:@(myValue)];
            else
                EXCLAMATION;
        }
    }
}

@end
