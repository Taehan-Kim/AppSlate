//
//  CSAppDelegate.h
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class CSMainViewController;

@interface CSAppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate>
{
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) CSMainViewController *mainViewController;

@end
