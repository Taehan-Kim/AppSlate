//
//  AlignSettingController.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 11. 12. 30..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "AlignSettingController.h"
#import <objc/message.h>

@interface AlignSettingController ()

@end

@implementation AlignSettingController

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
    self.title = NSLocalizedString(@"Alignment Setting",@"Alignment Setting");
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
    CGSize size = CGSizeMake(320, 109 + 60); // size of view in popover
    self.preferredContentSize = size;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    alignSegment = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"Left",@"L"), NSLocalizedString(@"Center",@"C"), NSLocalizedString(@"Right",@"R")]];
    [alignSegment setFrame:CGRectMake(C_GAP, 4 + C_GAP, C_WIDTH, 40.0)];
//    [alignSegment setSegmentedControlStyle:UISegmentedControlStyle];
    NSNumber *alignNum = objc_msgSend(theGear,[pInfoDic[@"getSelector"] pointerValue]);
    [alignSegment setSelectedSegmentIndex:[alignNum integerValue]];
    [self.view addSubview:alignSegment];

    saveBtn = [[BButton alloc] initWithFrame:CGRectMake(C_GAP, 4 + 45.0+(C_GAP*2), C_WIDTH, 40)];
    [saveBtn setTitle:NSLocalizedString(@"APPLY",@"APPLY")];
    [saveBtn addTarget:self action:@selector(setTheValue:)];
//    [saveBtn setEnabled:YES];
    [self.view addSubview:saveBtn];

    if( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() )
    {
        [alignSegment setFrame:CGRectOffset(alignSegment.frame, 0, 60)];
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
    // wrap up the arrange setting value with NSNumber object.
    [self saveValue:@(alignSegment.selectedSegmentIndex)];

    if( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() )
        [self.navigationController popViewControllerAnimated:YES];
}

@end
