//
//  CSMainViewController.h
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import "CSFlipsideViewController.h"
#import "CSLayerTableViewController.h"
#import "CSBlueprintController.h"
#import "PaperSetModal.h"

@interface CSMainViewController : UIViewController <CSFlipsideViewControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UAModalPanelDelegate>
{
    CSBlueprintController   *blueprintCtrl;
    IBOutlet    UIToolbar   *toolBar;
    BOOL    runButton;
    UIViewController *menuFolder;
    SystemSoundID drawerOpenSoundID, drawerCloseSoundID;

    __weak IBOutlet UIBarButtonItem *playButton;
    __weak IBOutlet UIBarButtonItem *gearListButton;
    __weak IBOutlet UIBarButtonItem *menuButton;
    __weak IBOutlet UIBarButtonItem *layerButton;

    UIImage *blueprintViewImage;
    UIView  *runIndicator;
}

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
@property (strong, nonatomic) UIPopoverController *layerPopoverController;

- (void)OpenFileGallery:(id)sender;
- (void)folderWillClose:(id)sender;

- (IBAction)showGearList:(id)sender;
- (IBAction)showLayerList:(id)sender;
- (IBAction)playAction:(id)sender;
- (IBAction)openMenuFolder:(id)sender;

- (void)saveAction:(id)sender;

-(void) saveAppFile;
-(UIImage*)resizedImage:(UIImage*)inImage inRect:(CGRect)thumbRect;

-(void) setBlueprintColor:(UIColor*)color;

@end
