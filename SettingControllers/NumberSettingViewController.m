//
//  NumberSettingViewController.m
//  AppSlate
//
//  Created by 태한 김 on 12. 01. 26..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "NumberSettingViewController.h"
#import <objc/message.h>


@implementation NumberSettingViewController


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
    self.title = NSLocalizedString(@"Number Setting",@"Number Setting");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark -

- (void)viewWillAppear:(BOOL)animated
{
    CGSize size = CGSizeMake(320, 106); // size of view in popover
    self.contentSizeForViewInPopover = size;
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

    textField = [[UITextField alloc] initWithFrame:CGRectMake(C_GAP*2, C_GAP*2, C_WIDTH-(C_GAP*2), 33.0)];
    [textField setFont:[UIFont systemFontOfSize:20.0]];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField.layer setCornerRadius:5.0];
    [textField setClipsToBounds:YES];
    [textField setDelegate:self];
    [textField setKeyboardType:UIKeyboardTypeNumberPad];
    NSNumber *sNum = objc_msgSend(theGear,[[pInfoDic objectForKey:@"getSelector"] pointerValue]);
    [textField setText: sNum.stringValue];
    [self.view addSubview:textField];
//    NSLog(@"%@", textField);

    saveBtn = [[BButton alloc] initWithFrame:CGRectMake(C_GAP, 38.0+(C_GAP*3), C_WIDTH, 40)];
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
    [self saveValue:[NSNumber numberWithFloat: [textField.text floatValue]]];
}

#pragma mark - TextField Delegate

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    [alphaNums addCharactersInString:@"."];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];
    BOOL isValid = [alphaNums isSupersetOfSet:stringSet];
    return isValid;
}

@end

