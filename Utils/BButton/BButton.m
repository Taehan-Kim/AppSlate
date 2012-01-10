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

        CAGradientLayer *gradient = [CAGradientLayer layer];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) touchIn:(id)sender
{
    moreGradient = [CAGradientLayer layer];
    [moreGradient setFrame:[self bounds]];
    [moreGradient setColors:[NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil]];
    [moreGradient setOpacity:0.8];
    [self.layer addSublayer:moreGradient];
}

-(void) touchUp:(id)sender
{
    [moreGradient removeFromSuperlayer];
}

#pragma mark -

-(void) setTitle:(NSString *)txt
{
    [self setTitle:txt forState:UIControlStateNormal];
    [self setTitle:txt forState:UIControlStateHighlighted];
    [self setTitle:txt forState:UIControlStateSelected];
}

-(void) addTarget:(id)tg action:(SEL)selector
{
    [self addTarget:tg action:selector forControlEvents:UIControlEventTouchUpInside];
}

@end
