//
//  PropertyTVController.m
//  AppSlate
//
//  Created by 김태한 on 11. 12. 11..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//
#import <objc/message.h>
#import "PropertyTVController.h"
#import "StringSettingViewController.h"
#import "HRColorPickerViewController.h"
#import "FontSettingController.h"
#import "AlignSettingController.h"

@implementation PropertyTVController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Property", @"Prop list");
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    CGSize size = CGSizeMake(320, 480); // size of view in popover
    self.contentSizeForViewInPopover = size;

    // HACK: Gear 가 바뀌어도 이전 정보가 남아있지 못하도록 테이블 셀 뷰를 지운다.
//    NSMutableDictionary *cells = (NSMutableDictionary*)[self.tableView valueForKey:@"_reusableTableCells"];
//    [cells removeAllObjects];

    [self.tableView reloadData];
//    [self.tableView beginUpdates];
//    [self.tableView endUpdates];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma -
// 현재 목록에서 표시할 속성을 가진 객체를 세팅받는다.
-(void) setSelectedGear:(CSGearObject*) obj
{
    theGear = obj;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch( section ){
        case 0:
            return [[theGear getPropertiesList] count];
        case 1:
            return [[theGear getActionList] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;

    // 1. property list
    if( 0 == indexPath.section ){
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        NSArray *plist = [theGear getPropertiesList];
        // Configure the cell...
        cell.textLabel.text = [[plist objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    // 2. action list
    if( 1 == indexPath.section ){
        cell = [tableView dequeueReusableCellWithIdentifier:@"actionCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"actionCell"];
            // 연결하거나, 연결 상태를 알려줄 버튼.
            BButton *btn = [[BButton alloc] initWithFrame:CGRectMake(270,15,30,30)];
            [btn.layer setCornerRadius:9.0];
            [btn addTarget:self action:@selector(unlinkAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn addTarget:self action:@selector(lineAction:) forControlEvents:UIControlEventTouchDown];
            [btn addTarget:self action:@selector(removeLineAction:) forControlEvents:UIControlEventTouchUpOutside];
            [cell.contentView addSubview:btn];
        }
        NSArray *alist = [theGear getActionList];
        NSMutableDictionary *acDic = [alist objectAtIndex:indexPath.row];
    
        cell.textLabel.text = [acDic objectForKey:@"name"];
        BButton *aBtn = [cell.contentView.subviews objectAtIndex:0];

        // 연결 정보
        if( nil != ((NSValue*)[acDic objectForKey:@"selector"]).pointerValue )
        {
            NSString *className, *propertyName;
            NSNumber *nsMagicNum = [acDic objectForKey:@"mNum"];
            for( CSGearObject *g in USERCONTEXT.gearsArray )
            {
                if( g.csMagicNum == nsMagicNum.integerValue ){
                    className = [NSStringFromClass([g class]) substringFromIndex:2];
                    break;
                }
            }

            // selector 이름 앞의 3글자 - 즉 'set' 은 빼고 이름을 정보로 표시해줌.
            propertyName = [NSStringFromSelector(((NSValue*)[acDic objectForKey:@"selector"]).pointerValue) substringFromIndex:3];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ :: %@",className, propertyName];

            [aBtn.layer setBackgroundColor:[UIColor redColor].CGColor];
            [aBtn setTitle:@"✕"];

            [aBtn setTag:indexPath.row];  // tag 에 액션 목록의 인덱스를 기입한다.
        }
        else {
            cell.detailTextLabel.text = nil;
            [aBtn.layer setBackgroundColor:[UIColor grayColor].CGColor];
            [aBtn setTitle:@""];

            [aBtn setTag:NSIntegerMax]; // NSIntegerMax 를 없는 숫자로 사용하자.
        }
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"Property",@"Property");
        case 1:
            return NSLocalizedString(@"Action",@"Action");
        default:
            break;
    }
    return nil;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( 0 == indexPath.section )
        return 46.0;

    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [[theGear getPropertiesList] objectAtIndex:indexPath.row];
    UIViewController *VC = nil;

    // 선택 표시는 다시 풀자.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if( 0 == indexPath.section ) // ----------------------------------------------------------------
    {
        // Navigation logic may go here. Create and push another view controller.
        if( [[info objectForKey:@"type"] isEqualToString:P_TXT] )
        {
            VC = [[StringSettingViewController alloc] initWithGear:theGear propertyInfo:info];
        }
        else if( [[info objectForKey:@"type"] isEqualToString:P_COLOR] )
        {
            UIColor *myColor = objc_msgSend(theGear, [[info objectForKey:@"getSelector"] pointerValue]);
            VC = [HRColorPickerViewController cancelableColorPickerViewControllerWithColor:myColor];
            [(SettingViewCommon*)VC setGearValue:theGear propertyInfo:info];
        }
        else if( [[info objectForKey:@"type"] isEqualToString:P_FONT] )
        {
            VC = [[FontSettingController alloc] initWithGear:theGear propertyInfo:info];
        }
        else if( [[info objectForKey:@"type"] isEqualToString:P_ALIGN] )
        {
            VC = [[AlignSettingController alloc] initWithGear:theGear propertyInfo:info];
        }
        
        if( nil == VC ) return;

        NSLog(@"p name:%@", [info objectForKey:@"name"] );

        [self.navigationController pushViewController:VC animated:YES];
    }
    else if( 1 == indexPath.section ) // ------------------------------------------------------------
    {
        // Blueprint 로 링크 시작에 필요한 정보를 주고, 연결 동작을 시작시키자.
        NSMutableDictionary *gearInfo = [[NSMutableDictionary alloc] initWithCapacity:2];
        [gearInfo setObject:theGear forKey:@"theGear"];
        [gearInfo setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"theActionIndex"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_ACTION_LINK
                                                            object:self
                                                          userInfo:gearInfo];
    }
}

#pragma mark - unlink button Action

-(void) unlinkAction:(id)sender
{
    UIAlertView *alert;

    // 연결되지 않은 액션 항목이다. 버튼은 동작하지 않는다.
    if( NSIntegerMax == ((UIButton*)sender).tag ) return;

    alert = [[UIAlertView alloc] initWithTitle:@""
                                       message:@"Unlink the Action" delegate:self
                             cancelButtonTitle:@"Cancel"
                             otherButtonTitles:@"Confirm", nil];
    [alert setTag:((UIButton*)sender).tag];
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // unlink the action
    NSArray *alist = [theGear getActionList];
    NSMutableDictionary *acDic = [alist objectAtIndex:alertView.tag];

    NSNumber *nsMagicNum = [acDic objectForKey:@"mNum"];
    for( CSGearObject *g in USERCONTEXT.gearsArray )
    {
        if( g.csMagicNum == nsMagicNum.integerValue ){
            [g.csView.layer setBorderColor:[UIColor clearColor].CGColor];
            [g.csView.layer setBorderWidth:0.0];
            break;
        }
    }

    if( 0 == buttonIndex ) return;  // cancel

    [acDic setObject:[NSValue valueWithPointer:nil] forKey:@"selector"];
    [acDic setObject:[NSNumber numberWithInteger:0] forKey:@"mNum"];

    [self.tableView reloadData];
}

-(void) lineAction:(id)sender
{
    // 연결되지 않은 액션 항목이다. 버튼은 동작하지 않는다.
    if( NSIntegerMax == ((UIButton*)sender).tag ) return;

    NSArray *alist = [theGear getActionList];
    NSMutableDictionary *acDic = [alist objectAtIndex:((UIButton*)sender).tag];

    NSNumber *nsMagicNum = [acDic objectForKey:@"mNum"];
    for( CSGearObject *g in USERCONTEXT.gearsArray )
    {
        if( g.csMagicNum == nsMagicNum.integerValue ){
            [g.csView.layer setBorderColor:[UIColor redColor].CGColor];
            [g.csView.layer setBorderWidth:4.0];
            break;
        }
    }
}

-(void) removeLineAction:(id)sender
{
    NSArray *alist = [theGear getActionList];
    NSMutableDictionary *acDic = [alist objectAtIndex:((UIButton*)sender).tag];
    
    NSNumber *nsMagicNum = [acDic objectForKey:@"mNum"];
    for( CSGearObject *g in USERCONTEXT.gearsArray )
    {
        if( g.csMagicNum == nsMagicNum.integerValue ){
            [g.csView.layer setBorderColor:[UIColor clearColor].CGColor];
            [g.csView.layer setBorderWidth:0.0];
            break;
        }
    }
}

@end
