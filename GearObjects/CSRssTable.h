//
//  CSRssTable.h
//  AppSlate
//
//  Created by 김 태한 on 12. 3. 6..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlogRssParser.h"
#import "CSGearObject.h"

// @"http://newsrss.bbc.co.uk/rss/sportonline_world_edition/front_page/rss.xml"
@interface CSRssTable : CSGearObject <UITableViewDelegate, UITableViewDataSource, BlogRssParserDelegate>
{
    BlogRssParser  *rssParser;
    NSString *url;

    float cellHeight;
}

-(id) initGear;

-(void) setCellHeight:(NSNumber*) number;
-(NSNumber*) getCellHeight;

-(void) setAddress:(NSString*) txt;
-(NSString*) getAddress;

-(void) setReloadTable:(NSNumber*)BoolValue;
-(NSNumber*) getReloadTable;

@end
