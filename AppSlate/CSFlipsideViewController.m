//
//  CSFlipsideViewController.m
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//
//  부품 목록을 테이블로 보여주고, 선택할 수 있게 해주자.

#import "CSFlipsideViewController.h"
#import "CSGearObject.h"

@implementation CSFlipsideViewController

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);

        // 목록에 나타날 부품 항목을 구성한다. 각 항목 하나는 Dictionary 로 되어 있음.
        NSArray  *keys = [[NSArray alloc] initWithObjects:@"name",@"desc",@"icon",@"tag", nil];
        gearList = [[NSArray alloc] initWithObjects:
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Label",@"Simple Text Label", @"li_label.png", NSNUM(CS_LABEL), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Text Field",@"User can input some text", @"li_textfield.png", NSNUM(CS_TEXTFIELD), nil] forKeys:keys],
                    nil];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

//=====================================================================================
// 
#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 선택하였다.
    [[tView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];

    // 이 화면은 닫자.
    [self.delegate flipsideViewControllerDidFinish:self];

    // BluePrint 화면에 선택한 놈을 놓자.
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_PUT_GEAR
                                                        object:self
                                                      userInfo:[gearList objectAtIndex:indexPath.row]
     ];

    // TODO: 선택한 곳에서 설계도 중앙으로 떨어지는 뭐 그런 애니메이션 효과...
}

#pragma mark - TableView DataSource

-(UITableViewCell*) tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tView dequeueReusableCellWithIdentifier:@"listCell"];
    if( nil == cell ){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"listCell"];
    }

    [cell.textLabel setText:[[gearList objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [cell.detailTextLabel setText:[[gearList objectAtIndex:indexPath.row] objectForKey:@"desc"]];

    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [gearList count];
}

@end
