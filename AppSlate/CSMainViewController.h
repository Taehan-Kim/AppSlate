//
//  CSMainViewController.h
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "CSFlipsideViewController.h"
#import "CSBlueprintController.h"

@interface CSMainViewController : UIViewController <CSFlipsideViewControllerDelegate>
{
    CSBlueprintController   *blueprintCtrl;
    IBOutlet    UIToolbar   *toolBar;
    __weak IBOutlet UIBarButtonItem *playButton;
    __weak IBOutlet UIBarButtonItem *stopButton;

    UIImage *psImage;
}

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

- (IBAction)showGearList:(id)sender;
- (IBAction)playAction:(id)sender;
- (IBAction)stopAction:(id)sender;

@end
