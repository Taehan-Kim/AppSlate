//
//  CSFlipsideViewController.h
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSFlipsideViewController;

@protocol CSFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(CSFlipsideViewController *)controller;
@end

@interface CSFlipsideViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *tableView;
    NSArray     *gearList;
}

@property (weak, nonatomic) IBOutlet id <CSFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
