//
//  SettingViewCommon.h
//  AppSlate
//
//  Created by 태한 김 on 11. 12. 20..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "CSGearObject.h"

#define C_GAP   7
#define C_WIDTH (self.view.frame.size.width-(C_GAP*2))

@interface SettingViewCommon : UIViewController
{    
    id    theGear;
    NSDictionary *pInfoDic;
}

-(void) setGearValue:(id)gear propertyInfo:(NSDictionary*)infoDic;

-(void) saveValue:(id)value;

- (id)initWithGear:(id)gear propertyInfo:(NSDictionary*)infoDic;

@end
