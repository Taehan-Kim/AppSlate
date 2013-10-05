//
//  MyLoginViewController.m
//  AppSlate
//
//  Created by 김태한 on 13. 5. 11..
//  Copyright (c) 2013년 ChocolateSoft. All rights reserved.
//

#import "MyLoginViewController.h"
#import "MySignUpViewController.h"

@interface MyLoginViewController () <PFSignUpViewControllerDelegate>

@end

@implementation MyLoginViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
//        [PFTwitterUtils initializeWithConsumerKey:@"kZHn0u1bu5hJYX2WEF5Dlw"
//                                   consumerSecret:@"bAUI0EXfDuLbymYdAyxXhEBrg08r24PMRO6c9r3g"];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [label setFont:[UIFont boldSystemFontOfSize:43]];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    label.text = NSLocalizedString(@"Share World",@"s_title");
    [label sizeToFit];
    self.logInView.logo = label; // logo can be any UIView

    self.signUpController = [[MySignUpViewController alloc] init];
    [self.signUpController setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController
           shouldBeginSignUp:(NSDictionary *)info
{
    NSString *password = [info objectForKey:@"password"];
    return (BOOL)(password.length >= 8); // prevent sign up if password has to be at least 8 characters long
};

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    [self dismissViewControllerAnimated:YES completion:nil];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Up Error" message:@"There are some error..." delegate:nil cancelButtonTitle:@"Confirm" otherButtonTitles: nil];
    [alert show];
}

@end
