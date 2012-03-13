//
//  CSTable.m
//  AppSlate
//
//  Created by 김태한 on 12. 01. 26..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSTable.h"

@implementation CSTable

-(id) object
{
    return ((UITableView*)csView);
}

//===========================================================================
#pragma mark -

+(void) addCellData:(NSMutableArray*) array count:(NSUInteger)cnt
{
    for( NSUInteger i =0; i < cnt; i++ ){
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Label",@"Text",@"SubText",@"Sub", nil];
        [array addObject:dic]; // 기본 셀 생성.
    }
}

-(void) setCellNumber:(NSNumber*) number
{
    if( [number isKindOfClass:[NSNumber class]] )
        cellNumber = [number integerValue];
    else if( [number isKindOfClass:[NSString class]] )
        cellNumber = [(NSString*)number integerValue];
    else{
        EXCLAMATION;
        return;
    }

    // 새로 변경된 갯수가 이미 있는 셀 데이터 수보다 많은 경우 셀 데이터를 추가로 생성, 추가한다.
    if( [cellArray count] < cellNumber ){
        NSUInteger delta = cellNumber - [cellArray count];
        [CSTable addCellData:cellArray count:delta];
    }
    [((UITableView*)csView) reloadData];
}

-(NSNumber*) getCellNumber
{
    return [NSNumber numberWithInteger:cellNumber];
}

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
    return [NSNumber numberWithFloat:cellHeight];
}

-(void) setAccessIndex:(NSNumber*) number
{
    if( [number isKindOfClass:[NSNumber class]] )
        accessCellIndex = [number integerValue];
    else if( [number isKindOfClass:[NSString class]] )
        accessCellIndex = [(NSString*)number length];
    else{
        EXCLAMATION;
        return;
    }

    // 이미 있는 셀 데이터 수보다 많은 경우 범위를 넘지 못하게 한다.
    if( [cellArray count] <= accessCellIndex ){
        accessCellIndex = [cellArray count]-1;
    }
}

-(NSNumber*) getAccessIndex
{
    return [NSNumber numberWithInteger:accessCellIndex];
}

// 설정되어 있는 집근 인데스에 있는 셀의 텍스트를 설정한다.
-(void) setTextAtAccessIndex:(NSString*)txt
{
    NSMutableDictionary *cellDic = [cellArray objectAtIndex:accessCellIndex];

    if( [txt isKindOfClass:[NSString class]] )
        [cellDic setValue:txt forKey:@"Text"];
    else if([txt isKindOfClass:[NSNumber class]] )
        [cellDic setValue:[((NSNumber*)txt) stringValue] forKey:@"Text"];
    else{
        EXCLAMATION;
        return;
    }

    [((UITableView*)csView) reloadData];
}

// 설정되어 있는 집근 인데스에 있는 셀의 텍스트를 반환한다.
-(NSString*) getTextAtAccessIndex
{
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:accessCellIndex inSection:0];
    return( [((UITableView*)csView) cellForRowAtIndexPath:idxPath].textLabel.text );
}

-(void) setSubtextAtAccessIndex:(NSString*)txt
{
    NSMutableDictionary *cellDic = [cellArray objectAtIndex:accessCellIndex];
    
    if( [txt isKindOfClass:[NSString class]] )
        [cellDic setValue:txt forKey:@"Sub"];
    else if([txt isKindOfClass:[NSNumber class]] )
        [cellDic setValue:[((NSNumber*)txt) stringValue] forKey:@"Sub"];
    else{
        EXCLAMATION;
        return;
    }
    
    [((UITableView*)csView) reloadData];
}

-(NSString*) getSubtextAtAccessIndex
{
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:accessCellIndex inSection:0];
    return( [((UITableView*)csView) cellForRowAtIndexPath:idxPath].detailTextLabel.text );
}

-(void) setCellData:(NSDictionary*) dic index:(NSUInteger)idx
{
    if( idx >= cellNumber ) return;

    [cellArray replaceObjectAtIndex:idx withObject:dic];
    [((UITableView*)csView) reloadData];
}

-(id) getCellDataIndex:(NSUInteger)idx
{
    if( idx >= cellNumber ) return nil;
    return [cellArray objectAtIndex:idx];
}

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;

    csView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 350)];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_TABLE;
    isUIObj = YES;

    cellHeight = 55.0;
    cellNumber = 5;
    accessCellIndex = 0;
    cellArray = [[NSMutableArray alloc] initWithCapacity:40];
    [CSTable addCellData:cellArray count:5]; // 기본 셀 생성.

    [((UITableView*)csView) setDelegate:self];
    [((UITableView*)csView) setDataSource:self];

    self.info = NSLocalizedString(@"Table", @"Table");

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Table Cell Number", P_NUM, @selector(setCellNumber:),@selector(getCellNumber));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Table Cell Height", P_NUM, @selector(setCellHeight:),@selector(getCellHeight));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Access Cell Index", P_NUM, @selector(setAccessIndex:),@selector(getAccessIndex));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Text At Access Index", P_TXT, @selector(setTextAtAccessIndex:),@selector(getTextAtAccessIndex));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"Subtext At Access Index", P_TXT, @selector(setSubtextAtAccessIndex:),@selector(getSubtextAtAccessIndex));
    NSDictionary *d6 = MAKE_PROPERTY_D(@"Table Cell Data", P_CELL, @selector(setCellData:index:),@selector(getCellDataIndex:));

    pListArray = [NSArray arrayWithObjects:xc,yc,d0,d1,d2,d3,d4,d5,d6, nil];

    NSMutableDictionary MAKE_ACTION_D(@"Selected Cell Index", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Selected Cell Text", A_TXT, a2);
    actionArray = [NSArray arrayWithObjects:a1, a2, nil];

    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if( (self=[super initWithCoder:aDecoder]) ){
        cellHeight = [aDecoder decodeFloatForKey:@"cellHeight"];
        cellNumber = [aDecoder decodeIntegerForKey:@"cellNumber"];
        accessCellIndex = [aDecoder decodeIntegerForKey:@"accessCellIndex"];
        cellArray = [aDecoder decodeObjectForKey:@"cellArray"];

        // HACK. UItableView 가 다시 불러오면 delegate 설정이 전혀 안먹는다.
        // 지우고 다시 생성한 다음 delegate 를 설정해서 사용한다.
        CGRect rect = csView.frame;
        [csView removeFromSuperview];
        
        csView = [[UITableView alloc] initWithFrame:rect];
        [((UITableView*)csView) setDelegate:self];
        [((UITableView*)csView) setDataSource:self];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeFloat:cellHeight forKey:@"cellHeight"];
    [encoder encodeInteger:cellNumber forKey:@"cellNumber"];
    [encoder encodeInteger:accessCellIndex forKey:@"accessCellIndex"];
    [encoder encodeObject:cellArray forKey:@"cellArray"];
}

#pragma mark - Gear's Unique Actions

#pragma mark - Table View Delegate

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHeight;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cellArray count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    cell = [tableView dequeueReusableCellWithIdentifier:@"SimpleCell"];
    if( nil == cell ){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SimpleCell"];
    }

    cell.textLabel.text = [((NSDictionary*)[cellArray objectAtIndex:indexPath.row]) objectForKey:@"Text"];
    cell.detailTextLabel.text = [((NSDictionary*)[cellArray objectAtIndex:indexPath.row]) objectForKey:@"Sub"];

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 선택 사항에 대해서 정해진 액션 동작으로 선택 정보를 알린다.
    SEL act;
    NSNumber *nsMagicNum;
    
    // 1. Selected Index
    act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:[NSNumber numberWithInteger:indexPath.row]];
            else
                EXCLAMATION;
        }
    }
    // 2. Selected Cell's String
    act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:1] objectForKey:@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:1]) objectForKey:@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:[((NSDictionary*)[cellArray objectAtIndex:indexPath.row]) objectForKey:@"Text"] ];
            else
                EXCLAMATION;
        }
    }
}

@end
