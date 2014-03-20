//
//  CodingViewController.m
//  AppSlate
//
//  Created by Taehan Kim on 2014. 1. 7..
//  Copyright (c) 2014년 ChocolateSoft. All rights reserved.
//

#import "CodingViewController.h"
#import "CSMakeCode.h"
#import "UIBAlertView.h"
#import <StoreKit/StoreKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface CodingViewController () <SKStoreProductViewControllerDelegate,MFMailComposeViewControllerDelegate>
{
    NSString *contName;
    UITextView *codeView;
    SKStoreProductViewController *Sv;
}
@end

@implementation CodingViewController

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

    [self.view setBackgroundColor:[UIColor whiteColor]];

    codeView = [[UITextView alloc] initWithFrame:self.view.bounds textContainer:nil];
    [codeView setFont:CS_FONT(10)];
    [codeView setEditable:NO];
    [codeView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    [self.view addSubview:codeView];

    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closePressed:)];
    UIBarButtonItem *sharBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareCode)];
    [toolBar setItems:@[closeBtn,[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],sharBtn]];
    [self.view addSubview:toolBar];
}

- (void) viewDidAppear:(BOOL)animated
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Set Name",@"") message:NSLocalizedString(@"View Controller's name",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel") otherButtonTitles:NSLocalizedString(@"OK",@"OK"), nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( 0 == buttonIndex || nil == [alertView textFieldAtIndex:0].text
       || [alertView textFieldAtIndex:0].text.length <= 1 ) return;

    contName = [alertView textFieldAtIndex:0].text;

    CSMakeCode *mk = [[CSMakeCode alloc] initWithControllerName:contName];
    codeView.text = [mk generate];
}

-(void) closePressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) shareCode
{
#ifdef LITE_VERSION
    UIBAlertView *av = [[UIBAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"You can send the source code to email on AppSlate Full-version!",@"Liteversion") cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Buy It",@""),NSLocalizedString(@"Copy to Clipboard",@""), nil];
    [av showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
        if( didCancel ) return;
        if( 1 == selectedIndex ) {
            Sv = [[SKStoreProductViewController alloc] init];
            [Sv setDelegate:self];
            START_WAIT_VIEW;
            [Sv loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@"511327336"}
                          completionBlock:^(BOOL result, NSError *error)
             {
                 STOP_WAIT_VIEW;
                 [self presentViewController:Sv animated:YES
                                  completion:^{
                                  }];
             }];
        } else if( 2 == selectedIndex ) {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:codeView.text];

            UIBAlertView *doneAlert = [[UIBAlertView alloc] initWithTitle:NSLocalizedString(@"Done",@"Done") message:nil cancelButtonTitle:NSLocalizedString(@"Confirm", @"Confirm") otherButtonTitles: nil];
            [doneAlert showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
            }];
        }
    }];
#else
    UIBAlertView *av = [[UIBAlertView alloc] initWithTitle:nil message:@"" cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel") otherButtonTitles:NSLocalizedString(@"Send to E-mail",@""),NSLocalizedString(@"Copy to Clipboard",@""), nil];
    [av showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
        if( didCancel ) return;
        if( 1 == selectedIndex )
        {
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            [picker setSubject:@"[AppSlate] My Objective-c code"];
            [picker setMessageBody:codeView.text isHTML:NO];
            
            [self presentViewController:picker animated:YES completion:NULL];
            [picker becomeFirstResponder];
        }
        else if( 2 == selectedIndex )
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:codeView.text];
            
            UIBAlertView *doneAlert = [[UIBAlertView alloc] initWithTitle:NSLocalizedString(@"Done",@"Done") message:nil cancelButtonTitle:NSLocalizedString(@"Confirm", @"Confirm") otherButtonTitles: nil];
            [doneAlert showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
            }];
        }
    }];
#endif
}

#pragma mark - SKStoreProductViewControllerDelegate

// SK store view 를 닫는 요구가 들어오면
-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:^{
    } ];
}

#pragma mark - MFMailCompose delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *message;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message = NSLocalizedString(@"Your E-mail has canceled.",@"mail cancel");
			break;
		case MFMailComposeResultSaved:
			message = NSLocalizedString(@"Your E-mail has saved.",@"mal save");
			break;
		case MFMailComposeResultSent:
			message = NSLocalizedString(@"Your E-mail has sent",@"mail sent");
			break;
		case MFMailComposeResultFailed:
			message = NSLocalizedString(@"Fail to send the mail.",@"mail fail");
			break;
		default:
			message = NSLocalizedString(@"I Can not send the mail now.",@"mail cant");
			break;
	}
    UIBAlertView *av = [[UIBAlertView alloc] initWithTitle:nil message:message cancelButtonTitle:NSLocalizedString(@"Confirm", @"Confirm") otherButtonTitles:nil];
    [av showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
    }];

	[controller dismissViewControllerAnimated:YES completion:NULL];
}

@end
