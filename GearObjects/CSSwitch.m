//
//  CSSwitch.m
//  AppSlate
//
//  Created by 김태한 on 12. 01. 20..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSSwitch.h"

@implementation CSSwitch

-(id) object
{
    return ((UILabel*)csView);
}

//===========================================================================
#pragma mark -

-(void) setTintColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((UISwitch*)csView) setOnTintColor:color];
}

-(UIColor*) getTintColor
{
    return ((UISwitch*)csView).onTintColor;
}

-(void) setOnValue:(NSNumber*)BoolValue
{
    BOOL isOn = [BoolValue boolValue];

    [((UISwitch*)csView) setOn:isOn];
}

-(NSNumber*) getOnValue
{
    BOOL isOn = ((UISwitch*)csView).isOn;

    return [NSNumber numberWithBool:isOn];
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;

    csView = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, MINSIZE2)];
    [csView setBackgroundColor:[UIColor clearColor]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_SWITCH;
    csResizable = NO;

//    ((UILabel*)csView).textColor = [UIColor blackColor];
//    ((UILabel*)csView).font = CS_FONT(16);
    [(UISwitch*)csView setOn:YES];
    [(UISwitch*)csView addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
//    [(UILabel*)csView setClipsToBounds:YES];

    self.info = NSLocalizedString(@"Basic Switch", @"Basic Switch");

    NSDictionary *d1 = MAKE_PROPERTY_D(@"On Tint Color", P_COLOR, @selector(setTintColor:),@selector(getTintColor));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Default Value", P_BOOL, @selector(setOnValue:),@selector(getOnValue));

    pListArray = [NSArray arrayWithObjects:d1,d2, nil];

    NSMutableDictionary MAKE_ACTION_D(@"Changed Value", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Turn On", A_NUM, a2);
    NSMutableDictionary MAKE_ACTION_D(@"Turn Off", A_NUM, a3);
    actionArray = [NSArray arrayWithObjects:a1, a2, a3, nil];

    return self;
}

// 설정될 수 있는 속성 목록.
-(NSArray*) getPropertiesList
{
    return pListArray;
}

-(NSArray*) getActionList
{
    return actionArray;
}

#pragma mark - Gear's Unique Actions

-(void) valueChanged
{
    SEL act;
    NSNumber *nsMagicNum;
    BOOL myBoolValue = ((UISwitch*)csView).on;

    // 1. value changed
    act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:[NSNumber numberWithBool:myBoolValue]];
            else
                ; // todo: error handleing
        }
    }

    // 2. Did Turn On
    act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:1] objectForKey:@"selector"]).pointerValue;
    if( nil != act && myBoolValue ){
        nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:1]) objectForKey:@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:[NSNumber numberWithBool:YES]];
            else
                ; // todo: error handleing
        }
    }

    // 3. Did Turn Off
    act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:2] objectForKey:@"selector"]).pointerValue;
    if( nil != act && NO == myBoolValue ){
        nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:2]) objectForKey:@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:[NSNumber numberWithBool:YES]];
            else
                ; // todo: error handleing
        }
    }
}


@end
