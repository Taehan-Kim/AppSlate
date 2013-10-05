//
//  WelcomeMovieModal.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 17..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "WelcomeMovieModal.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation WelcomeMovieModal

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Margin between edge of container frame and panel. Default = 20.0
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            // I am iPad
            self.outerMargin = 100.0f;
            self.cornerRadius = 10.0;
            // Margin between edge of panel and the content area. Default = 20.0
            self.innerMargin = 10.0f;
            [self setTitleBarHeight:40];
        }
        else {
            self.outerMargin = 8.0f;
            self.cornerRadius = 10.0;
            self.innerMargin = 3.0f;
            [self setTitleBarHeight:20];
            [self.headerLabel setFont:CS_FONT(13)];
        }

        self.headerLabel.text = NSLocalizedString(@"Welcome to AppSlate",@"");

        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [self embedYouTube:@"http://www.youtube.com/embed/TegeaJsCOvc" frame:CGRectMake(10, 90, 530, 380)];
        else
            [self embedYouTube:@"http://www.youtube.com/embed/TegeaJsCOvc" frame:CGRectMake(0, 10, 298, 194)];

        UIButton *tBtn;
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            tBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 490, 530, 25)];
        else
            tBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 210, 298, 25)];
        [tBtn setBackgroundColor:CS_RGBA(0, 10, 200, 0.4)];
        [tBtn setTitle:NSLocalizedString(@"Tutorial - Making 'Tip Calculator'",@"") forState:UIControlStateNormal];
        [tBtn.titleLabel setFont:CS_FONT(15)];
        [tBtn.titleLabel setTextColor:[UIColor blueColor]];
        [tBtn addTarget:self action:@selector(gotoTutorial1:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:tBtn];

        UITextView *txtView;
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            txtView = [[UITextView alloc] initWithFrame:CGRectMake(30, 530, 490, 120)];
        else
            txtView = [[UITextView alloc] initWithFrame:CGRectMake(0, 230, 298, 90)];
        [txtView setBackgroundColor:CSCLEAR];
        [txtView setFont:CS_FONT(14)];
        [txtView setTextColor:[UIColor lightGrayColor]];
        [txtView setEditable:NO];
        [txtView setText:@"facebook page : http://www.facebook.com/AppSlate\ntwitter : @chocolatesoft  @bladekim\nFind more examples on YouTube by keyword 'AppSlate'"];
        [self.contentView addSubview:txtView];

        UISwitch *killSwitch;
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            killSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, 700, 60, 30)];
        else
            killSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(10, 360, 60, 30)];
        [killSwitch setOnTintColor:[UIColor grayColor]];
        [killSwitch addTarget:self action:@selector(notWelcome:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:killSwitch];

        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            turnOffLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 700, 180, 30)];
        else
            turnOffLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 360, 200, 30)];
        [turnOffLabel setBackgroundColor:CSCLEAR];
        [turnOffLabel setTextColor:[UIColor grayColor]];
        [turnOffLabel setFont:CS_FONT(13)];
        [turnOffLabel setText:NSLocalizedString(@"Do not show this again",@"welcome modal")];
        [self.contentView addSubview:turnOffLabel];
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

-(void) gotoTutorial1:(UIButton*) sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://youtu.be/SQv_noix87I"]];
}

- (void)embedYouTube:(NSString *)urlString frame:(CGRect)frame
{
    NSString *embedHTML = @"<html><head>\
    <style type=\"text/css\">\
    body { background-color: transparent; color: white; }\
    </style>\
    </head><body style=\"margin:0\">\
    <iframe width=\"%0.0f\" height=\"%0.0f\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
    </body></html>";
    NSString *html = [NSString stringWithFormat:embedHTML, frame.size.width, frame.size.height, urlString ];
    UIWebView *videoView = [[UIWebView alloc] initWithFrame:frame];
    [videoView loadHTMLString:html baseURL:nil];
    [self.contentView addSubview:videoView];
}

- (void) notWelcome:(UISwitch*)sw
{
    [[NSUserDefaults standardUserDefaults] setBool:sw.isOn forKey:@"WELCOME_SWITCH"];

    if( sw.isOn )
        [turnOffLabel setTextColor:[UIColor lightGrayColor]];
    else {
        [turnOffLabel setTextColor:[UIColor grayColor]];
    }
}

@end
