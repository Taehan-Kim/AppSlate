//
//  AppSettingModal.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 2. 4..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "AppSettingModal.h"
#import "CSMainViewController.h"

#define SLINE_H __h__
#define LEFT_L  115

@implementation AppSettingModal

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    CGFloat __h__;

    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        __h__ = 70.0;
    else
        __h__ = 40;

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
            self.outerMargin = 10.0f;
            self.cornerRadius = 8.0;
        }
        // Margin between edge of panel and the content area. Default = 20.0
        self.innerMargin = 10.0f;
        [self setTitleBarHeight:30];
        [self headerLabel].font = [UIFont boldSystemFontOfSize:floor(self.titleBarHeight / 2.0)];

        sndSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 45, 60, 30)];
        [sndSwitch addTarget:self action:@selector(sndSetting:) forControlEvents:UIControlEventValueChanged];
        [sndSwitch setOnTintColor:[UIColor grayColor]];
        UILabel *sndLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_L, 45, frame.size.width-LEFT_L, 30)];
        [sndLabel setBackgroundColor:CSCLEAR];
        [sndLabel setFont:CS_FONT(15)];
        [sndLabel setTextColor:[UIColor lightGrayColor]];
        [sndLabel setText:NSLocalizedString(@"Effect Sound", @"Effect Sound")];

        hideSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 45+SLINE_H, 60, 30)];
        [hideSwitch addTarget:self action:@selector(hideSetting:) forControlEvents:UIControlEventValueChanged];
        [hideSwitch setOnTintColor:[UIColor grayColor]];
        UILabel *hideLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_L, 45+SLINE_H, frame.size.width-LEFT_L-(self.innerMargin*3), 30)];
        [hideLabel setBackgroundColor:CSCLEAR];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [hideLabel setFont:CS_FONT(15)];
        else
            [hideLabel setFont:CS_FONT(13)];
        [hideLabel setNumberOfLines:2];
        [hideLabel setTextColor:[UIColor grayColor]];
        [hideLabel setText:NSLocalizedString(@"Hide Some Items on Run State", @"Hide Items")];

        gridSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 45+(SLINE_H*2), 60, 30)];
        [gridSwitch addTarget:self action:@selector(gridSetting:) forControlEvents:UIControlEventValueChanged];
        [gridSwitch setOnTintColor:[UIColor orangeColor]];
        UILabel *gridLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_L, 45+(SLINE_H*2), frame.size.width-LEFT_L-(self.innerMargin*3), 30)];
        [gridLabel setBackgroundColor:CSCLEAR];
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            [gridLabel setFont:CS_FONT(15)];
        else
            [gridLabel setFont:CS_FONT(13)];
        [gridLabel setNumberOfLines:2];
        [gridLabel setTextColor:[UIColor lightGrayColor]];
        [gridLabel setText:NSLocalizedString(@"Grid-Magnetic Surface (10 pixel)", @"Grid Move")];

        lineSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 45+(SLINE_H*3), 60, 30)];
        [lineSwitch addTarget:self action:@selector(lineViewSetting:) forControlEvents:UIControlEventValueChanged];
        [lineSwitch setOnTintColor:[UIColor yellowColor]];
        UILabel *lLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_L, 45+(SLINE_H*3), frame.size.width-LEFT_L-self.innerMargin, 30)];
        [lLabel setBackgroundColor:CSCLEAR];
        [lLabel setFont:CS_FONT(15)];
        [lLabel setNumberOfLines:2];
        [lLabel setTextColor:[UIColor lightGrayColor]];
        [lLabel setText:NSLocalizedString(@"Show Link Lines", @"Show Link Lines")];

//        fbSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20, 45+(SLINE_H*4), 60, 30)];
//        [fbSwitch addTarget:self action:@selector(facebookSetting:) forControlEvents:UIControlEventValueChanged];
////        [fbSwitch setOnTintColor:[UIColor grayColor]];
//        UILabel *fbLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_L, 45+(SLINE_H*4), 220, 30)];
//        [fbLabel setBackgroundColor:CSCLEAR];
//        [fbLabel setFont:CS_FONT(15)];
//        [fbLabel setTextColor:[UIColor lightGrayColor]];
//        [fbLabel setText:NSLocalizedString(@"facebook Connect", @"facebook")];

        resetAlphaBtn = [[BButton alloc] initWithFrame:CGRectMake(20, 45+(SLINE_H*5), 70, 30)];
        [resetAlphaBtn setTitle:@"Show"];
        [resetAlphaBtn.btn setBackgroundColor:[UIColor grayColor]];
        [resetAlphaBtn addTarget:self action:@selector(alphaReset:)];
        [resetAlphaBtn.btn.titleLabel setFont:CS_FONT(13) ];
        UILabel *alphaLabel = [[UILabel alloc] initWithFrame:CGRectMake(LEFT_L, 45+(SLINE_H*5), frame.size.width-LEFT_L, 30)];
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
        [self.contentView addSubview:lLabel];
        [self.contentView addSubview:lineSwitch];
//        [self.contentView addSubview:fbLabel];
//        [self.contentView addSubview:fbSwitch];
        [self.contentView addSubview:alphaLabel];
        [self.contentView addSubview:resetAlphaBtn];

        [sndSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"SND_SET"]];
        [hideSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"HIDE_SET"]];
        [gridSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"GRID_SET"]];
        [lineSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"LINE_SET"]];
	}

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

- (void) lineViewSetting:(UISwitch*)sw
{
    [[NSUserDefaults standardUserDefaults] setBool:sw.isOn forKey:@"LINE_SET"];

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_STOP
                                                        object:nil];
}

-(void) alphaReset:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RESET_ALPHA
                                                        object:nil
                                                      userInfo:nil];
}

@end
