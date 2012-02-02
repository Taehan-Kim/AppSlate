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
    runButton = YES;
	// Do any additional setup after loading the view, typically from a nib.
    blueprintCtrl = [[CSBlueprintController alloc] init];
    [blueprintCtrl.view setFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                            self.view.frame.size.height-toolBar.frame.size.height)];
    [blueprintCtrl.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadAppFile:)
                                                 name:NOTI_FILELOAD object:nil];
    [self.view addSubview:blueprintCtrl.view];
}

- (void)viewDidUnload
{
    playButton = nil;
    gearListButton = nil;
    saveButton = nil;
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
            self.flipsidePopoverController.popoverContentSize = CGSizeMake(320, 550);
        }

        if ([self.flipsidePopoverController isPopoverVisible]) {
            [self.flipsidePopoverController dismissPopoverAnimated:YES];
        } else {
            [self.flipsidePopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

- (IBAction)playAction:(id)sender
{
//    [playButton setEnabled:NO];

    if( runButton ){
        runButton = NO;
        [gearListButton setEnabled:NO];
        [playButton setImage:[UIImage imageNamed:@"stop_.png"]];

        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RUN
                                                            object:nil];
    }
    else
    {
        runButton = YES;
        [gearListButton setEnabled:YES];
        [playButton setImage:[UIImage imageNamed:@"run_.png"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_STOP
                                                            object:nil];
    }

}

- (IBAction)saveAction:(id)sender
{
    // Screen capture and resize for app's icon image;
    UIGraphicsBeginImageContext(blueprintCtrl.view.frame.size);
	[blueprintCtrl.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *tmpImage = UIGraphicsGetImageFromCurrentImageContext();

    blueprintViewImage = [self resizedImage:tmpImage inRect:CGRectMake(0, 0, 88, 120)];

    NSLog(@"%f %f", blueprintViewImage.size.width, blueprintViewImage.scale);
	UIGraphicsEndImageContext();

    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:@"App Save" delegate:self
                                           cancelButtonTitle:@"Cancel"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"Save", @"Change Name and Save", nil];
    [ac showInView:self.view];
}

-(UIImage*)resizedImage:(UIImage*)inImage inRect:(CGRect)thumbRect
{     
	CGImageRef			imageRef = [inImage CGImage];
	CGImageAlphaInfo	alphaInfo = CGImageGetAlphaInfo(imageRef);
    
	// There's a wierdness with kCGImageAlphaNone and CGBitmapContextCreate
	// see Supported Pixel Formats in the Quartz 2D Programming Guide
	// Creating a Bitmap Graphics Context section
	// only RGB 8 bit images with alpha of kCGImageAlphaNoneSkipFirst, kCGImageAlphaNoneSkipLast, kCGImageAlphaPremultipliedFirst,
	// and kCGImageAlphaPremultipliedLast, with a few other oddball image kinds are supported
	// The images on input here are likely to be png or jpeg files
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
    
	// Build a bitmap context that's the size of the thumbRect
	CGFloat bytesPerRow;
    
	if( thumbRect.size.width > thumbRect.size.height ) {
		bytesPerRow = 4 * thumbRect.size.width;
	} else {
		bytesPerRow = 4 * thumbRect.size.height;
	}
    
	CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                thumbRect.size.width,		// width
                                                thumbRect.size.height,		// height
                                                8, //CGImageGetBitsPerComponent(imageRef),	// really needs to always be 8
                                                bytesPerRow, //4 * thumbRect.size.width,	// rowbytes
                                                CGImageGetColorSpace(imageRef),
                                                alphaInfo );

	// Draw into the context, this scales the image
	CGContextDrawImage(bitmap, thumbRect, imageRef);

	// Get an image from the context and a UIImage
	CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
	UIImage*	result = [UIImage imageWithCGImage:ref];

	CGContextRelease(bitmap);	// ok if NULL
	CGImageRelease(ref);

	return result;
}

#pragma mark - Delegate

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( nil == USERCONTEXT.appName )
        USERCONTEXT.appName = @"noname";

    switch ( buttonIndex ) {
        case 0:
            NSLog(@"Save");
            [self saveAppFile];
            break;
        case 1:
            NSLog(@"Change Name and Save");
            UIAlertView *renameAlert = [[UIAlertView alloc] initWithTitle:@"Rename"
                                                                  message:nil delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                        otherButtonTitles:@"OK", nil];
            [renameAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [[renameAlert textFieldAtIndex:0] setText:USERCONTEXT.appName];
            [renameAlert show];
            break;
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( 0 == buttonIndex ) return;  // cancel is do nothing.

    NSLog(@"Do rename");
    [USERCONTEXT setAppName:[alertView textFieldAtIndex:0].text];

    [self saveAppFile];
}

//------------------------------------------------------------------------------------------------------
#pragma mark -

-(void) saveAppFile
{
#ifdef TARGET_IPHONE_SIMULATOR
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
#else
    NSString* documentsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#endif
    NSString *pkgName = [USERCONTEXT.appName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *theFile = [documentsPath stringByAppendingPathComponent:pkgName];
    // TODO:Save As 인 경우 덮어쓰기 체크를 해 주자.
//    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:theFile];

    START_WAIT_VIEW;

    dispatch_async(dispatch_queue_create("fw", NULL), ^(void)
    {
        NSError *error;

        // mkdir
        if (![[NSFileManager defaultManager] createDirectoryAtPath:theFile
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
        
        // write contents
        // NOTE: NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if( ![NSKeyedArchiver archiveRootObject:USERCONTEXT.gearsArray
                                        toFile:[theFile stringByAppendingPathComponent:@"Contents.obj"]] )
        {
            NSLog(@"File error");
        }
        
        // write screenshot
        [UIImagePNGRepresentation(blueprintViewImage) writeToFile:[theFile stringByAppendingPathComponent:@"Face.png"] atomically:YES];

        STOP_WAIT_VIEW;
    });

}

-(void) loadAppFile:(NSNotification*) noti
{
    if( ![[NSFileManager defaultManager] fileExistsAtPath:noti.object] ){
        // Error
        return;
    }

    START_WAIT_VIEW;
    dispatch_async(dispatch_queue_create("fw", NULL), ^(void)
    {
        [blueprintCtrl deleteAllGear];

        NSLog(@"%@",noti.object);
    
        NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:noti.object];
        NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:fileData];
        [USERCONTEXT.gearsArray addObjectsFromArray:array];

        [blueprintCtrl putAllGearsToView];

        for( CSGearObject *g in USERCONTEXT.gearsArray )
            [g makeUpSelectorArray];

        STOP_WAIT_VIEW;
    });
}

@end
