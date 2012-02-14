//
//  PropertyLinkTVController.h
//  AppSlate
//
//  Created by 김태한 on 12. 1. 7..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CSGearObject.h"

@interface PropertyLinkTVController : UITableViewController
{
    CSGearObject *destGear;
    CSGearObject *actionGear;
    NSUInteger  actionIdx;

    SystemSoundID tockSoundID;
}

-(void) setDestinationGear:(CSGearObject*)objD actionGear:(CSGearObject*)objA actionIndex:(NSUInteger)idx;

@end
