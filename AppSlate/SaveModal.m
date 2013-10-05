//
//  SaveModal.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 13. 5. 20..
//  Copyright (c) 2013년 ChocolateSoft. All rights reserved.
//

#import "SaveModal.h"
#import "CSAppDelegate.h"
#import "BButton.h"

@implementation SaveModal

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Margin between edge of container frame and panel. Default = 20.0
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            // I am iPad
            self.outerMargin = 150.0f;
            self.cornerRadius = 10.0;
            // Margin between edge of panel and the content area. Default = 20.0
            self.innerMargin = 10.0f;
            [self setTitleBarHeight:40];
        }
        else {
            self.outerMargin = 20.0f;
            self.cornerRadius = 5.0;
            self.innerMargin = 3.0f;
            [self setTitleBarHeight:30];
            [self.headerLabel setFont:CS_FONT(13)];
        }

        self.headerLabel.text = NSLocalizedString(@"Save Your App To ...",@"save title");


        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            localBtn = [[UIButton alloc] initWithFrame:CGRectMake(44, 220, 150, 150)];
            parseBtn = [[UIButton alloc] initWithFrame:CGRectMake(256, 220, 150, 150)];
        } else {
            localBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 140, 100, 100)];
            parseBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 140, 100, 100)];
        }
        [localBtn setBackgroundImage:[UIImage imageNamed:@"sLocalBtn"] forState:UIControlStateNormal];
        [parseBtn setBackgroundImage:[UIImage imageNamed:@"sParseBtn"] forState:UIControlStateNormal];
        [localBtn addTarget:self action:@selector(toLocalSave:) forControlEvents:UIControlEventTouchUpInside];
        [parseBtn addTarget:self action:@selector(toParseSave:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:localBtn];
        [self.contentView addSubview:parseBtn];

    }

    if( nil == USERCONTEXT.appName )
        USERCONTEXT.appName = @"noname";

    _nField = [[UITextField alloc] init];
    [_nField setFont:[UIFont boldSystemFontOfSize:18.0]];
    [_nField setBackgroundColor:[UIColor lightGrayColor]];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _nField.leftView = paddingView;
    _nField.leftViewMode = UITextFieldViewModeAlways;
    [_nField setDelegate:self];
    [_nField setText:USERCONTEXT.appName];

    _dField = [[UITextField alloc] init];
    [_dField setFont:[UIFont boldSystemFontOfSize:18.0]];
    [_dField setBackgroundColor:[UIColor lightGrayColor]];
    UIView *padView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _dField.leftView = padView2;
    [_dField setDelegate:self];
    _dField.leftViewMode = UITextFieldViewModeAlways;

    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews {
	[super layoutSubviews];
}

#pragma mark -

- (void) toLocalSave:(UIButton*) sender
{
    [UIView animateWithDuration:0.7 animations:^{
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [localBtn setFrame:CGRectMake(44, 60, 150, 150)];
        else
            [localBtn setFrame:CGRectMake(85, 0, 100, 100)];
        [parseBtn setAlpha:0.0];
    } completion:^(BOOL finished) {
        UILabel *n1 = [[UILabel alloc] init];
        [n1 setBackgroundColor:[UIColor clearColor]];
        [n1 setText:NSLocalizedString(@"Name",@"")];
        [n1 setTextColor:[UIColor whiteColor]];
        [n1 setFont:[UIFont boldSystemFontOfSize:13.0]];
        BButton *nBtn = [[BButton alloc] init];
        [nBtn setTitle:NSLocalizedString(@"SAVE",@"btn")];
        [nBtn setBackgroundColor:[UIColor blueColor]];
        [nBtn addTarget:delegate action:@selector(saveAppFileToLocal)];

        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            [n1 setFrame:CGRectMake(44, 250, 300, 15)];
            [_nField setFrame:CGRectMake(44, 270, 360, 20)];
            [nBtn setFrame:CGRectMake(44, 300, 360, 30)];
        } else {
            [n1 setFrame:CGRectMake(20, 95, 200, 15)];
            [_nField setFrame:CGRectMake(20, 115, 230, 24)];
            [nBtn setFrame:CGRectMake(20, 145, 230, 35)];
        }
        [n1 setAlpha:0.0];
        [_nField setAlpha:0.0];
        [nBtn setAlpha:0.0];
        [self.contentView addSubview:n1];
        [self.contentView addSubview:_nField];
        [self.contentView addSubview:nBtn];

        [UIView animateWithDuration:0.4 animations:^{
            [n1 setAlpha:1.0];
            [_nField setAlpha:1.0];
            [nBtn setAlpha:1.0];
            [_nField becomeFirstResponder];
        }];
    }];
    
}

- (void) toParseSave:(UIButton*) sender
{
    [UIView animateWithDuration:0.7 animations:^{
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [parseBtn setFrame:CGRectMake(256, 60, 150, 150)];
        else
            [parseBtn setFrame:CGRectMake(85, 0, 100, 100)];
        [localBtn setAlpha:0.0];
    } completion:^(BOOL finished) {
        UILabel *n1 = [[UILabel alloc] init];
        [n1 setBackgroundColor:[UIColor clearColor]];
        [n1 setText:NSLocalizedString(@"Name",@"")];
        [n1 setTextColor:[UIColor whiteColor]];
        [n1 setFont:[UIFont boldSystemFontOfSize:13.0]];

        UILabel *n2 = [[UILabel alloc] init];
        [n2 setBackgroundColor:[UIColor clearColor]];
        [n2 setText:NSLocalizedString(@"Description",@"")];
        [n2 setTextColor:[UIColor whiteColor]];
        [n2 setFont:[UIFont boldSystemFontOfSize:13.0]];

        BButton *nBtn = [[BButton alloc] init];
        [nBtn setTitle:NSLocalizedString(@"SAVE",@"btn")];
        [nBtn setBackgroundColor:[UIColor blueColor]];
        [nBtn addTarget:delegate action:@selector(saveAppFileToParse)];
        
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            [n1 setFrame:CGRectMake(44, 250, 300, 15)];
            [_nField setFrame:CGRectMake(44, 270, 360, 20)];
            [n2 setFrame:CGRectMake(44, 300, 300, 15)];
            [_dField setFrame:CGRectMake(44, 320, 360, 20)];
            [nBtn setFrame:CGRectMake(44, 365, 360, 30)];
        } else {
            [n1 setFrame:CGRectMake(20, 95, 200, 15)];
            [_nField setFrame:CGRectMake(20, 115, 230, 24)];
            [n2 setFrame:CGRectMake(20, 145, 200, 15)];
            [_dField setFrame:CGRectMake(20, 165, 230, 24)];
            [nBtn setFrame:CGRectMake(20, 195, 230, 35)];
        }
        [n1 setAlpha:0.0];
        [n2 setAlpha:0.0];
        [_nField setAlpha:0.0];
        [_dField setAlpha:0.0];
        [nBtn setAlpha:0.0];
        [self.contentView addSubview:n1];
        [self.contentView addSubview:n2];
        [self.contentView addSubview:_nField];
        [self.contentView addSubview:_dField];
        [self.contentView addSubview:nBtn];

        [UIView animateWithDuration:0.4 animations:^{
            [n1 setAlpha:1.0];
            [n2 setAlpha:1.0];
            [_nField setAlpha:1.0];
            [_dField setAlpha:1.0];
            [nBtn setAlpha:1.0];
            [_nField becomeFirstResponder];
        }];
    }];
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    return YES;
}
@end
