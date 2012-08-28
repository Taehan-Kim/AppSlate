//
//  CSFBSend.h
//  AppSlate
//
//  Created by 김 태한 on 12. 3. 13..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSGearObject.h"

@interface CSFBSend : CSGearObject
{
    NSString *name, *caption, *message, *link;
    UIImage *img;
}

-(id) initGear;

-(void) setName:(NSString*)txt;
-(NSString*) getName;

-(void) setCaption:(NSString*)txt;
-(NSString*) getCaption;

-(void) setText:(NSString*)txt;
-(NSString*) getText;

-(void) setLink:(NSString*)txt;
-(NSString*) getLink;

-(void) setImage:(UIImage*)image;
-(UIImage*) getImage;

-(void) setShow:(NSNumber*)BoolValue;
-(NSNumber*) getShow;

@end
