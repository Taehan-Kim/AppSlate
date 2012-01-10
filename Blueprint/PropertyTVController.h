//
//  PropertyTVController.h
//  AppSlate
//
//  Created by 김태한 on 11. 12. 11..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSGearObject.h"

@interface PropertyTVController : UITableViewController <UIAlertViewDelegate>
{
    CSGearObject *theGear;
}

-(void) setSelectedGear:(CSGearObject*) obj;

@end
