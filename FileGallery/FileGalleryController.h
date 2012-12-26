//
//  FileGalleryController.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 1. 18..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookshelfViewController.h"

@interface FileGalleryController : UIViewController
{
    UIToolbar *toolbar;
    BookshelfViewController *bookshelfVC;

    NSUInteger mode;
}

@end
