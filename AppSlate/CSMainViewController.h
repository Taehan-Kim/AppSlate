//
//  CSMainViewController.h
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "CSFlipsideViewController.h"

@interface CSMainViewController : UIViewController <CSFlipsideViewControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

- (IBAction)showInfo:(id)sender;

@end
