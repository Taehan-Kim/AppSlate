//
//  FileCell.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 1. 18..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridViewCell.h"

@interface FileCell : AQGridViewCell
{
    UIImageView * _imageView;
    UILabel * _title;
    UIImageView *trashMark;
}

@property (nonatomic, retain) UIImage * image;
@property (nonatomic, copy) NSString * title;

- (void) showTrash:(BOOL) showBool;

@end
