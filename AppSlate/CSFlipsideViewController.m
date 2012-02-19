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
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 400.0);

        // 목록에 나타날 부품 항목을 구성한다. 각 항목 하나는 Dictionary 로 되어 있음.
        NSArray  *keys = [[NSArray alloc] initWithObjects:@"name",@"desc",@"icon",@"tag", nil];
        gearList = [[NSArray alloc] initWithObjects:
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Label",@"Simple Text Label", @"gi_label.png", NSNUM(CS_LABEL), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Masked Label",@"Inverse Color Text Label", @"gi_maskedlabel.png", NSNUM(CS_MASKEDLABEL), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Light Bulb",@"Small Bulb", @"gi_bulb.png", NSNUM(CS_BULB), nil] forKeys:keys],                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Flip Counter",@"Flip Animation Number Counter", @"gi_flipcount.png", NSNUM(CS_FLIPCNT), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Text Field",@"User can input some text", @"gi_textfield.png", NSNUM(CS_TEXTFIELD), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Button Text Field",@"Input text filed with button", @"gi_textfieldbtn.png", NSNUM(CS_BTNTEXTFIELD), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Basic Switch",@"On/Off switch", @"gi_switch.png", NSNUM(CS_SWITCH), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Button", @"Basic button", @"gi_button.png", NSNUM(CS_BUTTON), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Toggle Button", @"Toggle push button", @"gi_togglebtn.png", NSNUM(CS_TOGGLEBTN), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Touch Button", @"Touch button", @"gi_none.png", NSNUM(CS_TOUCHBTN), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Slider", @"Horizontal Bar Slider", @"gi_slider.png", NSNUM(CS_SLIDER), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Table", @"Basic Table", @"gi_table.png", NSNUM(CS_TABLE), nil] forKeys:keys],
                    //
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Alert", @"Popup Alert View", @"gi_alert.png", NSNUM(CS_ALERT), nil] forKeys:keys],
                    //
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"NOT", @"Logical NOT Gate", @"gi_not.png", NSNUM(CS_NOT), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"AND", @"Logical AND Gate", @"gi_and.png", NSNUM(CS_AND), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"OR", @"Logical OR Gate", @"gi_or.png", NSNUM(CS_OR), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"XOR", @"Logical Exclusive OR Gate", @"gi_xor.png", NSNUM(CS_XOR), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"NAND", @"Logical NAND Gate", @"gi_none.png", NSNUM(CS_NAND), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"NOR", @"Logical NOR Gate", @"gi_none.png", NSNUM(CS_NOR), nil] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"XNOR", @"Logical Exclusive NOR Gate", @"gi_none.png", NSNUM(CS_XNOR), nil] forKeys:keys],
                    //
                    [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:@"Rectangular", @"Rectangular Decoration", @"gi_rect.png", NSNUM(CS_RECT), nil] forKeys:keys],
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
    [tableView setSeparatorColor:[UIColor lightGrayColor]];
    [tableView reloadData];
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
    UITableViewCell *theCell = [tView cellForRowAtIndexPath:indexPath];
    [theCell setSelected:NO animated:NO];

    // 이 화면은 닫자.
    [self.delegate flipsideViewControllerDidFinish:self];

    // BluePrint 화면에 선택한 놈을 놓자.
    NSMutableDictionary *gearInfo = [NSMutableDictionary dictionaryWithDictionary:[gearList objectAtIndex:indexPath.row]];
    [gearInfo setObject:theCell forKey:@"cell"];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_PUT_GEAR
                                                        object:self
                                                      userInfo:gearInfo
     ];
}

#pragma mark - TableView DataSource

-(UITableViewCell*) tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tView dequeueReusableCellWithIdentifier:@"listCell"];
    if( nil == cell ){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"listCell"];
    }

    NSDictionary *cellDic = [gearList objectAtIndex:indexPath.row];
    [cell.textLabel setText:[cellDic objectForKey:@"name"]];
    [cell.detailTextLabel setText:[cellDic objectForKey:@"desc"]];
    [cell.imageView setImage:[UIImage imageNamed:[cellDic objectForKey:@"icon"]]];

    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [gearList count];
}

@end
