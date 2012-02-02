//
//  CellSettingController.m
//  AppSlate
//
//  Created by 태한 김 on 12. 1. 27..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CellSettingController.h"

@implementation CellSettingController

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
    self.title = NSLocalizedString(@"Cell Setting",@"Cell Setting");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark -

- (void)viewWillAppear:(BOOL)animated
{
    CGSize size = CGSizeMake(320, 270); // size of view in popover
    self.contentSizeForViewInPopover = size;
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(C_GAP, C_GAP*2, 50, 33)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:CS_FONT(16)];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:@"Index :"];
    [self.view addSubview:label];

    indexField = [[UITextField alloc] initWithFrame:CGRectMake(50+(C_GAP*2), C_GAP*2, 80, 33.0)];
    [indexField setFont:[UIFont systemFontOfSize:20.0]];
    [indexField setBackgroundColor:[UIColor whiteColor]];
    [indexField.layer setCornerRadius:5.0];
    [indexField setKeyboardType:UIKeyboardTypeNumberPad];
    [indexField setDelegate:self];
    [indexField setText:@"0"];
    [self.view addSubview:indexField];

    getBtn = [[BButton alloc] initWithFrame:CGRectMake(220, C_GAP*2, 80, 33.0)];
    [getBtn setTitle:NSLocalizedString(@"GET",@"GET")];
    [getBtn addTarget:self action:@selector(getCellValue:)];
    [getBtn setEnabled:YES];
    [self.view addSubview:getBtn];

    NSDictionary *sDic = objc_msgSend(theGear,[[pInfoDic objectForKey:@"getSelector"] pointerValue],0);

    textField = [[UITextView alloc] initWithFrame:CGRectMake(C_GAP, 38.0+(C_GAP*3), C_WIDTH, 55.0)];
    [textField setFont:[UIFont systemFontOfSize:15.0]];
    [textField.layer setCornerRadius:5.0];
    [textField setClipsToBounds:YES];
    [textField setText:[sDic objectForKey:@"Text"]];
    [self.view addSubview:textField];

    subTextField = [[UITextView alloc] initWithFrame:CGRectMake(C_GAP, 88.0+(C_GAP*6), C_WIDTH, 55.0)];
    [subTextField setFont:[UIFont systemFontOfSize:15.0]];
    [subTextField.layer setCornerRadius:5.0];
    [subTextField setClipsToBounds:YES];
    [subTextField setText:[sDic objectForKey:@"Sub"]];
    [self.view addSubview:subTextField];

    saveBtn = [[BButton alloc] initWithFrame:CGRectMake(C_GAP, 143.0+(C_GAP*10), C_WIDTH, 40)];
    [saveBtn setTitle:NSLocalizedString(@"APPLY",@"APPLY")];
    [saveBtn addTarget:self action:@selector(setTheValue:)];
    [saveBtn setEnabled:YES];
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

-(void) getCellValue:(id)sender
{
    NSUInteger idx = [indexField.text integerValue];
    NSDictionary *sDic = objc_msgSend(theGear,[[pInfoDic objectForKey:@"getSelector"] pointerValue],idx);

    if( nil == sDic ) return; // 잘못된 인덱스 값.

    [textField setText:[sDic objectForKey:@"Text"]];
    [subTextField setText:[sDic objectForKey:@"Sub"]];
}

-(void) setTheValue:(id)sender
{
    SEL selector = [[pInfoDic objectForKey:@"selector"] pointerValue];

    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:textField.text,@"Text",subTextField.text,@"Sub", nil];
    objc_msgSend(theGear, selector, dic, [indexField.text integerValue] );
}

#pragma mark - TextField Delegate

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];
    BOOL isValid = [alphaNums isSupersetOfSet:stringSet];
    return isValid;
}

@end
