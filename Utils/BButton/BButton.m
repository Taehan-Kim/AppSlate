//
//  BButton.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 11. 12. 26..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "BButton.h"

@implementation BButton

@synthesize btn;

- (void) commonInit
{
    // Initialization code
    self.clipsToBounds = YES;
    [self.layer setBorderWidth:2.5];
    [self.layer setCornerRadius:5.0];
    [self.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    
//    gradient = [CAGradientLayer layer];
//    [gradient setFrame:[self bounds]];
//    [gradient setColors:@[ (id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor] ]];
//    [gradient setOpacity:0.5];
//    [self.layer addSublayer:gradient];
    
    btn = [[UIButton alloc] initWithFrame:self.bounds];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [btn setTag:2386];
    [self addSubview:btn];
    
    // Default Color
    [self setBackgroundColor:[UIColor blueColor]];

    [btn addTarget:self action:@selector(touchIn:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside];
    [btn addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
}

- (id)initWithFrame:(CGRect)frame
{
    if( self = [super initWithFrame:frame] ){
        [self commonInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( self = [super initWithCoder:decoder] ){
        self.clipsToBounds = YES;
        [self.layer setBorderWidth:2.5];
        [self.layer setCornerRadius:4.0];
        [self.layer setBorderColor:[UIColor darkGrayColor].CGColor];
//        gradient = [CAGradientLayer layer];
//        [gradient setFrame:[self bounds]];
//        [gradient setColors:@[ (id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor] ]];
//        [gradient setOpacity:0.5];
//        [self.layer addSublayer:gradient];

        btn = (UIButton*)[self viewWithTag:2386];
        [btn addTarget:self action:@selector(touchIn:) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside];
        [btn addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    }

    return self;
}

//-(void)layoutSubviews
//{
//    gradient.frame = self.bounds;   // make the subview frame match its view
//
//    [super layoutSubviews];
//}



-(void) touchIn:(id)sender
{
//    gradient.opacity = 0.9;
//    [gradient setColors:@[ (id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor] ]];
    UIColor *swapColor = self.backgroundColor;
    [self setBackgroundColor: [btn titleColorForState:UIControlStateNormal]];
    [btn setTitleColor:swapColor forState:UIControlStateHighlighted];

    [self.layer setBorderColor:[UIColor whiteColor].CGColor];
}

-(void) touchUp:(id)sender
{
//    gradient.opacity = 0.5;
//    [gradient setColors:@[ (id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor] ]];
    [self setBackgroundColor: [btn titleColorForState:UIControlStateHighlighted]];

    [self.layer setBorderColor:[UIColor darkGrayColor].CGColor];
}

#pragma mark -

-(void) setTitle:(NSString *)txt
{
    [btn setTitle:txt forState:UIControlStateNormal];
    [btn setTitle:txt forState:UIControlStateHighlighted];

    [self setNeedsDisplay];
}

-(void) setTitleColor:(UIColor *)color
{
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
}

-(void) addTarget:(id)tg action:(SEL)selector
{
    [btn addTarget:tg action:selector forControlEvents:UIControlEventTouchUpInside];
}

@end
