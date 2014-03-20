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
        theGear = gear;
        pInfoDic = infoDic;
    }
    
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
    CGSize size = CGSizeMake(320, 106 + 60); // size of view in popover
    self.preferredContentSize = size;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

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

    if( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() )
    {
        [nameLabel setFrame:CGRectOffset(nameLabel.frame, 0, 60)];
        [switchBtn setFrame:CGRectOffset(switchBtn.frame, 0, 60)];
    }

    saveBtn = [[BButton alloc] initWithFrame:CGRectMake(C_GAP, switchBtn.frame.origin.y+C_GAP+40.0, C_WIDTH, 40)];
    [saveBtn setTitle:NSLocalizedString(@"APPLY",@"APPLY")];
    [saveBtn addTarget:self action:@selector(setTheValue:)];
//    [saveBtn setEnabled:YES];
    [self.view addSubview:saveBtn];
    
    [super viewWillAppear:animated];
}

// the size of UIPopover Controller
-(void) viewDidAppear:(BOOL)animated
{
    if( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() )
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHANGE_POPOVER object:nil];
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
