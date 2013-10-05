//
//  NumberSettingViewController.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 01. 26..
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
    CGSize size = CGSizeMake(320, 106+60); // size of view in popover
    self.preferredContentSize = size;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    textField = [[UITextField alloc] initWithFrame:CGRectMake(C_GAP*2, 4+C_GAP*2, C_WIDTH-(C_GAP*2), 33.0)];
    [textField setFont:[UIFont systemFontOfSize:20.0]];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField.layer setCornerRadius:5.0];
    [textField setClipsToBounds:YES];
    [textField setDelegate:self];
    if( UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM() )
        [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    else {
        [textField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [textField setFrame:CGRectOffset(textField.frame, 0, 60)];
    }
    NSNumber *sNum = objc_msgSend(theGear,[pInfoDic[@"getSelector"] pointerValue]);
    NSNumberFormatter *numF = [[NSNumberFormatter alloc] init];
    [numF setMaximumIntegerDigits:10];
    [numF setMaximumFractionDigits:7];
//    [numF setMaximumSignificantDigits:0];
    [textField setText: [numF stringFromNumber:sNum] ];
    [self.view addSubview:textField];
//    NSLog(@"%@", textField);

    saveBtn = [[BButton alloc] initWithFrame:CGRectMake(C_GAP, 4+38.0+(C_GAP*3), C_WIDTH, 40)];
    [saveBtn setTitle:NSLocalizedString(@"APPLY",@"APPLY")];
    [saveBtn addTarget:self action:@selector(setTheValue:)];
    if( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() )
        [saveBtn setFrame:CGRectOffset(saveBtn.frame, 0, 60)];
    [self.view addSubview:saveBtn];

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
    NSNumberFormatter *numF = [[NSNumberFormatter alloc] init];
    [numF setMaximumIntegerDigits:10];
//    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [numF numberFromString:textField.text];

    [self saveValue: myNumber ];

    if( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() )
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TextField Delegate

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if( [string isEqualToString:@"."] ) return YES;

    NSMutableCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];
    BOOL isValid = [alphaNums isSupersetOfSet:stringSet];
    return isValid;
}

@end

