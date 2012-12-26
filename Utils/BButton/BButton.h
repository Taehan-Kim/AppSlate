//
//  BButton.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 11. 12. 26..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BButton : UIView
{
    UIButton        *btn;
    CAGradientLayer *gradient;
}

-(void) setTitle:(NSString *)title;
-(void) setTitleColor:(UIColor *)color;
-(void) addTarget:(id)tg action:(SEL)selector;

@property (nonatomic,strong)    UIButton *btn;

@end
