//
//  StringSettingViewController.m
//  AppSlate
//
//  Created by 태한 김 on 11. 12. 20..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "StringSettingViewController.h"
#import <objc/message.h>

//@interface StringSettingViewController ()
//
//@end

@implementation StringSettingViewController


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
    self.title = NSLocalizedString(@"String Setting",@"String Setting");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark -

- (void)viewWillAppear:(BOOL)animated
{
    CGSize size = CGSizeMake(320, 156); // size of view in popover
    self.contentSizeForViewInPopover = size;
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

    textField = [[UITextView alloc] initWithFrame:CGRectMake(C_GAP, C_GAP, C_WIDTH, 85.0)];
    [textField setFont:[UIFont systemFontOfSize:15.0]];
    [textField.layer setCornerRadius:5.0];
    [textField setClipsToBounds:YES];
//    [textField setText:[[theGear object] text]];
    NSString *sText = objc_msgSend(theGear,[pInfoDic[@"getSelector"] pointerValue]);
    [textField setText:sText];
    [self.view addSubview:textField];
    NSLog(@"%@", textField);

    saveBtn = [[BButton alloc] initWithFrame:CGRectMake(C_GAP, 85.0+(C_GAP*3), C_WIDTH, 40)];
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

    [textField becomeFirstResponder];
}

#pragma mark - Setting Button Action

-(void) setTheValue:(id)sender
{
    [self saveValue:textField.text];
}

@end
