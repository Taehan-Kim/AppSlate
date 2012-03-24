//
//  InfoModal.m
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 17..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "InfoModal.h"
#import "CSAppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <Twitter/TWTweetComposeViewController.h>

@implementation InfoModal

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Margin between edge of container frame and panel. Default = 20.0
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            // I am iPad
            self.outerMargin = 150.0f;
            self.cornerRadius = 20.0;
        }
        else {
            // I am iPhone
        }
        // Margin between edge of panel and the content area. Default = 20.0
        self.innerMargin = 10.0f;

        [self setTitleBarHeight:40];
        self.headerLabel.text = @"About AppSlate";

        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(40, 90, 72, 72)];
        [icon setImage:[UIImage imageNamed:@"Icon~ipad.png"]];
        [icon setClipsToBounds:YES];
        [icon.layer setCornerRadius:9.0];
        [self.contentView addSubview:icon];

        //
        UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 100, 200, 20)];
        [versionLabel setBackgroundColor:CSCLEAR];
        [versionLabel setFont:CS_BOLD_FONT(16)];
        [versionLabel setTextColor:[UIColor lightGrayColor]];
        [versionLabel setText:[NSString stringWithFormat:@"AppSlate version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]];

        UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 130, 300, 20)];
        [itemLabel setBackgroundColor:CSCLEAR];
        [itemLabel setFont:CS_FONT(15)];
        [itemLabel setTextColor:[UIColor lightGrayColor]];
        [itemLabel setText:[NSString stringWithFormat:@"2012 Chocolate Soft"]];

        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 195, 300, 20)];
        [infoLabel setBackgroundColor:CSCLEAR];
        [infoLabel setFont:CS_FONT(15)];
        [infoLabel setTextColor:[UIColor lightGrayColor]];
        [infoLabel setText:[NSString stringWithFormat:@"Please visit our facebook page;"]];

        UIButton *urlBtn = [[UIButton alloc] initWithFrame:CGRectMake(145, 212, 300, 30)];
        [urlBtn setBackgroundColor:CSCLEAR];
        [urlBtn setTitle:@"http://www.facebook.com/AppSlate" forState:UIControlStateNormal];
        [urlBtn.titleLabel setFont:CS_FONT(15)];
        [urlBtn.titleLabel setTextColor:[UIColor blueColor]];
        [urlBtn addTarget:self action:@selector(gotoWeb:) forControlEvents:UIControlEventTouchUpInside];

        UILabel *twLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 195+55, 300, 20)];
        [twLabel setBackgroundColor:CSCLEAR];
        [twLabel setFont:CS_FONT(15)];
        [twLabel setTextColor:[UIColor lightGrayColor]];
        [twLabel setText:[NSString stringWithFormat:@"Send tweet to;"]];
        
        UIButton *twBtn = [[UIButton alloc] initWithFrame:CGRectMake(145, 212+55, 300, 30)];
        [twBtn setBackgroundColor:CSCLEAR];
        [twBtn setTitle:@"@chocolatesoft" forState:UIControlStateNormal];
        [twBtn.titleLabel setFont:CS_FONT(15)];
        [twBtn.titleLabel setTextColor:[UIColor blueColor]];
        [twBtn addTarget:self action:@selector(gotoTweet:) forControlEvents:UIControlEventTouchUpInside];

        UILabel *eLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 195+110, 300, 20)];
        [eLabel setBackgroundColor:CSCLEAR];
        [eLabel setFont:CS_FONT(15)];
        [eLabel setTextColor:[UIColor lightGrayColor]];
        [eLabel setText:[NSString stringWithFormat:@"Send e-mail to;"]];

        UIButton *eBtn = [[UIButton alloc] initWithFrame:CGRectMake(145, 212+110, 300, 30)];
        [eBtn setBackgroundColor:CSCLEAR];
        [eBtn setTitle:@"blade.kim@gmail.com" forState:UIControlStateNormal];
        [eBtn.titleLabel setFont:CS_FONT(15)];
        [eBtn.titleLabel setTextColor:[UIColor blueColor]];
        [eBtn addTarget:self action:@selector(gotoEmail:) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:versionLabel];
        [self.contentView addSubview:itemLabel];
        [self.contentView addSubview:infoLabel];
        [self.contentView addSubview:urlBtn];
        [self.contentView addSubview:twLabel];
        [self.contentView addSubview:twBtn];
        [self.contentView addSubview:eLabel];
        [self.contentView addSubview:eBtn];

        UIButton *tBtn = [[UIButton alloc] initWithFrame:CGRectMake(145, 260+110, 300, 30)];
        [tBtn setBackgroundColor:CS_RGBA(0, 10, 200, 0.4)];
        [tBtn setTitle:@"Tutorial - Making 'Tip Calculator'" forState:UIControlStateNormal];
        [tBtn.titleLabel setFont:CS_FONT(15)];
        [tBtn.titleLabel setTextColor:[UIColor blueColor]];
        [tBtn addTarget:self action:@selector(gotoTutorial1:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:tBtn];

        UIButton *t2Btn = [[UIButton alloc] initWithFrame:CGRectMake(145, 260+160, 300, 30)];
        [t2Btn setBackgroundColor:CS_RGBA(0, 10, 200, 0.4)];
        [t2Btn setTitle:@"Tutorial - Making 'Twitter Check App'" forState:UIControlStateNormal];
        [t2Btn.titleLabel setFont:CS_FONT(15)];
        [t2Btn.titleLabel setTextColor:[UIColor blueColor]];
        [t2Btn addTarget:self action:@selector(gotoTutorial2:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:t2Btn];

    }

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

-(void) gotoWeb:(UIButton*) sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sender.titleLabel.text]];
}

-(void) gotoTweet:(UIButton*) sender
{
    TWTweetComposeViewController *twtCntrlr = [[TWTweetComposeViewController alloc] init];
    [twtCntrlr addURL:[NSURL URLWithString:@"http://www.facebook.com/AppSlate"]];
    [twtCntrlr setInitialText:@"@chocolatesoft "];
    [((CSAppDelegate*)([UIApplication sharedApplication].delegate)).window.rootViewController presentModalViewController:twtCntrlr animated:YES];
}

-(void) gotoEmail:(UIButton*) sender
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setToRecipients:[NSArray arrayWithObject:@"blade.kim@gmail.com"]];
    [picker setSubject:@"[AppSlate] from customer"];
    [picker setMessageBody:[NSString stringWithFormat:@"\n\n\nAppSlate ver%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] isHTML:NO];

    [((CSAppDelegate*)([UIApplication sharedApplication].delegate)).window.rootViewController presentModalViewController:picker animated:YES];
    [picker becomeFirstResponder];
}

-(void) gotoTutorial1:(UIButton*) sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://youtu.be/SQv_noix87I"]];
}

-(void) gotoTutorial2:(UIButton*) sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://youtu.be/NF3koS9KyEI"]];
}

#pragma mark - MFMailCompose delegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
    NSString *message;
    
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message = NSLocalizedString(@"Your E-mail has canceled.",@"mail cancel");// @"메일 전송이 취소되었습니다.";
			break;
		case MFMailComposeResultSaved:
			message = NSLocalizedString(@"Your E-mail has saved.",@"mal save");// @"메일이 저장되었습니다.";
			break;
		case MFMailComposeResultSent:
			message = NSLocalizedString(@"Your E-mail has sent",@"mail sent"); //@"메일이 전송되었습니다.";
			break;
		case MFMailComposeResultFailed:
			message = NSLocalizedString(@"Fail to send the mail.",@"mail fail"); //@"메일 전송이 실패하였습니다.";
			break;
		default:
			message = NSLocalizedString(@"I Can not send the mail now.",@"mail cant"); //@"메일 전송이 되지 않습니다.";
			break;
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-Mail to Developer"
													message:message
												   delegate:nil cancelButtonTitle:@"Confirm"
										  otherButtonTitles: nil];
	[alert show];	
	
	[controller dismissModalViewControllerAnimated:YES];
}

@end
