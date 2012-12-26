/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    // blade.
//    UIActivityIndicatorView *activityIndicationView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    
//    activityIndicationView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
//    [self addSubview: activityIndicationView];
//    [activityIndicationView startAnimating];

    [self setImageWithURL:url placeholderImage:nil];

//    if( nil != self.image ){
//        [activityIndicationView stopAnimating];
//        [activityIndicationView removeFromSuperview];
//    }
//    [activityIndicationView release];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

#pragma mark SDWebImageManagerDelegate
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image;

//    UIActivityIndicatorView *actView = [self.subviews lastObject];
//    [actView stopAnimating];
//    [actView removeFromSuperview];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishFailWithImage:(UIImage *)image{
//    UIActivityIndicatorView *actView = [self.subviews lastObject];
//    [actView stopAnimating];
//    [actView removeFromSuperview];
}

@end
