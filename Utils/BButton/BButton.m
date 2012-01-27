//
//  BButton.m
//  AppSlate
//
//  Created by 태한 김 on 11. 12. 26..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "BButton.h"

@implementation BButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        
        [self.layer setBorderWidth:2.5];
        [self.layer setCornerRadius:5.0];
        [self.layer setBorderColor:[UIColor whiteColor].CGColor];

        gradient = [CAGradientLayer layer];
        [gradient setFrame:[self bounds]];
        [gradient setColors:[NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil]];
        [gradient setOpacity:0.5];
        [self.layer addSublayer:gradient];

        // Default Color
        [self.layer setBackgroundColor:[UIColor blueColor].CGColor];

        [self addTarget:self action:@selector(touchIn:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)layoutSubviews
{
    gradient.frame = self.bounds;   // make the subview frame match its view

    [super layoutSubviews];
}



-(void) touchIn:(id)sender
{
//    gradient.opacity = 0.9;
    [gradient setColors:[NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil]];
}

-(void) touchUp:(id)sender
{
//    gradient.opacity = 0.5;
    [gradient setColors:[NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil]];
}

#pragma mark -

-(void) setTitle:(NSString *)txt
{
    [self setTitle:txt forState:UIControlStateNormal];
    [self setTitle:txt forState:UIControlStateHighlighted];
    [self setTitle:txt forState:UIControlStateSelected];
}

-(void) setTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateHighlighted];
    [self setTitleColor:color forState:UIControlStateSelected];
}

-(void) addTarget:(id)tg action:(SEL)selector
{
    [self addTarget:tg action:selector forControlEvents:UIControlEventTouchUpInside];
}

@end
