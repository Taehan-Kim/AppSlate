//
//  CSBlueprintController.h
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 18..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSGearObject.h"
#import "CSLabel.h"
#import "CSTextField.h"
#import "CSBtnTextField.h"
#import "CSSwitch.h"
#import "CSButton.h"
#import "CSToggleButton.h"
#import "CSMAskedlabel.h"
#import "CSFlipCounter.h"
#import "CSSlider.h"
#import "CSTable.h"
#import "CSBulb.h"

@interface CSBlueprintController : UIViewController
{
    NSUInteger      modifyIdx;
    NSUInteger      modifyMagicNum;
    UIView          *modifyView;

    // 수정용 도구 버튼들.
    UIButton        *xButton;
    UIButton        *propButton;
    UIView          *sizeButton;
    UIPanGestureRecognizer *dragReco;
    UIPanGestureRecognizer *sizeReco;

    UIPopoverController *propertyPopoverController;

    // 선택된 객체가 항목에서 도면으로 떨어지는 효과를 위한 것 들.
    UIView *cView;
    CSGearObject *newObj;
}

// 청사진에 새로운 객체를 추가한다.
-(void) addNewGear:(id) gearObj;

// 고유넘버의 객체를 수정 모드로 설정한다.
-(void) setEditModeGearOfMagicNum:(NSUInteger)magicNum;

// 모두 제거한다.
-(void) deleteAllGear;

-(void) putAllGearsToView;

@end
