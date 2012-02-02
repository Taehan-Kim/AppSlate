//
//  CSMainViewController.h
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "CSFlipsideViewController.h"
#import "CSBlueprintController.h"

@interface CSMainViewController : UIViewController <CSFlipsideViewControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    CSBlueprintController   *blueprintCtrl;
    IBOutlet    UIToolbar   *toolBar;
    BOOL    runButton;
    __weak IBOutlet UIBarButtonItem *playButton;
    __weak IBOutlet UIBarButtonItem *gearListButton;
    __weak IBOutlet UIBarButtonItem *saveButton;

    UIImage *blueprintViewImage;
}

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

- (IBAction)OpenFileGallery:(id)sender;

- (IBAction)showGearList:(id)sender;
- (IBAction)playAction:(id)sender;
- (IBAction)saveAction:(id)sender;

-(void) saveAppFile;
-(UIImage*)resizedImage:(UIImage*)inImage inRect:(CGRect)thumbRect;

@end
