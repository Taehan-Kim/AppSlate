//
//  BButton.h
//  AppSlate
//
//  Created by 태한 김 on 11. 12. 26..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BButton : UIButton
{
    CAGradientLayer *moreGradient;
}

-(void) setTitle:(NSString *)title;
-(void) addTarget:(id)tg action:(SEL)selector;

@end
