//
//  AppSettingModal.m
//  AppSlate
//
//  Created by 김태한 on 12. 2. 4..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "AppSettingModal.h"
#import "CSMainViewController.h"

#define SLINE_H 70
#define LEFT_L  115

@implementation AppSettingModal

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
	if ((self = [super initWithFrame:frame]))
    {
		self.headerLabel.text = title;

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

        sndSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 45, 60, 30)];
        [sndSwitch addTarget:self action:@selector(sndSetting:) forControlEvents:UIControlEventValueChanged];
        [sndSwitch setOnTintColor:[UIColor grayColor]];
        UILabel *sndLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_L, 45, 200, 30)];
        [sndLabel setBackgroundColor:CSCLEAR];
        [sndLabel setFont:CS_FONT(15)];
        [sndLabel setTextColor:[UIColor lightGrayColor]];
        [sndLabel setText:NSLocalizedString(@"Effect Sound", @"Effect Sound")];

        hideSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 45+SLINE_H, 60, 30)];
        [hideSwitch addTarget:self action:@selector(hideSetting:) forControlEvents:UIControlEventValueChanged];
        [hideSwitch setOnTintColor:[UIColor grayColor]];
        UILabel *hideLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_L, 45+SLINE_H, 220, 30)];
        [hideLabel setBackgroundColor:CSCLEAR];
        [hideLabel setFont:CS_FONT(15)];
        [hideLabel setTextColor:[UIColor lightGrayColor]];
        [hideLabel setText:NSLocalizedString(@"Hide Some Items on Run State", @"Hide Items")];

        gridSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 45+(SLINE_H*2), 60, 30)];
        [gridSwitch addTarget:self action:@selector(gridSetting:) forControlEvents:UIControlEventValueChanged];
        [gridSwitch setOnTintColor:[UIColor grayColor]];
        UILabel *gridLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_L, 45+(SLINE_H*2), 220, 30)];
        [gridLabel setBackgroundColor:CSCLEAR];
        [gridLabel setFont:CS_FONT(15)];
        [gridLabel setTextColor:[UIColor lightGrayColor]];
        [gridLabel setText:NSLocalizedString(@"Grid-Magnetic Surface (10 pixel)", @"Grid Move")];

        fbSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 45+(SLINE_H*3), 60, 30)];
        [fbSwitch addTarget:self action:@selector(facebookSetting:) forControlEvents:UIControlEventValueChanged];
        [fbSwitch setOnTintColor:[UIColor grayColor]];
        UILabel *fbLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_L, 45+(SLINE_H*3), 220, 30)];
        [fbLabel setBackgroundColor:CSCLEAR];
        [fbLabel setFont:CS_FONT(15)];
        [fbLabel setTextColor:[UIColor lightGrayColor]];
        [fbLabel setText:NSLocalizedString(@"facebook Connect", @"facebook")];

        resetAlphaBtn = [[BButton alloc] initWithFrame:CGRectMake(20, 45+(SLINE_H*4), 70, 30)];
        [resetAlphaBtn setTitle:@"Show"];
        [resetAlphaBtn.btn setBackgroundColor:[UIColor grayColor]];
        [resetAlphaBtn addTarget:self action:@selector(alphaReset:)];
        [resetAlphaBtn.btn.titleLabel setFont:CS_FONT(13) ];
        UILabel *alphaLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_L, 45+(SLINE_H*4), 200, 30)];
        [alphaLabel setBackgroundColor:CSCLEAR];
        [alphaLabel setFont:CS_FONT(15)];
        [alphaLabel setTextColor:[UIColor lightGrayColor]];
        [alphaLabel setText:NSLocalizedString(@"Change all alpha 0 to 0.5", @"Show Alpha 0")];

        [self.contentView addSubview:sndLabel];
        [self.contentView addSubview:hideLabel];
        [self.contentView addSubview:sndSwitch];
        [self.contentView addSubview:hideSwitch];
        [self.contentView addSubview:gridLabel];
        [self.contentView addSubview:gridSwitch];
        [self.contentView addSubview:fbLabel];
        [self.contentView addSubview:fbSwitch];
        [self.contentView addSubview:alphaLabel];
        [self.contentView addSubview:resetAlphaBtn];

	}

    [sndSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"SND_SET"]];
    [hideSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"HIDE_SET"]];
    [gridSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"GRID_SET"]];
    [fbSwitch setOn:nil!=[[NSUserDefaults standardUserDefaults] objectForKey:@"FBAccessTokenKey"]];

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

- (void) sndSetting:(UISwitch*)sw
{
    [[NSUserDefaults standardUserDefaults] setBool:sw.isOn forKey:@"SND_SET"];
}

- (void) hideSetting:(UISwitch*)sw
{
    [[NSUserDefaults standardUserDefaults] setBool:sw.isOn forKey:@"HIDE_SET"];
}

- (void) gridSetting:(UISwitch*)sw
{
    [[NSUserDefaults standardUserDefaults] setBool:sw.isOn forKey:@"GRID_SET"];
}

- (void) facebookSetting:(UISwitch*)sw
{
    if( sw.on ){
        if (![USERCONTEXT.facebook isSessionValid]) {
            [USERCONTEXT.facebook authorize:nil];
            [self hide];
        }
    } else {
        [USERCONTEXT.facebook logout];
    }
}

-(void) alphaReset:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RESET_ALPHA
                                                        object:nil
                                                      userInfo:nil];
}

@end
