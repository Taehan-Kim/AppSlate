//
//  SaveModal.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 13. 5. 20..
//  Copyright (c) 2013년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "UATitledModalPanel.h"

@interface SaveModal : UATitledModalPanel <UITextFieldDelegate,SKStoreProductViewControllerDelegate>
{
//    UITextField *nField, *dField;
    UIButton *localBtn, *parseBtn;
}

@property (nonatomic, retain) UITextField *nField;
@property (nonatomic, retain) UITextField *dField;

@end
