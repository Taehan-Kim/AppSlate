//
//  CSTwitComposer.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 21..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSTwitComposer : CSGearObject
{
    NSString *textStr, *linkStr;
    UIImage *image;
}

-(id) initGear;

-(void) setText:(NSString*)txt;
-(NSString*) getText;

-(void) setLink:(NSString*)txt;
-(NSString*) getLink;

-(void) setShowAction:(NSNumber*)BoolValue;
-(NSNumber*) getShow;

-(void) setImage:(UIImage*)img;
-(UIImage*) getImage;

@end
