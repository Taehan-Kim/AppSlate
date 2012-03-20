//
//  CSRadDeg.h
//  AppSlate
//
//  Created by 김 태한 on 12. 3. 15..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSGearObject.h"

@interface CSRadDeg : CSGearObject

-(id) initGear;

-(void) setDegreeValue:(NSNumber*) num;
-(NSNumber*) getDegreeValue;

-(void) setRadianValue:(NSNumber*) num;
-(NSNumber*) getRadianValue;

@end
