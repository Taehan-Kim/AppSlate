//
//  CSImage.h
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 27..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSImage : CSGearObject

-(id) initGear;

-(void) setImage:(UIImage*) imageD;
-(UIImage*) getImage;

@end
