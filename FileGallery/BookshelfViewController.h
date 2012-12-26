//
//  BookshelfViewController.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 1. 18..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AQGridView.h"

#define SELECTION 0
#define DELETING  1
#define SENDING   2

@interface BookshelfViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource, MFMailComposeViewControllerDelegate>
{
    NSMutableArray * _imageNames;
    AQGridView * _gridView;

    NSString* documentsPath;
    id pObj;

    NSUInteger mode;
}

@property (nonatomic, retain) IBOutlet AQGridView * gridView;

-(void) setParentController:(id) obj;

-(void) setMode:(NSUInteger) mode;

@end
