//
//  CSMainViewController.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "CSMainViewController.h"
#import "FileGalleryController.h"
#import "JWFolders.h"
#import "WelcomeMovieModal.h"

#define CACHE_NAME @"AppSlateCacheBackup.pkg"

enum alertTypes {
    kRenameAlert = 10,
    kNewAlert,
    kNone
};

@implementation CSMainViewController

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

    //
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        CGFloat h = [[UIScreen mainScreen] bounds].size.height;
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, h-44-20, 320, 44)];
    } else {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 1004-44, 768, 44)];
    }
    menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"i_menu.png"] style:UIBarButtonItemStyleBordered
                                                     target:self
                                                     action:@selector(openMenuFolder:)];
    playButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"run_.png"] style:UIBarButtonItemStyleBordered
                                                     target:self
                                                     action:@selector(playAction:)];
    [playButton setTintColor:[UIColor redColor]];
    UIBarButtonItem *stItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    layerButton = [[UIBarButtonItem alloc] initWithTitle:@"L" style:UIBarButtonItemStyleBordered
                                                  target:self action:@selector(showLayerList:)];
    gearListButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                   target:self action:@selector(showGearList:)];
    [gearListButton setStyle:UIBarButtonItemStyleBordered];

    NSArray *ary = [[NSArray alloc] initWithObjects: menuButton, stItem, playButton, stItem, layerButton, gearListButton, nil];
    [toolBar setItems:ary];
    [toolBar setTintColor:[UIColor darkGrayColor]];

    [self.view addSubview:toolBar];

    //----------------
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"drawerOpen" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &drawerOpenSoundID);
    fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"drawerClose" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &drawerCloseSoundID);

    blueprintCtrl = [[CSBlueprintController alloc] init];
    [blueprintCtrl.view setFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                            self.view.frame.size.height-toolBar.frame.size.height)];
    [blueprintCtrl.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadAppFile:)
                                                 name:NOTI_FILELOAD object:nil];
    [self.view addSubview:blueprintCtrl.view];

    // 처음 사용자라면 안내 동영상을 보여주자.
    if( ![[NSUserDefaults standardUserDefaults] boolForKey:@"WELCOME_SWITCH"] )
    {
        // button guide view
        UIView *guideView = [[UIView alloc] initWithFrame:self.view.bounds];
        UITapGestureRecognizer *g_tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeGuide:)];
        [guideView addGestureRecognizer:g_tapGR];
        [guideView setBackgroundColor:CS_RGBA(0, 0, 0, 0.4)];

        UIImageView *ii;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            ii = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-20-73, 320, 73)];
            [ii setImage:[UIImage imageNamed:@"btn_guide_p.png"]];
        } else {
            ii = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1000-174, 768, 174)];
            [ii setImage:[UIImage imageNamed:@"btn_guide.png"]];
        }
        [guideView addSubview:ii];
        [self.view addSubview:guideView];

        // Modal popup view
        WelcomeMovieModal *wmv = [[WelcomeMovieModal alloc] initWithFrame:self.view.bounds];
        
        wmv.onClosePressed = ^(UAModalPanel* panel) {
            // [panel hide];
            [panel hideWithOnComplete:^(BOOL finished) {
                [panel removeFromSuperview];
            }];
            [[NSUserDefaults standardUserDefaults] synchronize];
        };

        [self.view addSubview:wmv];
        [wmv showFromPoint:self.view.center];
    }

    // 처음 실행 체크.
    if( ![[NSUserDefaults standardUserDefaults] boolForKey:@"APPSLATE_FIRST"] ){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"APPSLATE_FIRST"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SND_SET"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HIDE_SET"];
    }
    _layerPopoverController = nil;
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
#pragma mark -

-(void) makeRunIndicatorView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        runIndicator = [[UIView alloc] initWithFrame:CGRectMake(130.5, self.view.bounds.size.height-40, 59, 38)];
    else
        runIndicator = [[UIView alloc] initWithFrame:CGRectMake(354.5, 1004-40, 59, 38)];

    [runIndicator setUserInteractionEnabled:NO];

    CALayer*alphaLayer = [CALayer layer];
    alphaLayer.contents = (__bridge id)([UIImage imageNamed:@"runningImageMask.png"].CGImage);
    alphaLayer.frame = runIndicator.bounds;

    [runIndicator.layer setMask:alphaLayer];
    [runIndicator.layer setMasksToBounds:YES];

    UIImageView *runImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"runningLight.png"]];
    [runImg setFrame:CGRectMake(0, -10, 60, 60)];
    [runIndicator addSubview:runImg];    

    [runIndicator setBackgroundColor:CSCLEAR];
    [self.view addSubview:runIndicator];

    // Rotation Infinitly
    [UIView animateWithDuration:2.5 delay:0.0
                        options:UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveLinear
                     animations:^()
    {
         CGAffineTransform transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(179.9));
         runImg.transform = transform;
    } completion:^(BOOL finish){}];
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(CSFlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)OpenFileGallery:(id)sender
{
    FileGalleryController *fvc = [[FileGalleryController alloc] init];
    [self folderWillClose:nil];

    [fvc setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:fvc animated:YES completion:NULL];
}

- (IBAction)showGearList:(id)sender
{
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CSFlipsideViewController *controller = [[CSFlipsideViewController alloc] initWithNibName:@"CSFlipsideViewController" bundle:nil];
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:controller animated:YES completion:NULL];
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
    if( runButton ){
        runButton = NO;
        [layerButton setEnabled:NO];
        [gearListButton setEnabled:NO];
        [menuButton setEnabled:NO];
        [playButton setImage:[UIImage imageNamed:@"stop_.png"]];

        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RUN
                                                            object:nil];
        [self makeRunIndicatorView];
    }
    else
    {
        runButton = YES;
        [layerButton setEnabled:YES];
        [gearListButton setEnabled:YES];
        [menuButton setEnabled:YES];
        [playButton setImage:[UIImage imageNamed:@"run_.png"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_STOP
                                                            object:nil];
        [runIndicator removeFromSuperview];
        runIndicator = nil;
    }
}

- (IBAction)openMenuFolder:(id)sender
{
    menuFolder = [[UIViewController alloc] init];
    [menuFolder.view setFrame:CGRectMake(0, 0, blueprintCtrl.view.frame.size.width, 75)];
    [menuFolder.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"plateBack.png"]]];

    UIButton *b0 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [b0 setBackgroundImage:[UIImage imageNamed:@"i_files.png"] forState:UIControlStateNormal];
    [b0 addTarget:self action:@selector(OpenFileGallery:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *b1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [b1 setBackgroundImage:[UIImage imageNamed:@"i_new.png"] forState:UIControlStateNormal];
    [b1 addTarget:self action:@selector(newContentAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *b2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [b2 setBackgroundImage:[UIImage imageNamed:@"i_save.png"] forState:UIControlStateNormal];
    [b2 addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *b3 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [b3 setBackgroundImage:[UIImage imageNamed:@"i_phone.png"] forState:UIControlStateNormal];
    [b3 addTarget:self action:@selector(paperAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *b4 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [b4 setBackgroundImage:[UIImage imageNamed:@"i_setting.png"] forState:UIControlStateNormal];
    [b4 addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *b5 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [b5 setBackgroundImage:[UIImage imageNamed:@"i_info.png"] forState:UIControlStateNormal];
    [b5 addTarget:self action:@selector(infoAction:) forControlEvents:UIControlEventTouchUpInside];

    UILabel *l0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 15)];
    [l0 setText:@"Files"];
    UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 15)];
    [l1 setText:@"New"];
    UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 15)];
    [l2 setText:@"Save"];
    UILabel *l3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 15)];
    [l3 setText:@"Paper"];
    UILabel *l4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 15)];
    [l4 setText:@"Setting"];
    UILabel *l5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 15)];
    [l5 setText:@"Info"];
    UIScrollView *hsview = [[UIScrollView alloc] initWithFrame:menuFolder.view.frame];
    [hsview setBackgroundColor:[UIColor clearColor]];
    [hsview setShowsHorizontalScrollIndicator:NO];
    [hsview setShowsVerticalScrollIndicator:NO];

    NSArray *btns = @[b0,b1,b2,b3,b4,b5];
    NSArray *labs = @[l0,l1,l2,l3,l4,l5];
    [hsview setContentSize:CGSizeMake([btns count]*65+50, menuFolder.view.frame.size.height)];
    NSUInteger idx = 0;
    for( UIButton *btn in btns ){
        [btn setFrame:CGRectOffset(btn.frame, idx*68 + 30, 11)];
        [btn.layer setShadowColor:[UIColor blackColor].CGColor];
        [btn.layer setShadowRadius:5.0];
        [btn.layer setShadowOffset:CGSizeMake(0, 1)];
        [btn.layer setShadowOpacity:0.8];
        [hsview addSubview:btn];
        idx ++;
    }

    idx = 0;
    for( UILabel *btn in labs ){
        [btn setFrame:CGRectOffset(btn.frame, idx*68 + 26, 47)];
//        [btn.layer setShadowColor:[UIColor blackColor].CGColor];
        [btn setBackgroundColor:CSCLEAR];
        [btn setFont:CS_FONT(14)];
        [btn setTextColor:[UIColor lightGrayColor]];
        [btn setTextAlignment:NSTextAlignmentCenter];
        [btn setShadowColor:[UIColor blackColor]];
        [btn setShadowOffset:CGSizeMake(1, 1)];
//        [btn.layer setShadowRadius:5.0];
//        [btn.layer setShadowOffset:CGSizeMake(0, 1)];
//        [btn.layer setShadowOpacity:0.8];
        [hsview addSubview:btn];
        idx ++;
    }

    [menuFolder.view addSubview:hsview];

    if( [[NSUserDefaults standardUserDefaults] boolForKey:@"SND_SET"] ){
        AudioServicesPlaySystemSound( drawerOpenSoundID );
    }

    [JWFolders openFolderWithViewController:menuFolder atPosition:CGPointMake(10, blueprintCtrl.view.frame.size.height-55) inContainerView:self.view sender:self];
}

- (IBAction)showLayerList:(id)sender
{
    // 목록이 없다면 동작하지도 말자.
    if( 0 == [USERCONTEXT.gearsArray count] ) return;

    // 컨트롤 버튼 3개는 화면에서 없어야 한다. View 의 Layer 순서 처리에 방해가 된다.
    [blueprintCtrl removeModifyMode];

    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//        CSLayerViewController *controller = [[CSLayerViewController alloc] init];
        CSLayerTableViewController *controller = [[CSLayerTableViewController alloc] initWithStyle:UITableViewStylePlain];
        controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        UINavigationController *naviCtrl = [[UINavigationController alloc] initWithRootViewController:controller];
        [controller setBlueprintViewController:blueprintCtrl];
        [self presentViewController:naviCtrl animated:YES completion:NULL];
    } else {
        if (!_layerPopoverController) {
            CSLayerTableViewController *controller = [[CSLayerTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [controller setBlueprintViewController:blueprintCtrl];

            _layerPopoverController = [[UIPopoverController alloc] initWithContentViewController:controller];
        }
        if( ([USERCONTEXT.gearsArray count] * 45) < 700 )
            _layerPopoverController.popoverContentSize = CGSizeMake(320, ([USERCONTEXT.gearsArray count] * 45) );
        
        if( [_layerPopoverController isPopoverVisible] )
            [_layerPopoverController dismissPopoverAnimated:YES];
        else
            [_layerPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)folderWillClose:(id)sender
{
    if( [[NSUserDefaults standardUserDefaults] boolForKey:@"SND_SET"] )
        AudioServicesPlaySystemSound( drawerCloseSoundID );

    [JWFolders closeFolderWithCompletionBlock:^{
        if( menuFolder )
            [menuFolder.view removeFromSuperview], menuFolder = nil;
    }];    
}

#pragma mark -

- (void)newContentAction:(id)sender
{
    UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"New Slate"
                                                          message:@"Reset your slate." delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"OK", nil];
    [newAlert setAlertViewStyle:UIAlertViewStyleDefault];
    [newAlert setTag:kNewAlert];
    [newAlert show];
}

- (void)saveAction:(id)sender
{
    [self folderWillClose:nil];

    // Screen capture and resize for app's icon image;
    UIGraphicsBeginImageContext(blueprintCtrl.view.frame.size);
	[blueprintCtrl.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *tmpImage = UIGraphicsGetImageFromCurrentImageContext();

    blueprintViewImage = [self resizedImage:tmpImage inRect:CGRectMake(0, 0, 88, 120)];

//    NSLog(@"%f %f", blueprintViewImage.size.width, blueprintViewImage.scale);
	UIGraphicsEndImageContext();

    if( nil == USERCONTEXT.appName )
        USERCONTEXT.appName = @"noname";

    UIActionSheet *ac = [[UIActionSheet alloc] initWithTitle:USERCONTEXT.appName delegate:self
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

-(void)paperAction:(id)sender
{
    PaperSetModal *modalPanel = [[PaperSetModal alloc] initWithFrame:blueprintCtrl.view.bounds
                                                               title:@"Slate Wallpaper"];
    modalPanel.delegate = self;
    modalPanel.onClosePressed = ^(UAModalPanel* panel) {
        // [panel hide];
        [panel hideWithOnComplete:^(BOOL finished) {
            [panel removeFromSuperview];
        }];
    };

    [self folderWillClose:nil];

    [blueprintCtrl.view addSubview:modalPanel];
    [modalPanel showFromPoint:[(UIButton*)sender center]];
}

-(void)settingAction:(id)sender
{
    AppSettingModal *modalPanel = [[AppSettingModal alloc] initWithFrame:blueprintCtrl.view.bounds
                                                               title:@"Settings"];
    modalPanel.delegate = self;
    modalPanel.onClosePressed = ^(UAModalPanel* panel) {
        // [panel hide];
        [panel hideWithOnComplete:^(BOOL finished) {
            [panel removeFromSuperview];
        }];
    };
    
    [self folderWillClose:nil];
    
    [blueprintCtrl.view addSubview:modalPanel];
    [modalPanel showFromPoint:[(UIButton*)sender center]];
}

-(void)infoAction:(id)sender
{
    InfoModal *modalPanel = [[InfoModal alloc] initWithFrame:blueprintCtrl.view.bounds];
    modalPanel.delegate = self;
    modalPanel.onClosePressed = ^(UAModalPanel* panel) {
        // [panel hide];
        [panel hideWithOnComplete:^(BOOL finished) {
            [panel removeFromSuperview];
        }];
    };
    
    [self folderWillClose:nil];
    
    [blueprintCtrl.view addSubview:modalPanel];
    [modalPanel showFromPoint:[(UIButton*)sender center]];
}

#pragma mark - Delegate

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch ( buttonIndex ) {
        case 0:
            NSLog(@"Save");
            [self saveAppFile:NO];
            break;
        case 1:
            NSLog(@"Change Name and Save");
            UIAlertView *renameAlert = [[UIAlertView alloc] initWithTitle:@"Rename"
                                                                  message:nil delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                        otherButtonTitles:@"OK", nil];
            [renameAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [[renameAlert textFieldAtIndex:0] setText:USERCONTEXT.appName];
            [renameAlert setTag:kRenameAlert];
            [renameAlert show];
            break;
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( 0 == buttonIndex ) return;  // cancel is do nothing.

    switch ( alertView.tag ) {
        case kRenameAlert:            
            NSLog(@"Do rename");
            [USERCONTEXT setAppName:[alertView textFieldAtIndex:0].text];
            
            [self saveAppFile:NO];
            break;
        case kNewAlert:
            NSLog(@"Do New");
            [self folderWillClose:nil];
            [blueprintCtrl deleteAllGear];
            USERCONTEXT.appName = @"noname";
            break;

        default:
            break;
    }
}

//------------------------------------------------------------------------------------------------------
#pragma mark -

-(void) saveAppFile:(BOOL) isCaching
{
    NSString* documentsPath;
    NSUInteger pathType;
    if( isCaching )
        pathType = NSCachesDirectory;
    else {
        pathType = NSDocumentDirectory;
        START_WAIT_VIEW;
    }

#ifdef TARGET_IPHONE_SIMULATOR
    documentsPath = NSSearchPathForDirectoriesInDomains(pathType, NSUserDomainMask, YES)[0];
#else
    documentsPath = [[NSSearchPathForDirectoriesInDomains(pathType, NSUserDomainMask, YES) objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#endif
    NSString *pkgName;
    if( isCaching ) {
        pkgName = CACHE_NAME;
        [[NSUserDefaults standardUserDefaults] setObject:USERCONTEXT.appName forKey:@"CACHENAME"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        pkgName = [[USERCONTEXT.appName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByAppendingString:@".pkg"];
    }

    NSString *theFile = [documentsPath stringByAppendingPathComponent:pkgName];
    // TODO:Save As 인 경우 덮어쓰기 체크를 해 주자.
//    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:theFile];

    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        NSError *error;

        // mkdir
        if (![[NSFileManager defaultManager] createDirectoryAtPath:theFile
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
            if( error.code != 516 ){
                STOP_WAIT_VIEW;
                return;
            }
        }
        
        // write contents
        // NOTE: NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if( ![NSKeyedArchiver archiveRootObject:USERCONTEXT.gearsArray
                                        toFile:[theFile stringByAppendingPathComponent:@"Contents.obj"]] )
        {
            NSLog(@"File error");
            STOP_WAIT_VIEW;
            return;
        }

        // saving wallpaper
        if( ![NSKeyedArchiver archiveRootObject:@(USERCONTEXT.wallpaperIndex)
                                         toFile:[theFile stringByAppendingPathComponent:@"PaperSet.obj"]] )
        {
            NSLog(@"File error");
            STOP_WAIT_VIEW;
            return;
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
    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        [blueprintCtrl deleteAllGear];

        NSLog(@"%@",noti.object);
    
        NSData *fileData = [[NSFileManager defaultManager] contentsAtPath:[noti.object stringByAppendingPathComponent:@"Contents.obj"]];
        NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:fileData];
        [USERCONTEXT.gearsArray addObjectsFromArray:array];

        [blueprintCtrl putAllGearsToView];

        for( CSGearObject *g in USERCONTEXT.gearsArray )
            [g makeUpSelectorArray];

        fileData = [[NSFileManager defaultManager] contentsAtPath:[noti.object stringByAppendingPathComponent:@"PaperSet.obj"]];
        NSNumber *colorIndex = [NSKeyedUnarchiver unarchiveObjectWithData:fileData];
        USERCONTEXT.wallpaperIndex = [colorIndex integerValue];
        [self setBlueprintColor:(USERCONTEXT.wallpapers)[USERCONTEXT.wallpaperIndex]];

        // set Name
        NSString *chName = [[[noti.object componentsSeparatedByString:@"/"] lastObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        if( [chName isEqualToString:CACHE_NAME] )
            USERCONTEXT.appName = [[NSUserDefaults standardUserDefaults] objectForKey:@"CACHENAME"];
        else
            USERCONTEXT.appName = [chName substringToIndex:[chName length]-4];

        STOP_WAIT_VIEW;
    });
}

// set the background paper's color
-(void) setBlueprintColor:(UIColor*)color
{
    [blueprintCtrl.view setBackgroundColor:color];
}

// Remove the button guide view
-(void) removeGuide:(UITapGestureRecognizer*)recognizer
{
    [recognizer.view removeFromSuperview];
}

@end
