//
//  InfoModal.m
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 17..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "InfoModal.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation InfoModal

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Margin between edge of container frame and panel. Default = 20.0
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            // I am iPad
            self.outerMargin = 100.0f;
            self.cornerRadius = 20.0;
        }
        else {
            // I am iPhone
        }
        // Margin between edge of panel and the content area. Default = 20.0
        self.innerMargin = 10.0f;

        [self setTitleBarHeight:40];
        self.headerLabel.text = @"About AppSlate";
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

@end
