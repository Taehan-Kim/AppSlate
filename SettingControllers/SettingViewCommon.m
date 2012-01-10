//
//  SettingViewCommon.m
//  AppSlate
//
//  Created by 김 태한 on 11. 12. 29..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "SettingViewCommon.h"
#import <objc/message.h>

@interface SettingViewCommon ()

@end

@implementation SettingViewCommon


#pragma mark -

-(void) setGearValue:(id)gear propertyInfo:(NSDictionary*)infoDic
{
    theGear = gear;
    pInfoDic = infoDic;
}

-(void) saveValue:(id)value
{
    SEL selector = [[pInfoDic objectForKey:@"selector"] pointerValue];

    if( [theGear respondsToSelector:selector] )
//        [theGear performSelector:selector withObject:value]; 이것과 아래 코드는 같다.
        objc_msgSend(theGear, selector, value);
    else {
        // TODO: Error Handling
    }
}

@end
