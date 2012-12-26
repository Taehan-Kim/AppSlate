//
//  WaitView.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 11. 1. 13..
//  Copyright 2011 ChocolateSoft. All rights reserved.
//

#import "WaitView.h"
 #import <QuartzCore/QuartzCore.h>

@implementation WaitView


- (id)initWithFrame:(CGRect)frame
{    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor colorWithRed:0.0 green:0 blue:0 alpha:0.7];
		self.layer.cornerRadius = 10.0;
		self.clipsToBounds = YES;

		activityIndicationView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
		
		activityIndicationView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		[self addSubview: activityIndicationView];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	[activityIndicationView startAnimating];
}

@end
