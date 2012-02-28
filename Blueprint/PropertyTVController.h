//
//  PropertyTVController.h
//  AppSlate
//
//  Created by 김태한 on 11. 12. 11..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CSGearObject.h"

@interface PropertyTVController : UITableViewController <UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    CSGearObject *theGear;
    
    SystemSoundID tockSoundID;
    NSDictionary *tempInfo;
    UIPopoverController *libpop;
}

-(void) setSelectedGear:(CSGearObject*) obj;

@end
