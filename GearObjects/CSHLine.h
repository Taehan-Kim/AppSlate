//
//  CSHLine.h
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 28..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSGearObject.h"

@interface CSHLine : CSGearObject

-(id) initGear;

-(void) setWidth:(NSNumber*)num;
-(NSNumber*) getWidth;

-(void) setLineColor:(UIColor*)color;
-(UIColor*) getLineColor;

@end
