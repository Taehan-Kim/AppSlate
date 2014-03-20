//
//  CSWeiboComposer.h
//  AppSlate
//
//  Created by Tae Han Kim on 2013. 8. 13..
//  Copyright (c) 2013년 ChocolateSoft. All rights reserved.
//

#import "CSGearObject.h"

@interface CSWeiboComposer : CSGearObject
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
