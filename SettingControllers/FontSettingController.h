//
//  FontSettingController.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 11. 12. 29..
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
