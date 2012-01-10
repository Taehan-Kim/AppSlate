//
//  StringSettingViewController.h
//  AppSlate
//
//  Created by 태한 김 on 11. 12. 20..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewCommon.h"

@interface StringSettingViewController : SettingViewCommon
{
    UITextView *textField;

    BButton *saveBtn;
}

@end
