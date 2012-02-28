//
//  AppSettingModal.m
//  AppSlate
//
//  Created by 김태한 on 12. 2. 4..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "AppSettingModal.h"
#import "CSMainViewController.h"

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

@end
