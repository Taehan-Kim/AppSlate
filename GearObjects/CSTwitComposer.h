//
//  CSTwitComposer.h
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 21..
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

-(void) setShow:(NSNumber*)BoolValue;
-(NSNumber*) getShow;

-(void) setImage:(UIImage*)img;
-(UIImage*) getImage;

@end
