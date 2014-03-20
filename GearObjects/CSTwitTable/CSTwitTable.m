//
//  CSTwitTable.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 3. 7..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSTwitTable.h"
#import "TTableCell.h"
#import <Social/Social.h>

@implementation CSTwitTable


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

-(void) setAccount:(NSNumber*) BoolValue
{
    // YES 값인 경우만 반응하자.
    if( ![BoolValue boolValue] )
        return;
    if( nil == accounts || 0 == [accounts count] )
        return;

    UIActionSheet *ac = [[UIActionSheet alloc] init];
    [ac setTitle:@"Select"];
    [ac setDelegate:self];
    for( ACAccount *as in accounts )
        [ac addButtonWithTitle:as.username];

    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        [ac showInView:self.csView];
    else
        [ac showInView:[UIApplication sharedApplication].windows[0]];
}

-(void) setLoadTimelineAction:(NSNumber*) BoolValue
{
    // YES 값인 경우만 반응하자.
    if( ![BoolValue boolValue] )
        return;

    [self fetchData];
}

-(NSNumber*) getLoadTimeline
{
    return @NO;
}

-(NSNumber*) getAccount
{
    return @NO;
}

- (void)fetchData
{
    if( nil == accounts ) return;
    if( _loading ) return;

    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/home_timeline.json"];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url parameters:nil];

    START_WAIT_VIEW;
    _loading = YES;

    [request setAccount:account];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([urlResponse statusCode] == 200) {
            NSError *jsonError = nil;
            
            timeline = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [((UITableView*)csView) reloadData];
                STOP_WAIT_VIEW;
                _loading = NO;
            });
        }
    }];
}

-(void)setSearchStr:(NSString*) str
{
    NSString *var;

    if( _loading ) return;

    if( [str isKindOfClass:[NSString class]] )
        var = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    else  if( [str isKindOfClass:[NSNumber class]] )
        var = [(NSNumber*)str stringValue];
    else
        return;

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%@",var]];
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                            requestMethod:SLRequestMethodGET
                                                      URL:url parameters:nil];
    
    START_WAIT_VIEW;
    _loading = YES;

    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if ([urlResponse statusCode] == 200) {
            NSError *jsonError = nil;
            NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
            timeline = tempDic[@"results"];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [((UITableView*)csView) reloadData];
                STOP_WAIT_VIEW;
                _loading = NO;
            });
        }
    }];
}

-(NSString*) getSearchStr
{
    return @"";
}

//===============================================================================
#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
    
    csView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 350)];
    [csView setUserInteractionEnabled:YES];
    accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountTypeTwitter = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

    if([accountTypeTwitter accessGranted] ) {
        // 사용자가 접근을 허용함 
        accounts = [accountStore accountsWithAccountType:accountTypeTwitter];
    } 
    else {
        // 사용자가 접근을 허용하지 않음
        accounts = nil;
    }

    csCode = CS_TWTABLE;
    isUIObj = YES;
    _loading = NO;

    cellHeight = 89.0;

    [((UITableView*)csView) setDelegate:self];
    [((UITableView*)csView) setDataSource:self];

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Account", P_NO, @selector(setAccount:),@selector(getAccount));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Table Cell Height", P_NUM, @selector(setCellHeight:),@selector(getCellHeight));
    NSDictionary *d3 = MAKE_PROPERTY_D(@">Reload Timeline", P_BOOL, @selector(setLoadTimelineAction:),@selector(getLoadTimeline));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Search", P_TXT, @selector(setSearchStr:),@selector(getSearchStr));    
    pListArray = @[xc,yc,d0,d1,d2,d3,d4];

    NSMutableDictionary MAKE_ACTION_D(@"Selected Cell Index", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Selected Username", A_TXT, a2);
    NSMutableDictionary MAKE_ACTION_D(@"Selected Text", A_TXT, a3);
    actionArray = @[a1, a2, a3];

    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if( (self=[super initWithCoder:aDecoder]) ){
        cellHeight = [aDecoder decodeFloatForKey:@"cellHeight"];
        account = [aDecoder decodeObjectForKey:@"account"];
        // HACK. UItableView 가 다시 불러오면 delegate 설정이 전혀 안먹는다.
        // 지우고 다시 생성한 다음 delegate 를 설정해서 사용한다.
        CGRect rect = csView.frame;
        [csView removeFromSuperview];
        
        csView = [[UITableView alloc] initWithFrame:rect];
        [((UITableView*)csView) setDelegate:self];
        [((UITableView*)csView) setDataSource:self];

        accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountTypeTwitter = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        accounts = [accountStore accountsWithAccountType:accountTypeTwitter];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeFloat:cellHeight forKey:@"cellHeight"];
    [encoder encodeObject:account forKey:@"account"];
}

#pragma mark - Table View Delegate

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [timeline count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTableCell *cell;

    cell = [tableView dequeueReusableCellWithIdentifier:@"TwCell"];
    if( nil == cell ){
        cell = [[TTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TwCell"];
    }

    [cell setCellData:timeline[indexPath.row]];

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 선택 사항에 대해서 정해진 액션 동작으로 선택 정보를 알린다.
    SEL act;
    NSNumber *nsMagicNum;
    NSDictionary *data = timeline[indexPath.row];
    
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
    // 2. Selected Username String
    act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:data[@"user"][@"screen_name"]];
            else
                EXCLAMATION;
        }
    }
    // 2. Selected Cell's Text
    act = ((NSValue*)((NSDictionary*)actionArray[2])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[2])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:data[@"text"] ];
            else
                EXCLAMATION;
        }
    }
}

#pragma mark - ActionSheet Delegate

-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"account idx : %d", buttonIndex);
    if( buttonIndex < 0 ) return;

    // 새로 설정된 계정 정보를 저장하고, 타임라인을 다시 갱신한다.
    account = accounts[buttonIndex];
    [self fetchData];
}

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return NO;
}
@end
