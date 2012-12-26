//
//  CSBlueprintView.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 1. 5..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"
#import "CSGearObject.h"

@interface CSBlueprintView : UIView <CMPopTipViewDelegate>
{
    UIPanGestureRecognizer *panGestureRecognizer;
    UIView          *actionHandle;
    CGPoint         linkStartPoint, newP;
    CMPopTipView    *popTip;
    CSGearObject    *pointedObj;

    CSGearObject    *actionGear;
    NSUInteger      actionIndex;
}

-(void) startActionLink:(NSDictionary*) info;

@end
