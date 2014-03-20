//
//  CSFBSend.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 3. 13..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSGearObject.h"

@interface CSFBSend : CSGearObject
{
    NSString *message, *link;
    UIImage *img;
}

-(id) initGear;

-(void) setText:(NSString*)txt;
-(NSString*) getText;

-(void) setLink:(NSString*)txt;
-(NSString*) getLink;

-(void) setImage:(UIImage*)image;
-(UIImage*) getImage;

-(void) setShowAction:(NSNumber*)BoolValue;
-(NSNumber*) getShow;

@end
