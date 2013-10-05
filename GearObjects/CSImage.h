//
//  CSImage.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 27..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"
#import "AFPhotoEditorController.h"

@interface CSImage : CSGearObject <AFPhotoEditorControllerDelegate>

-(id) initGear;

-(void) setImage:(UIImage*) imageD;
-(UIImage*) getImage;

-(void) setSave:(NSNumber*) boolValue;
-(BOOL) getSave;

-(void) setEdit:(NSNumber*) boolValue;
-(BOOL) getEdit;

-(void) setAspectFit:(NSNumber*) boolValue;
-(NSNumber*) getAspectFit;

-(void) setBackgroundColor:(UIColor*)color;
-(UIColor*) getBackgroundColor;

@end
