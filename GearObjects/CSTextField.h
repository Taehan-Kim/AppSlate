//
//  CSTextField.h
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 14..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSTextField : CSGearObject
{
    NSString    *text;
    UIColor     *textColor;
    UIFont      *textFont;
}

-(id) initGear;


@property (nonatomic, strong)   NSString    *text;

@end
