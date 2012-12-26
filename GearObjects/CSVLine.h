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

-(void) setHeight:(NSNumber*)num;
-(NSNumber*) getHeight;

-(void) setLineColor:(UIColor*)color;
-(UIColor*) getLineColor;

@end
