//
//  CSFBSend.h
//  AppSlate
//
//  Created by 김 태한 on 12. 3. 13..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSGearObject.h"
#import "FBConnect.h"

@interface CSFBSend : CSGearObject <FBDialogDelegate>
{
    NSString *name, *caption, *message, *link;
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

-(void) setShow:(NSNumber*)BoolValue;
-(NSNumber*) getShow;

@end
