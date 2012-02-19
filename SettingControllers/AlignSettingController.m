//
//  AlignSettingController.m
//  AppSlate
//
//  Created by 김 태한 on 11. 12. 30..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "AlignSettingController.h"

@interface AlignSettingController ()

@end

@implementation AlignSettingController

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
    CGSize size = CGSizeMake(320, 109); // size of view in popover
    self.contentSizeForViewInPopover = size;
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

    alignSegment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:NSLocalizedString(@"Left",@"L"), NSLocalizedString(@"Center",@"C"), NSLocalizedString(@"Right",@"R"), nil]];
    [alignSegment setFrame:CGRectMake(C_GAP, C_GAP, C_WIDTH, 40.0)];
    [alignSegment setSegmentedControlStyle:UISegmentedControlStylePlain];
    NSNumber *alignNum = objc_msgSend(theGear,[[pInfoDic objectForKey:@"getSelector"] pointerValue]);
    [alignSegment setSelectedSegmentIndex:[alignNum integerValue]];
    [self.view addSubview:alignSegment];

    saveBtn = [[BButton alloc] initWithFrame:CGRectMake(C_GAP, 45.0+(C_GAP*2), C_WIDTH, 40)];
    [saveBtn setTitle:NSLocalizedString(@"APPLY",@"APPLY")];
    [saveBtn addTarget:self action:@selector(setTheValue:)];
//    [saveBtn setEnabled:YES];
    [self.view addSubview:saveBtn];
    
    [super viewWillAppear:animated];
}

// UIPopover Controller 의 크기를 조정해주기 위해서 사용하는 팁 같은 코드.
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
    // 정렬 설정 값을 NSNumber 객체로 감싸서 전달함.
    [self saveValue:[NSNumber numberWithInteger:alignSegment.selectedSegmentIndex]];
}

@end
