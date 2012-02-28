//
//  AppSettingModal.h
//  AppSlate
//
//  Created by 김태한 on 12. 2. 28..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UATitledModalPanel.h"

@interface AppSettingModal : UATitledModalPanel
{
    UISwitch   *sndSwitch;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;

@end
