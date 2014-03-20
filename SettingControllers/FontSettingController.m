//
//  FontSettingController.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 11. 12. 29..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "FontSettingController.h"

@interface FontSettingController ()

@end

@implementation FontSettingController

- (id)initWithGear:(id)gear propertyInfo:(NSDictionary*)infoDic
{
    self = [super init];

    theGear = gear;
    pInfoDic = infoDic;

    if (self) {
        // Custom initialization
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 269 + 60)];
        SEL selector = [pInfoDic[@"getSelector"] pointerValue];
        UIFont *fnt = [theGear performSelector:selector];
        cmtController = [CMTextStylePickerViewController textStylePickerViewController];
        [cmtController fontSelectTableViewController:nil didSelectFont:fnt];
        [self addChildViewController:cmtController];
    }
    return self;
}

- (void)loadView
{
    // Implement loadView to create a view hierarchy programmatically, without using a nib.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [cmtController viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated
{
    CGSize size = CGSizeMake(320, 269 + 60); // size of view in popover
    self.preferredContentSize = size;

    [cmtController.view setFrame:self.view.bounds];
    [cmtController viewWillAppear:animated];
    [self.view addSubview:cmtController.view];

    saveBtn = [[BButton alloc] initWithFrame:CGRectMake(C_GAP, 4+150.0+(C_GAP*1), C_WIDTH, 40)];
    [saveBtn setTitle:NSLocalizedString(@"APPLY",@"APPLY")];
    [saveBtn addTarget:self action:@selector(setTheValue:)];
//    [saveBtn setEnabled:YES];
    [cmtController.view addSubview:saveBtn];

    if( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() )
    {
        [saveBtn setFrame:CGRectOffset(saveBtn.frame, 0, 60)];
    }
    [super viewWillAppear:animated];
}

// for UIPopover Controller
-(void) viewDidAppear:(BOOL)animated
{
    if( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() )
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHANGE_POPOVER object:nil];
}

#pragma mark - Setting Button Action

-(void) setTheValue:(id)sender
{
    [self saveValue:cmtController.selectedFont];

    if( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() )
        [self.navigationController popViewControllerAnimated:YES];
}

@end
