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
        cellNumber = [(NSString*)number length];

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

-(void) setAccessIndex:(NSNumber*) number
{
    if( [number isKindOfClass:[NSNumber class]] )
        accessCellIndex = [number integerValue];
    else if( [number isKindOfClass:[NSString class]] )
        accessCellIndex = [(NSString*)number length];

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

    cellHieght = 55.0;
    cellNumber = 5;
    accessCellIndex = 0;
    cellArray = [[NSMutableArray alloc] initWithCapacity:40];
    [CSTable addCellData:cellArray count:5]; // 기본 셀 생성.

    [((UITableView*)csView) setDelegate:self];
    [((UITableView*)csView) setDataSource:self];

    self.info = NSLocalizedString(@"Table", @"Table");

    NSDictionary *d1 = MAKE_PROPERTY_D(@"Table Cell Number", P_NUM, @selector(setCellNumber:),@selector(getCellNumber));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Access Cell Index", P_NUM, @selector(setAccessIndex:),@selector(getAccessIndex));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Text At Access Index", P_TXT, @selector(setTextAtAccessIndex:),@selector(getTextAtAccessIndex));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Subtext At Access Index", P_TXT, @selector(setSubtextAtAccessIndex:),@selector(getSubtextAtAccessIndex));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"Table Cell Data", P_CELL, @selector(setCellData:index:),@selector(getCellDataIndex:));

    pListArray = [NSArray arrayWithObjects:d1,d2,d3,d4,d5, nil];

    NSMutableDictionary MAKE_ACTION_D(@"Selected Cell Index", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Selected Cell Text", A_NUM, a2);
    actionArray = [NSArray arrayWithObjects:a1, a2, nil];

    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if( (self=[super initWithCoder:aDecoder]) ){
        cellHieght = [aDecoder decodeFloatForKey:@"cellHieght"];
        cellNumber = [aDecoder decodeIntegerForKey:@"cellNumber"];
        accessCellIndex = [aDecoder decodeIntegerForKey:@"accessCellIndex"];
        cellArray = [aDecoder decodeObjectForKey:@"cellArray"];

        [((UITableView*)csView) setDelegate:self];
        [((UITableView*)csView) setDataSource:self];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeFloat:cellHieght forKey:@"cellHieght"];
    [encoder encodeInteger:cellNumber forKey:@"cellNumber"];
    [encoder encodeInteger:accessCellIndex forKey:@"accessCellIndex"];
    [encoder encodeObject:cellArray forKey:@"cellArray"];
}

#pragma mark - Gear's Unique Actions

#pragma mark - Table View Delegate

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellHieght;
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
                ; // todo: error handleing
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
                ; // todo: error handleing
        }
    }
}

@end
