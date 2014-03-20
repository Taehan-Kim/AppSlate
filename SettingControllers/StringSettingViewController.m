//
//  StringSettingViewController.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 11. 12. 20..
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
        theGear = gear;
        pInfoDic = infoDic;
    }

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
    CGSize size = CGSizeMake(self.view.superview.frame.size.width, 156 + 60); // size of view in popover
    self.preferredContentSize = size;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    textField = [[UITextView alloc] initWithFrame:CGRectMake(C_GAP, 4 + C_GAP*2, C_WIDTH, 85.0)];
    [textField setFont:[UIFont systemFontOfSize:[UIFont systemFontSize]]];

    NSString *sText = objc_msgSend(theGear,[pInfoDic[@"getSelector"] pointerValue]);
    [textField setText:sText];
    [self.view addSubview:textField];
    NSLog(@"%@", textField);

    saveBtn = [[BButton alloc] initWithFrame:CGRectMake(C_GAP, 4 + 85.0+(C_GAP*4), C_WIDTH, 40)];
    [saveBtn setTitle:NSLocalizedString(@"APPLY",@"APPLY")];
    [saveBtn addTarget:self action:@selector(setTheValue:)];
    [self.view addSubview:saveBtn];

    if( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() )
    {
        [textField setFrame:CGRectOffset(textField.frame, 0, 60)];
        [saveBtn setFrame:CGRectOffset(saveBtn.frame, 0, 60)];
    }

    [super viewWillAppear:animated];
}

// for UIPopover Controller
-(void) viewDidAppear:(BOOL)animated
{
    if( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() )
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CHANGE_POPOVER object:nil];

    [textField becomeFirstResponder];
}

#pragma mark - Setting Button Action

-(void) setTheValue:(id)sender
{
    [self saveValue:textField.text];

    if( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() )
        [self.navigationController popViewControllerAnimated:YES];
}

@end
