//
//  CSFlipCounter.h
//  AppSlate
//
//  Created by 김 태한 on 12. 1. 26..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"
#import "FlipCounterView.h"

@interface CSFlipCounter : CSGearObject <FlipCounterViewDelegate>
{
    NSUInteger checkNumber;
}

-(id) initGear;
-(void) valueChanged;
-(void) iAmZero;
-(void) _checkAndRun;

-(void) setNumber:(NSNumber*)number;
-(NSNumber*) getNumber;

-(void) setAddNumber:(NSNumber*)number;
-(NSNumber*) getAddNumber;

-(void) setSubtractNumber:(NSNumber*)number;
-(NSNumber*) getSubtractNumber;

@end
