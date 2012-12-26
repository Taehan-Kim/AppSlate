//
//  InfoModal.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 17..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UATitledModalPanel.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface InfoModal : UATitledModalPanel <MFMailComposeViewControllerDelegate>
{
    UILabel *turnOffLabel;
}

@end
