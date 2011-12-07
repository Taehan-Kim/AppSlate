//
//  CSLabel.h
//  AppSlate
//
//  Created by 김태한 on 11. 11. 10..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSLabel : CSGearObject
{
    NSString    *text;
    UIColor     *textColor;
    UIFont      *textFont;
}

-(id) initGear;

@property (nonatomic, strong)   NSString    *text;

@end
