//
//  ParseGalleryViewController.h
//  AppSlate
//
//  Created by 김태한 on 13. 5. 26..
//  Copyright (c) 2013년 ChocolateSoft. All rights reserved.
//

#import <Parse/Parse.h>

@interface ParseGalleryViewController : PFQueryTableViewController<UISearchBarDelegate>

-(void) deleteApp:(NSIndexPath*)indexPath;

@end
