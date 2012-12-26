//
//  BoolSettingController.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 11. 12. 30..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "BoolSettingController.h"
#import <objc/message.h>

@interface BoolSettingController ()

@end

@implementation BoolSettingController

-(id)initWithGear:(id)gear propertyInfo:(NSDictionary*)infoDic
{
    if( self = [super init] ){
        ;
    }
    theGear = gear;
    pInfoDic = infoDic;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"ON/OFF Setting",@"ON/OFF Setting");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return( (interfaceOrientation == UIInterfaceOrientationPortrait) ||
           (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) );
}

#pragma mark -

- (void)viewWillAppear:(BOOL)animated
{
    CGSize size = CGSizeMake(320, 106); // size of view in popover
    self.contentSizeForViewInPopover = size;
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

    switchBtn = [[UISwitch alloc] initWithFrame:CGRectMake(320 - C_GAP - 90, C_GAP+6, 60, 40.0)];
    NSNumber *alignNum = objc_msgSend(theGear,[pInfoDic[@"getSelector"] pointerValue]);
    [switchBtn setOn:[alignNum boolValue]];
    [self.view addSubview:switchBtn];

    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(C_GAP, C_GAP, C_WIDTH - 90, 40.0)];
    [nameLabel setText:pInfoDic[@"name"]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:CS_FONT(15)];
//    [nameLabel setMinimumFontSize:12.0];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setShadowColor:[UIColor blackColor]];
    [nameLabel setShadowOffset:CGSizeMake(1, 1)];
    [self.view addSubview:nameLabel];

    saveBtn = [[BButton alloc] initWithFrame:CGRectMake(C_GAP, 45.0+(C_GAP*2), C_WIDTH, 40)];
    [saveBtn setTitle:NSLocalizedString(@"APPLY",@"APPLY")];
    [saveBtn addTarget:self action:@selector(setTheValue:)];
//    [saveBtn setEnabled:YES];
    [self.view addSubview:saveBtn];
    
    [super viewWillAppear:animated];
}

// the size of UIPopover Controller
-(void) viewDidAppear:(BOOL)animated
{
    CGSize currentSetSizeForPopover = self.contentSizeForViewInPopover;
    CGSize fakeMomentarySize = CGSizeMake(currentSetSizeForPopover.width - 1.0f, currentSetSizeForPopover.height - 1.0f);
    self.contentSizeForViewInPopover = fakeMomentarySize;
    self.contentSizeForViewInPopover = currentSetSizeForPopover;
}

#pragma mark - Setting Button Action

-(void) setTheValue:(id)sender
{
    // Wrap up the Arrange setting value with NSNumber
    [self saveValue:@(switchBtn.on)];

    if( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() )
        [self.navigationController popViewControllerAnimated:YES];
}

@end
