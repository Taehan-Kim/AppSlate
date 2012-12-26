//
//  CSMaskedLabel.h
//  AppSlate
//
//  Created by Taehan Kim on 11. 11. 10..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"
#import "RSMaskedLabel.h"

@interface CSMaskedLabel : CSGearObject
{
}

-(id) initGear;


-(void) setText:(NSString*)txt;
-(NSString*) getText;

-(void) setBackgroundColor:(UIColor*)color;
-(UIColor*) getBackgroundColor;

-(void) setFont:(UIFont*)font;
-(UIFont*) getFont;

@end
