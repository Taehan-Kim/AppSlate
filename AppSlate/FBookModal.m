//
//  FBookModal.m
//  AppSlate
//
//  Created by 김태한 on 12. 2. 4..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "FBookModal.h"
#import "CSMainViewController.h"

#define SLINE_H 70
#define LEFT_L  115

@implementation FBookModal

- (id)initWithFrame:(CGRect)frame message:(NSString *)message
{
	if ((self = [super initWithFrame:frame]))
    {
		self.headerLabel.text = @"Facebook";

        // Margin between edge of container frame and panel. Default = 20.0
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            // I am iPad
            self.outerMargin = 200.0f;
            self.cornerRadius = 10.0;
        }
        else {
            // I am iPhone
        }
        // Margin between edge of panel and the content area. Default = 20.0
        self.innerMargin = 10.0f;
        [self setTitleBarHeight:30];
        [self headerLabel].font = [UIFont boldSystemFontOfSize:floor(self.titleBarHeight / 2.0)];

        msgTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 45+SLINE_H, 260, 60)];
        [msgTextView setFont:CS_FONT(15)];
        [msgTextView setDelegate:self];

        sendBtn = [[BButton alloc] initWithFrame:CGRectMake(20, 45+(SLINE_H*4), 70, 30)];
        [sendBtn setTitle:@"Send"];
        [sendBtn addTarget:self action:@selector(sendToFacebook:)];
        [sendBtn.btn.titleLabel setFont:CS_FONT(13) ];

        [self.contentView addSubview:msgTextView];
        [self.contentView addSubview:sendBtn];
	}

    [msgTextView setText:message];
    [msgTextView becomeFirstResponder];

	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
//	[tbv setFrame:self.contentView.bounds];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

#pragma mark -

-(void) sendToFacebook:(id)sender
{
    NSMutableDictionary* params = 
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
        msgTextView.text,  @"message",
        @"from AppSlate", @"notification_text", nil];  
    [USERCONTEXT.facebook dialog:@"apprequests"
                       andParams:params
                     andDelegate:self];
}

-(void) textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    [self sendToFacebook:nil];
}

@end
