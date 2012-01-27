//
//  BookshelfViewController.h
//  AppSlate
//
//  Created by 김 태한 on 12. 1. 18..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"

@interface BookshelfViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource>
{
    NSArray * _imageNames;
    AQGridView * _gridView;
}

@property (nonatomic, retain) IBOutlet AQGridView * gridView;

@end
