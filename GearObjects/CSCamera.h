//
//  CSCamera.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 5. 10..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSGearObject.h"
#import <AVFoundation/AVFoundation.h>

@interface CSCamera : CSGearObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

-(id) initGear;

-(void) setShow:(NSNumber*)BoolValue;
-(NSNumber*) getShow;

@end
