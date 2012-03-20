//
//  AppSettingModal.h
//  AppSlate
//
//  Created by 김태한 on 12. 2. 28..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UATitledModalPanel.h"
#import "BButton.h"

@interface AppSettingModal : UATitledModalPanel <FBDialogDelegate>
{
    UISwitch   *sndSwitch, *hideSwitch, *gridSwitch, *lineSwitch, *fbSwitch;
    BButton    *resetAlphaBtn;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
