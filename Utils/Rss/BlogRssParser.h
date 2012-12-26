//
//  BlogRssParser.h
//  RssFun
//
//  Created by David Daniel on 27/02/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BlogRss;

@protocol BlogRssParserDelegate;

@interface BlogRssParser : NSObject <NSXMLParserDelegate>
{
	BlogRss * _currentItem;
	NSMutableString * _currentItemValue;
	NSMutableArray * _rssItems;
	id<BlogRssParserDelegate> _delegate;
	NSOperationQueue *_retrieverQueue;
	
	NSString *_rssURL;
	
	NSXMLParser *_parser;
}
@property(nonatomic, retain) BlogRss * currentItem;
@property(nonatomic, strong) NSMutableString * currentItemValue;
@property(nonatomic, retain) NSMutableArray * rssItems;

@property(nonatomic, strong) id<BlogRssParserDelegate> delegate;
@property(nonatomic, strong) NSOperationQueue *retrieverQueue;
@property(nonatomic, retain) NSString *rssURL;

@property(nonatomic, strong) NSXMLParser *parser;

- (void)startProcess;

@end

@protocol BlogRssParserDelegate <NSObject>

-(void)processCompleted;
-(void)processHasErrors;

@end
