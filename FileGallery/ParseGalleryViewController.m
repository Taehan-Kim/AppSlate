//
//  ParseGalleryViewController.m
//  AppSlate
//
//  Created by 김태한 on 13. 5. 26..
//  Copyright (c) 2013년 ChocolateSoft. All rights reserved.
//

#import "ParseGalleryViewController.h"
#import "WorldCell.h"

#define SBAR_H      34.0

@interface ParseGalleryViewController ()
{
    UISearchBar         *searchBar;
}
@end

@implementation ParseGalleryViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Custom initialization
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;

        searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, SBAR_H)];
        [searchBar setTintColor:[UIColor blackColor]];
        [searchBar setPlaceholder:NSLocalizedString(@"Name Search",@"Name Search")];
        [searchBar setDelegate:self];
    }
    [self setTitle:NSLocalizedString(@"Share World",@"s_title")];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    UIBarButtonItem *setItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeMe)];
    [setItem setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = setItem;

    [self.tableView registerClass:[WorldCell class] forCellReuseIdentifier:@"CloudCell" ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closeMe
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"appPkg"];

    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        [query whereKey:@"device" equalTo:@"Pad"];
    else
        [query whereKey:@"device" equalTo:@"Phone"];

    if( nil != searchBar.text && [searchBar.text length] >= 1){
        [query whereKey:@"name" containsString:searchBar.text];
    }

    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    WorldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CloudCell" forIndexPath:indexPath];

    // Configure the cell to show todo item with a priority at the bottom
    [cell setObject:object target:self idx:indexPath];

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *obj = [self objectAtIndexPath:indexPath];

    PFFile *pkg = [obj objectForKey:@"appFile"];

    START_WAIT_VIEW;

    [pkg getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
    {
        STOP_WAIT_VIEW;
    
        if( error ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",@"Error")
                                                            message:NSLocalizedString(@"I can't download now.",@"error msg") delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"Confirm",@"Confirm"), nil];
            [alert show];
            return;
        }

        USERCONTEXT.appName = [obj objectForKey:@"name"];
        
        // I can update to parse.com only for my app.
        PFUser *theUser = [obj objectForKey:@"user"];
        if( [theUser.password isEqualToString:[PFUser currentUser].password] )
            USERCONTEXT.parseId = [obj objectId];
        else
            USERCONTEXT.parseId = nil;
        
        NSLog(@"%@", USERCONTEXT.parseId);
        
        NSNumber *colorIndex = [obj objectForKey:@"wallpaperIdx"];
        USERCONTEXT.wallpaperIndex = [colorIndex integerValue];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_PARSELOAD
                                                            object:data];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    progressBlock:^(int percentDone)
    {
        UPDATE_WAIT_VIEW(percentDone);
    }];
}

-(void) deleteApp:(NSIndexPath*)indexPath
{
    PFObject *obj = [self objectAtIndexPath:indexPath];
    START_WAIT_VIEW;
    [obj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        STOP_WAIT_VIEW;
        [self loadObjects];
    }];
}

#pragma mark -

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return searchBar;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SBAR_H;
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
}

-(void) searchBarTextDidBeginEditing:(UISearchBar *)sBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void) searchBarTextDidEndEditing:(UISearchBar *)sBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)sBar
{
    [self loadObjects];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)sBar
{
    [searchBar resignFirstResponder];
//    isFiltered = NO;
    searchBar.text = @"";
    [self loadObjects];
}

@end
