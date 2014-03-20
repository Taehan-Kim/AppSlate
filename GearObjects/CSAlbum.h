//
//  CSAlbum.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 21..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSAlbum : CSGearObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIPopoverController *albumPop;
    UIImagePickerController *imgPicker;
}

-(id) initGear;

-(void) setShowAction:(NSNumber*)BoolValue;
-(NSNumber*) getShow;

@end
