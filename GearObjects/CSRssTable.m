//
//  CSRssTable.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 3. 6..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSRssTable.h"
#import "BlogRss.h"

@implementation CSRssTable

-(id) object
{
    return ((UITableView*)csView);
}

//===========================================================================
#pragma mark -

-(void) setCellHeight:(NSNumber*) number
{
    if( [number isKindOfClass:[NSNumber class]] )
        cellHeight = [number floatValue];
    else if( [number isKindOfClass:[NSString class]] )
        cellHeight = [(NSString*)number floatValue];
    else{
        EXCLAMATION;
        return;
    }
    
    [((UITableView*)csView) beginUpdates];
    [((UITableView*)csView) endUpdates];
}

-(NSNumber*) getCellHeight
{
    return @(cellHeight);
}

-(void) setAddress:(NSString*) txt
{
    if( [txt isKindOfClass:[NSString class]] ){
        url = txt;
        rssParser.rssURL = url;
    } else {
        EXCLAMATION;
        return;
    }

    [rssParser startProcess];
}

-(NSString*) getAddress
{
    return url;
}

-(void) setReloadTable:(NSNumber*)BoolValue
{
    // YES 값인 경우만 반응하자.
    if( ![BoolValue boolValue] )
        return;

    [rssParser startProcess];
}

-(NSNumber*) getReloadTable
{
    return @NO;
}

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 350)];
    [csView setUserInteractionEnabled:YES];

    rssParser = [[BlogRssParser alloc] init];
    [rssParser setDelegate:self];

    csCode = CS_RSSTABLE;
    isUIObj = YES;
    
    cellHeight = 55.0;
    
    [((UITableView*)csView) setDelegate:self];
    [((UITableView*)csView) setDataSource:self];

    self.info = NSLocalizedString(@"RSS Table", @"RSS Table");
    url = @"http://";

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"RSS URL", P_TXT, @selector(setAddress:),@selector(getAddress));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Table Cell Height", P_NUM, @selector(setCellHeight:),@selector(getCellHeight));
    NSDictionary *d3 = MAKE_PROPERTY_D(@">Reload", P_BOOL, @selector(setReloadTable:),@selector(getReloadTable));    
    pListArray = @[xc,yc,d0,d1,d2,d3];
    
    NSMutableDictionary MAKE_ACTION_D(@"Selected Cell Index", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Selected Title", A_TXT, a2);
    NSMutableDictionary MAKE_ACTION_D(@"Selected URL", A_TXT, a3);
    actionArray = @[a1, a2, a3];
    
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if( (self=[super initWithCoder:aDecoder]) ){
        cellHeight = [aDecoder decodeFloatForKey:@"cellHeight"];
        url = [aDecoder decodeObjectForKey:@"url"];

        // HACK. UItableView 가 다시 불러오면 delegate 설정이 전혀 안먹는다.
        // 지우고 다시 생성한 다음 delegate 를 설정해서 사용한다.
        CGRect rect = csView.frame;
        [csView removeFromSuperview];

        csView = [[UITableView alloc] initWithFrame:rect];
        [((UITableView*)csView) setDelegate:self];
        [((UITableView*)csView) setDataSource:self];

        rssParser = [[BlogRssParser alloc] init];
        [rssParser setDelegate:self];
        [rssParser setRssURL:url];
        [rssParser performSelector:@selector(startProcess) withObject:nil afterDelay:0.5];
    }

    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeFloat:cellHeight forKey:@"cellHeight"];
    [encoder encodeObject:url forKey:@"url"];
}


#pragma mark - Table View Delegate

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[rssParser rssItems] count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"RssCell"];
    if( nil == cell ){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"RssCell"];
    }

    BlogRss *rssItem = (BlogRss*)[rssParser rssItems][indexPath.row];
    cell.textLabel.text = [rssItem title];
    cell.detailTextLabel.text = [rssItem description];

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 선택 사항에 대해서 정해진 액션 동작으로 선택 정보를 알린다.
    SEL act;
    NSNumber *nsMagicNum;
    BlogRss *rssItem = (BlogRss*)[rssParser rssItems][indexPath.row];

    // 1. Selected Index
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:@(indexPath.row)];
            else
                EXCLAMATION;
        }
    }
    // 2. Selected Cell's String
    act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:[rssItem title] ];
            else
                EXCLAMATION;
        }
    }
    // 2. Selected Cell's URL
    act = ((NSValue*)((NSDictionary*)actionArray[2])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[2])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];

        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:[rssItem linkUrl] ];
            else
                EXCLAMATION;
        }
    }
}

#pragma mark - RssParser Delegate

-(void)processCompleted
{
    [((UITableView*)csView) reloadData];
}

-(void)processHasErrors
{
    EXCLAMATION;
}

@end
