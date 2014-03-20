//
//  BlogRssParser.m
//  RssFun
//
//  Created by Imthiaz Rafiq on 8/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BlogRssParser.h"
#import "BlogRss.h"
#import <Foundation/NSXMLParser.h>

@implementation BlogRssParser

@synthesize currentItem = _currentItem;
@synthesize currentItemValue = _currentItemValue;
@synthesize rssItems = _rssItems;
@synthesize delegate = _delegate;
@synthesize retrieverQueue = _retrieverQueue;
@synthesize rssURL = _rssURL;
@synthesize parser = _parser;

- (id)init
{
    if( !(self = [super init]) ) return nil;

	_rssItems = [[NSMutableArray alloc]init];
	return self;
}

- (NSOperationQueue *)retrieverQueue {
	if(nil == _retrieverQueue) {
		_retrieverQueue = [[NSOperationQueue alloc] init];
		_retrieverQueue.maxConcurrentOperationCount = 1;
	}
	return _retrieverQueue;
}

- (void)startProcess{
	SEL method = @selector(fetchAndParseRss);
	[[self rssItems] removeAllObjects];
	NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self 
																	 selector:method 
																	   object:nil];
	[self.retrieverQueue addOperation:op];
//	[op release];
}

-(BOOL)fetchAndParseRss
{
    BOOL success = NO;

    @autoreleasepool {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        //To suppress the leak in NSXMLParser
        [[NSURLCache sharedURLCache] setMemoryCapacity:0];
        [[NSURLCache sharedURLCache] setDiskCapacity:0];
        
        NSURL *url = [NSURL URLWithString:_rssURL];
        _parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        [_parser setDelegate:self];
        [_parser setShouldProcessNamespaces:YES];
        [_parser setShouldReportNamespacePrefixes:YES];
        [_parser setShouldResolveExternalEntities:NO];
        success = [_parser parse];
    }

	return success;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	if(nil != qualifiedName){
		elementName = qualifiedName;
	}
	if ([elementName isEqualToString:@"item"]) {
		self.currentItem = [[BlogRss alloc]init];
//	}else if ([elementName isEqualToString:@"media:thumbnail"]) {
//		self.currentItem.mediaUrl = [attributeDict valueForKey:@"url"];
	} else if([elementName isEqualToString:@"title"] || 
			  [elementName isEqualToString:@"description"] ||
			  [elementName isEqualToString:@"link"] ||
			  [elementName isEqualToString:@"guid"] ||
			  [elementName isEqualToString:@"pubDate"]) {
		self.currentItemValue = [NSMutableString string];
	} else {
		self.currentItemValue = nil;
	}	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if(nil != qName){
		elementName = qName;
	}
	if([elementName isEqualToString:@"title"]){
		self.currentItem.title = self.currentItemValue;
	}else if([elementName isEqualToString:@"description"]){
		self.currentItem.description = self.currentItemValue;
	}else if([elementName isEqualToString:@"link"]){
		self.currentItem.linkUrl = self.currentItemValue;
	}else if([elementName isEqualToString:@"guid"]){
		self.currentItem.guidUrl = self.currentItemValue;
	}else if([elementName isEqualToString:@"pubDate"]){
//		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//		[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
//		self.currentItem.pubDate = [formatter dateFromString:self.currentItemValue];
//		NSLog(@"time %@",self.currentItem.pubDate);
//		[formatter release];
		self.currentItem.pubDate = self.currentItemValue;
	}else if([elementName isEqualToString:@"item"]){
		[[self rssItems] addObject:self.currentItem];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(nil != self.currentItemValue){
		[self.currentItemValue appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
	if(nil != self.currentItemValue){
		[self.currentItemValue appendString:[[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding]];
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	if(parseError.code != NSXMLParserDelegateAbortedParseError) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[(id)[self delegate] performSelectorOnMainThread:@selector(processHasErrors)
		 withObject:nil
		 waitUntilDone:NO];
	}
}



- (void)parserDidEndDocument:(NSXMLParser *)parser {
	[(id)[self delegate] performSelectorOnMainThread:@selector(processCompleted)
                                          withObject:nil
                                       waitUntilDone:NO];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
