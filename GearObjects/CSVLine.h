//
//  CSVLine.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 28..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSGearObject.h"

@interface CSVLine : CSGearObject

-(id) initGear;

-(void) setHeightAction:(NSNumber*)num;
-(NSNumber*) getHeight;

-(void) setBackgroundColor:(UIColor*)color;
-(UIColor*) getBackgroundColor;

@end
