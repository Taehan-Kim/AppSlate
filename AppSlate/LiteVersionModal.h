//
//  LiteVersionModal.h
//  AppSlate
//
//  Created by 김태한 on 2013. 12. 21..
//  Copyright (c) 2013년 ChocolateSoft. All rights reserved.
//

#import "UATitledModalPanel.h"
#import <StoreKit/StoreKit.h>

@interface LiteVersionModal : UATitledModalPanel <SKStoreProductViewControllerDelegate>
{
    SKStoreProductViewController *Sv;
}

@end
