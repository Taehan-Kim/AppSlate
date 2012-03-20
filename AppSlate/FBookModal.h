//
//  FBookModal.h
//  AppSlate
//
//  Created by 김태한 on 12. 2. 28..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UATitledModalPanel.h"
#import "BButton.h"

@interface FBookModal : UATitledModalPanel <UITextViewDelegate, FBDialogDelegate>
{
    UITextView *msgTextView;
    BButton    *sendBtn;
}

- (id)initWithFrame:(CGRect)frame message:(NSString *)message;

@end
