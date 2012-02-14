//
//  CSLayerTableViewController.h
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 7..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSLayerTableViewController : UITableViewController
{
    UIViewController *bluePaperCtrl;
}

-(void) setBlueprintViewController:(UIViewController*)v;

@end
