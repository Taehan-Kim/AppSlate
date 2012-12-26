//
//  AppSettingModal.h
//  AppSlate
//
//  Created by Taehan Kim on 12. 2. 28..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UATitledModalPanel.h"
#import "BButton.h"

@interface AppSettingModal : UATitledModalPanel
{
    UISwitch   *sndSwitch, *hideSwitch, *gridSwitch, *lineSwitch;
    BButton    *resetAlphaBtn;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
