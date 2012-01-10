//
//  PropertyLinkTVController.m
//  AppSlate
//
//  Created by 김태한 on 12. 1. 7..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <objc/message.h>
#import "PropertyLinkTVController.h"


@implementation PropertyLinkTVController

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
    CGSize size = CGSizeMake(200, 220); // size of view in popover
    self.contentSizeForViewInPopover = size;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor grayColor];
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
// 연결될 대상이 되는 객체를 설정한다.
-(void) setDestinationGear:(CSGearObject*)objD actionGear:(CSGearObject*)objA actionIndex:(NSUInteger)idx
{
    destGear = objD;
    actionGear = objA;
    actionIdx = idx;

    NSLog(@"aG:%@ idx:%d - dG:%@",actionGear.description, actionIdx, destGear.description);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[destGear getPropertiesList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"destCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = CS_FONT(12);
    }
    
    // Configure the cell...
    NSArray *plist = [destGear getPropertiesList];
    cell.textLabel.text = [[plist objectAtIndex:indexPath.row] objectForKey:@"name"];

    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 선택된 프로퍼티에 지정한 액션을 연결하도록 한다.

    // Action's info
    NSMutableDictionary *action_d = [[actionGear getActionList] objectAtIndex:actionIdx];

    // destination property's setter
    NSArray *plist = [destGear getPropertiesList];
    NSValue *selectorValue = [[plist objectAtIndex:indexPath.row] objectForKey:@"selector"];

    // setting
    [action_d setObject:selectorValue forKey:@"selector"];
    [action_d setObject:NSNUM(destGear.csMagicNum) forKey:@"mNum"];

    [UIView animateWithDuration:0.5 animations:^(void){
        // 선택 표시는 다시 풀자.
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } completion:^(BOOL finished){
        [USERCONTEXT.pop dismissPopoverAnimated:YES];
    }];
}

@end
