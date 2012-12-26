//
//  CSLayerViewController.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 6. 21..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSLayerViewController.h"


@implementation CSLayerViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:[UIColor redColor]];
        // Custom initialization
        tvc = [[CSLayerTableViewController alloc] initWithStyle:UITableViewStylePlain];
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:tvc];
        [navCtrl.view setFrame:CGRectMake(0, 0, 320, 480)];
        [self.view addSubview:navCtrl.view];

        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered target:self
                                                                      action:@selector(done:)];
            tvc.navigationItem.leftBarButtonItem = cancel;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) setBlueprintViewController:(UIViewController*)v
{
    [tvc setBlueprintViewController:v];
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}

@end
