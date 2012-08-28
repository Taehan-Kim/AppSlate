//
//  CSLayerTableViewController.m
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 7..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSLayerTableViewController.h"
#import "CSBlueprintController.h"

@implementation CSLayerTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.view = self.tableView;
        self.title = @"Order";

        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(done:)];
        self.navigationItem.leftBarButtonItem = cancel;
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
    [super viewWillAppear:animated];
    [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
    [self.tableView reloadData];
    [self.tableView setEditing:YES];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return( (interfaceOrientation == UIInterfaceOrientationPortrait) ||
           (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) );
}

-(void) setBlueprintViewController:(UIViewController*)vc
{
    bluePaperCtrl = vc;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [USERCONTEXT.gearsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"layerCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    // Configure the cell...
    CSGearObject *tg = (USERCONTEXT.gearsArray)[[USERCONTEXT.gearsArray count]-indexPath.row-1];

    cell.textLabel.text = tg.info;

    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return NO;
//}
//

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [((CSBlueprintController*)bluePaperCtrl) deleteGear:((CSGearObject*)(USERCONTEXT.gearsArray)[[USERCONTEXT.gearsArray count]-indexPath.row-1]).csMagicNum];

        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath
{
    NSUInteger fromIndex = [USERCONTEXT.gearsArray count] - fromIndexPath.row -1;
    NSUInteger toIndex = [USERCONTEXT.gearsArray count] - toIndexPath.row -1;

    if( toIndex == fromIndex ) return;

    CSGearObject *fromObj = (USERCONTEXT.gearsArray)[fromIndex];
    UIView *fromView = [bluePaperCtrl.view subviews][fromIndex];

    if( fromIndex < toIndex )
    {
        [USERCONTEXT.gearsArray insertObject:fromObj
                                     atIndex:toIndex+1];
    }
    else
    {
        [USERCONTEXT.gearsArray insertObject:fromObj
                                     atIndex:toIndex];
    }
    [bluePaperCtrl.view insertSubview:fromView atIndex:toIndex];

    NSLog(@"from %d to %d",fromIndex,toIndex);
    // 껴 들어가는 것이 앞쪽이라면, 인덱스가 하나 증가했을 것이다.
    if( fromIndex > toIndex )
        fromIndex ++;

    [USERCONTEXT.gearsArray removeObjectAtIndex:fromIndex];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 선택 표시는 다시 풀자.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    CSGearObject *gObj = (USERCONTEXT.gearsArray)[indexPath.row];
    
    if( nil != gObj ){
        // do not ues this code.
//        [gObj.csView.layer setBorderColor:[UIColor redColor].CGColor];
//        [gObj.csView.layer setBorderWidth:4.0];
//        [UIView animateWithDuration:0.8 animations:^(){
//            [gObj.csView.layer setBorderWidth:0.0];
//        }];
    }

}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
