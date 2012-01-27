//
//  FileCell.m
//  AppSlate
//
//  Created by 김 태한 on 12. 1. 18..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "FileCell.h"

@implementation FileCell

- (id) initWithFrame: (CGRect) frame reuseIdentifier: (NSString *) aReuseIdentifier
{
    self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    if ( self == nil )
        return ( nil );
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, 100, 130)];
    _title = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-15, frame.size.width, 15)];
    _title.font = [UIFont boldSystemFontOfSize: 14.0];
    _title.adjustsFontSizeToFitWidth = YES;
    _title.textAlignment = UITextAlignmentCenter;
    _title.backgroundColor = [UIColor clearColor];
    _title.textColor = [UIColor whiteColor];
    _title.shadowColor = [UIColor darkGrayColor];
    _title.shadowOffset = CGSizeMake(0, -1);
    _title.minimumFontSize = 10.0;

    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = self.backgroundColor;
//    _imageView.backgroundColor = [UIColor clearColor];
    _imageView.layer.cornerRadius = 6.0;
    _imageView.clipsToBounds = YES;

    
    [self.contentView addSubview: _imageView];
    [self.contentView addSubview: _title];
    
    return ( self );
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIImage *) image
{
    return ( _imageView.image );
}

- (void) setImage: (UIImage *) anImage
{
    _imageView.image = anImage;
    [self setNeedsLayout];
}

- (NSString *) title
{
    return ( _title.text );
}

- (void) setTitle: (NSString *) title
{
    _title.text = title;
}

@end
