//
//  CellSettingController.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 1. 27..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewCommon.h"

@interface CellSettingController : SettingViewCommon<UITextFieldDelegate, UITextViewDelegate>
{
    UITextField *indexField;
    UITextView *textField;
    UITextView *subTextField;

    BButton *getBtn;
    BButton *saveBtn;
}

@end
