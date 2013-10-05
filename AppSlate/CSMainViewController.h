//
//  CSMainViewController.h
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>

#import "CSFlipsideViewController.h"
#import "CSLayerViewController.h"
#import "CSBlueprintController.h"
#import "PaperSetModal.h"
#import "AppSettingModal.h"
#import "InfoModal.h"
#import "MyLoginViewController.h"

@interface CSMainViewController : UIViewController <CSFlipsideViewControllerDelegate, UAModalPanelDelegate, PFLogInViewControllerDelegate>
{
    CSBlueprintController   *blueprintCtrl;
    UIToolbar   *toolBar;
    BOOL    runButton;
    UIViewController *menuFolder;
    SystemSoundID drawerOpenSoundID, drawerCloseSoundID;

    UIBarButtonItem *gearListButton;
    UIBarButtonItem *playButton;
    UIBarButtonItem *resetButton;
    UIBarButtonItem *menuButton;
    UIBarButtonItem *layerButton;

    UIImage *blueprintViewImage;
    UIView  *runIndicator;

    UIPopoverController *_layerPopoverController;
    NSString *cachingFilePath;
}

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;
//@property (strong, nonatomic) UIPopoverController *layerPopoverController;

- (void)OpenFileGallery:(id)sender;
- (void)folderWillClose:(id)sender;

- (IBAction)showGearList:(id)sender;
- (IBAction)showLayerList:(id)sender;
- (IBAction)playAction:(id)sender;
- (IBAction)openMenuFolder:(id)sender;

- (void)saveAction:(id)sender;

-(void) saveAppFile:(BOOL) isCaching;
-(UIImage*)resizedImage:(UIImage*)inImage inRect:(CGRect)thumbRect;

-(void) setBlueprintColor:(UIColor*)color;

@end
