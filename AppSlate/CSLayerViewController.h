//
//  CSLayerViewController.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 6. 21..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSLayerTableViewController.h"

@interface CSLayerViewController : UIViewController
{
    CSLayerTableViewController *tvc;
}

-(void) setBlueprintViewController:(UIViewController*)v;

@end
