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
 
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tock" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &tockSoundID);
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    AudioServicesDisposeSystemSoundID(tockSoundID);
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUInteger height;
    if( [[destGear getPropertiesList] count] > 7 ) height = 250;
    else height = [[destGear getPropertiesList] count] * 42;

    CGSize size = CGSizeMake(200, height); // size of view in popover
    self.contentSizeForViewInPopover = size;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor grayColor];
}

// UIPopover Controller 의 크기를 조정해주기 위해서 사용하는 팁 같은 코드.
-(void) viewDidAppear:(BOOL)animated
{
    CGSize currentSetSizeForPopover = self.contentSizeForViewInPopover;
    CGSize fakeMomentarySize = CGSizeMake(currentSetSizeForPopover.width - 1.0f, currentSetSizeForPopover.height - 1.0f);
    self.contentSizeForViewInPopover = fakeMomentarySize;
    self.contentSizeForViewInPopover = currentSetSizeForPopover;
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
        cell.textLabel.font = CS_FONT(15);
        cell.textLabel.shadowColor = [UIColor blackColor];
        cell.textLabel.shadowOffset = CGSizeMake(1, 1);
    }
    
    // Configure the cell...
    NSArray *plist = [destGear getPropertiesList];
    NSString *name = (plist[indexPath.row])[@"name"];

    if( [name hasPrefix:@">"] )
        cell.textLabel.text = [name substringFromIndex:1];
    else
        cell.textLabel.text = name;

    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 선택된 프로퍼티에 지정한 액션을 연결하도록 한다.

    // Action's info
    NSMutableDictionary *action_d = [actionGear getActionList][actionIdx];

    // destination property's setter
    NSArray *plist = [destGear getPropertiesList];
    NSValue *selectorValue = (plist[indexPath.row])[@"selector"];

    // setting
    action_d[@"selector"] = selectorValue;
    action_d[@"mNum"] = @(destGear.csMagicNum);

    [UIView animateWithDuration:0.5 animations:^(void){
        // 선택 표시는 다시 풀자.
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    } completion:^(BOOL finished){
        [USERCONTEXT.pop dismissPopoverAnimated:YES];
    }];

    if( [[NSUserDefaults standardUserDefaults] boolForKey:@"SND_SET"] )
        AudioServicesPlaySystemSound(tockSoundID);

    // 액션 연결선 표시를 갱신해주기 위해서 멈춤 메시지를 보낸다. 그러면 갱신되는 효과가 있다.
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_STOP
                                                        object:nil];
}

@end
