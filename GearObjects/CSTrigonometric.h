//
//  CSTrigonometric.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 3. 15..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSGearObject.h"

@interface CSTrigonometric : CSGearObject

-(id) initGear;

-(void) setRadianValueAction:(NSNumber*) num;
-(NSNumber*) getRadianValue;

@end
