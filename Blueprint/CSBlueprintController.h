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

@interface CSBlueprintController : UIViewController
{
    // 청사진에 등록된 객체들을 관리하는 저장소.
    NSMutableArray  *gearsArray;

    NSUInteger      modifyIdx;
    NSUInteger      modifyMagicNum;
    UIView          *modifyView;

    // 수정용 도구 버튼들.
    UIButton        *xButton;
    UIView          *sizeButton;
    UIPanGestureRecognizer *dragReco;
    UIPanGestureRecognizer *sizeReco;
}

// 청사진에 새로운 객체를 추가한다.
-(void) addNewGear:(id) gearObj;

// 고유넘버의 객체를 수정 모드로 설정한다.
-(void) setEditModeGearOfMagicNum:(NSUInteger)magicNum;

@end
