//
//  CSTable.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 01. 26..
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
    return @(cellNumber);
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
    return @(cellHeight);
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
    return @(accessCellIndex);
}

// 설정되어 있는 집근 인데스에 있는 셀의 텍스트를 설정한다.
-(void) setTextAtAccessIndex:(NSString*)txt
{
    NSMutableDictionary *cellDic = cellArray[accessCellIndex];

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
    NSMutableDictionary *cellDic = cellArray[accessCellIndex];
    
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

    cellArray[idx] = dic;
    [((UITableView*)csView) reloadData];
}

-(id) getCellDataIndex:(NSUInteger)idx
{
    if( idx >= cellNumber ) return nil;
    return cellArray[idx];
}

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;

    csView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 350)];
    [csView setUserInteractionEnabled:YES];
    [(UITableView*)csView registerClass:[UITableViewCell class] forCellReuseIdentifier:[NSString stringWithFormat:@"Cell%d",csMagicNum]];

    csCode = CS_TABLE;
    isUIObj = YES;

    cellHeight = 55.0;
    cellNumber = 5;
    accessCellIndex = 0;
    cellArray = [[NSMutableArray alloc] initWithCapacity:40];
    [CSTable addCellData:cellArray count:5]; // 기본 셀 생성.

    [((UITableView*)csView) setDelegate:self];
    [((UITableView*)csView) setDataSource:self];

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Table Cell Number", P_NUM, @selector(setCellNumber:),@selector(getCellNumber));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Table Cell Height", P_NUM, @selector(setCellHeight:),@selector(getCellHeight));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Access Cell Index", P_NUM, @selector(setAccessIndex:),@selector(getAccessIndex));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Text At Access Index", P_TXT, @selector(setTextAtAccessIndex:),@selector(getTextAtAccessIndex));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"Subtext At Access Index", P_TXT, @selector(setSubtextAtAccessIndex:),@selector(getSubtextAtAccessIndex));
    NSDictionary *d6 = MAKE_PROPERTY_D(@"Table Cell Data", P_CELL, @selector(setCellData:index:),@selector(getCellDataIndex:));

    pListArray = @[xc,yc,d0,d1,d2,d3,d4,d5,d6];

    NSMutableDictionary MAKE_ACTION_D(@"Selected Cell Index", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Selected Cell Text", A_TXT, a2);
    actionArray = @[a1, a2];

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

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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

    cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%d",csMagicNum]];
    if( nil == cell ){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"Cell%d",csMagicNum]];
    }

    [cell.textLabel setBackgroundColor:CSCLEAR];
    [cell.detailTextLabel setBackgroundColor:CSCLEAR];

    cell.textLabel.text = ((NSDictionary*)cellArray[indexPath.row])[@"Text"];
    cell.detailTextLabel.text = ((NSDictionary*)cellArray[indexPath.row])[@"Sub"];

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    // 선택 사항에 대해서 정해진 액션 동작으로 선택 정보를 알린다.
    SEL act;
    NSNumber *nsMagicNum;
    
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
                [gObj performSelector:act withObject:((NSDictionary*)cellArray[indexPath.row])[@"Text"] ];
            else
                EXCLAMATION;
        }
    }
}

#pragma mark - Code Generatorz

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"UITableView";
}

-(NSString*) delegateName
{
    return @"UITableViewDelegate, UITableViewDataSource";
}

-(NSArray*) delegateCodes
{
    SEL act;
    NSNumber *nsMagicNum;

    NSMutableString *code1 = [NSMutableString stringWithFormat:@"    if([%@ isEqual:tableView)\n",varName];
    [code1 appendFormat:@"    return %d;\n",(NSUInteger)cellHeight];

    NSMutableString *code2 = [NSMutableString stringWithFormat:@"    if([%@ isEqual:tableView)\n",varName];
    [code2 appendFormat:@"    return %d;\n",[cellArray count]];

    NSMutableString *code3 = [NSMutableString stringWithFormat:@"    if([%@ isEqual:tableView){\n",varName];
    [code3 appendFormat:@"        cell = [tableView dequeueReusableCellWithIdentifier:@\"%@CellId\" forIndexPath:indexPath];\n",varName];
    [code3 appendString:@"        switch( indexPath.row ) {\n"];
    for( NSUInteger idx = 0; idx < cellArray.count; idx++ ) {
        [code3 appendFormat:@"            case %d:\n",idx];
        [code3 appendFormat:@"                cell.textLabel.text = @\"%@\";\n", ((NSDictionary*)cellArray[idx])[@"Text"]];
        [code3 appendFormat:@"                cell.detailTextLabel.text = @\"%@\";\n", ((NSDictionary*)cellArray[idx])[@"Sub"]];
        [code3 appendString:@"                break;\n"];
    }
    [code3 appendString:@"        }\n    }\n"];


    NSMutableString *code4 = [NSMutableString stringWithFormat:@"    if([%@ isEqual:tableView){\n",varName];

    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        
        [code4 appendFormat:@"        [%@ %@@(indexPath.row)];\n",[gObj getVarName],@(sel_name_c)];
    }
    act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        
        [code4 appendFormat:@"        [%@ %@[tableView cellForRowAtIndexPath:indexPath].textLabel.text];\n",[gObj getVarName],@(sel_name_c)];
    }

    [code4 appendString:@"    }\n"];

    return @[@"-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{\n",code1,@"}\n",
             @"-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{\n",code2,@"}\n",
             @"-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{\n        UITableViewCell *cell;\n",code3,@"    return cell;\n}\n",
             @"-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{\n",code4,@"}\n"];
}

@end
