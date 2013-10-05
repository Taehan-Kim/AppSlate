//
//  WorldCell.h
//  AppSlate
//
//  Created by Tae Han Kim on 13. 5. 27..
//  Copyright (c) 2013년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface WorldCell : PFTableViewCell

- (void) setObject:(PFObject*)obj target:(id)target idx:(NSIndexPath *)indexPath;

@end
