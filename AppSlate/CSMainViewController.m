//
//  CSMainViewController.m
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "CSMainViewController.h"
#import "FileGalleryController.h"

@implementation CSMainViewController

@synthesize flipsidePopoverController = _flipsidePopoverController;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    blueprintCtrl = [[CSBlueprintController alloc] init];
    [blueprintCtrl.view setFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                            self.view.frame.size.height-toolBar.frame.size.height)];
    [blueprintCtrl.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];

    [self.view addSubview:blueprintCtrl.view];
}

- (void)viewDidUnload
{
    playButton = nil;
    stopButton = nil;
    gearListButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//    } else {
//        return YES;
//    }
    if( interfaceOrientation == UIInterfaceOrientationPortrait ||
       interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown )
        return YES;

    return NO;
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(CSFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissModalViewControllerAnimated:YES];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (IBAction)OpenFileGallery:(id)sender {
    FileGalleryController *fvc = [[FileGalleryController alloc] init];

    [fvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentModalViewController:fvc animated:YES];
}

- (IBAction)showGearList:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        CSFlipsideViewController *controller = [[CSFlipsideViewController alloc] initWithNibName:@"CSFlipsideViewController" bundle:nil];
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:controller animated:YES];
    } else {
        if (!self.flipsidePopoverController) {
            CSFlipsideViewController *controller = [[CSFlipsideViewController alloc] initWithNibName:@"CSFlipsideViewController" bundle:nil];
            controller.delegate = self;
            
            self.flipsidePopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
        }
        if ([self.flipsidePopoverController isPopoverVisible]) {
            [self.flipsidePopoverController dismissPopoverAnimated:YES];
        } else {
            [self.flipsidePopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

- (IBAction)playAction:(id)sender {
    [playButton setEnabled:NO];
    [stopButton setEnabled:YES];
    [gearListButton setEnabled:NO];

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RUN
                                                        object:nil];

}

- (IBAction)stopAction:(id)sender {
    [playButton setEnabled:YES];
    [stopButton setEnabled:NO];

    [gearListButton setEnabled:YES];

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_STOP
                                                        object:nil];
    
}

@end
