//
//  CSNor.h
//  AppSlate
//
//  Created by 김태한 on 12. 2. 17..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSNor : CSGearObject
{
    BOOL value1, value2;
}

-(id) initGear;

-(void) setInput1Value:(NSNumber*) BoolValue;
-(NSNumber*) getInput1Value;

-(void) setInput2Value:(NSNumber*) BoolValue;
-(NSNumber*) getInput2Value;

@end
