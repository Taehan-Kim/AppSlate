//
//  MySignUpViewController.m
//  AppSlate
//
//  Created by 김태한 on 13. 5. 13..
//  Copyright (c) 2013년 ChocolateSoft. All rights reserved.
//

#import "MySignUpViewController.h"

@interface MySignUpViewController ()

@end

@implementation MySignUpViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [label setFont:[UIFont boldSystemFontOfSize:43]];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    label.text = NSLocalizedString(@"Share World",@"s_title");
    [label sizeToFit];
    self.signUpView.logo = label; // logo can be any UIView

    [self setFields:PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsSignUpButton | PFSignUpFieldsEmail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
