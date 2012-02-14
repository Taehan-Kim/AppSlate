//
//  BButton.m
//  AppSlate
//
//  Created by 태한 김 on 11. 12. 26..
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
    [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    gradient = [CAGradientLayer layer];
    [gradient setFrame:[self bounds]];
    [gradient setColors:[NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil]];
    [gradient setOpacity:0.5];
    [self.layer addSublayer:gradient];
    
    btn = [[UIButton alloc] initWithFrame:self.bounds];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [self addSubview:btn];
    
    // Default Color
    [self.layer setBackgroundColor:[UIColor blueColor].CGColor];
    
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
        [self commonInit];
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
    [btn setTitle:txt forState:UIControlStateNormal];
//    [self setTitle:txt forState:UIControlStateHighlighted];
    [btn setTitle:txt forState:UIControlStateSelected];

    [self setNeedsDisplay];
}

-(void) setTitleColor:(UIColor *)color
{
    [btn setTitleColor:color forState:UIControlStateNormal];
//    [self setTitleColor:color forState:UIControlStateHighlighted];
    [btn setTitleColor:color forState:UIControlStateSelected];
}

-(void) addTarget:(id)tg action:(SEL)selector
{
    [btn addTarget:tg action:selector forControlEvents:UIControlEventTouchUpInside];
}

@end
