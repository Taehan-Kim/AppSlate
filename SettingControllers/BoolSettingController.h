//
//  BoolSettingController.h
//  AppSlate
//
//  Created by 김 태한 on 11. 12. 30..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "SettingViewCommon.h"

@interface BoolSettingController : SettingViewCommon
{
    UISwitch  *switchBtn;
    UILabel   *nameLabel;

    BButton *saveBtn;
}
@end
