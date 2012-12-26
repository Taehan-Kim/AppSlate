//
//  NumberSettingViewController.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 01. 26..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewCommon.h"

@interface NumberSettingViewController : SettingViewCommon <UITextFieldDelegate>
{
    UITextField *textField;

    BButton *saveBtn;
}

@end
