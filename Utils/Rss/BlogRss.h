//
//  BlogRss.h
//  RssFun
//
//  Created by David Daniel on 27/02/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BlogRss : NSObject {
	NSString * _title;
	NSString * _description;
	NSString * _linkUrl;
	NSString * _guidUrl;
	NSString * _pubDate;	
	NSString * _mediaUrl;
}

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *linkUrl;
@property(nonatomic, copy) NSString *guidUrl;
@property(nonatomic, copy) NSString *pubDate;
@property(nonatomic, copy) NSString *mediaUrl;

@end




