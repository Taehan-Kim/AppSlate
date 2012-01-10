//
//  FontSettingController.h
//  AppSlate
//
//  Created by 김 태한 on 11. 12. 29..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewCommon.h"
#import "CMTextStylePickerViewController.h"

@interface FontSettingController : SettingViewCommon
{
    CMTextStylePickerViewController *cmtController;

    BButton *saveBtn;
}

@end
