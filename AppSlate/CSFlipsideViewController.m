//
//  CSFlipsideViewController.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//
//  부품 목록을 테이블로 보여주고, 선택할 수 있게 해주자.

#import "CSFlipsideViewController.h"
#import "CSGearObject.h"

@implementation CSFlipsideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 400.0);

        // make up the parts list. one dictionary for one item.
        NSArray  *keys = @[@"name",@"desc",@"icon",@"tag"];
        gearList = @[
                    [[NSDictionary alloc] initWithObjects: @[@"Label",@"Simple Text Label", @"gi_label.png", @(CS_LABEL)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Number Label",@"Number/Currency Label", @"gi_numLabel.png", @(CS_NUMLABEL)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Note",@"Text Note - with Evernote backup feature", @"gi_note.png", @(CS_NOTE)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Light Bulb",@"Small bulb which changeable color", @"gi_bulb.png", @(CS_BULB)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Flip Counter",@"Flip animation integer number", @"gi_flipcount.png", @(CS_FLIPCNT)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Text Field",@"User can input some text", @"gi_textfield.png", @(CS_TEXTFIELD)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Button Text Field",@"Input text filed with button", @"gi_textfieldbtn.png", @(CS_BTNTEXTFIELD)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Basic Switch",@"On/Off switch", @"gi_switch.png", @(CS_SWITCH)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Button", @"Basic button", @"gi_button.png", @(CS_BUTTON)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Toggle Button", @"Toggle push button", @"gi_togglebtn.png", @(CS_TOGGLEBTN)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Touch Button", @"On value only when touch status", @"gi_touchbtn.png", @(CS_TOUCHBTN)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Slider", @"Horizontal Bar Slider", @"gi_slider.png", @(CS_SLIDER)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Progress Bar", @"Horizontal Progress Bar", @"gi_progress.png", @(CS_PROGRESS)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Table", @"Basic table view", @"gi_table.png", @(CS_TABLE)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"RSS Table", @"RSS Feed table view", @"gi_rsstable.png", @(CS_RSSTABLE)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Twitter Table", @"Twitter Timeline table view", @"gi_twtable.png", @(CS_TWTABLE)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Image", @"Image view & editor", @"gi_image.png", @(CS_IMAGE)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Web View", @"Internet Web view", @"gi_webview.png", @(CS_WEBVIEW)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Map View", @"Google Map view", @"gi_mapview.png", @(CS_MAPVIEW)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Analog Clock", @"Now time clock, and time editable", @"gi_clock.png", @(CS_CLOCK)] forKeys:keys],
                    //  -- -- -- -- -- -- -- -- -- -- -- -- --
                    [[NSDictionary alloc] initWithObjects:@[@"Alert", @"Popup Alert View", @"gi_alert.png", @(CS_ALERT)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Text Input Alert", @"Popup Alert has Text Field", @"gi_textalert.png", @(CS_TEXTALERT)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"E-Mail Composer", @"E-mail Composer View", @"gi_mail.png", @(CS_MAIL)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Tweet Composer", @"Tweet Composer for Twitter", @"gi_tweet.png", @(CS_TWITSEND)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Facebook Feed", @"Facebook Feed Dialog", @"gi_fbook.png", @(CS_FBSEND)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Photo Album", @"iOS Photo Library", @"gi_album.png", @(CS_ALBUM)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Camera", @"iOS Camera for take a photo", @"gi_cam.png", @(CS_CAMERA)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Tick Generator", @"Tick Signal Generator", @"gi_tick.png", @(CS_TICK)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Now", @"Now Date & Time Value", @"gi_date.png", @(CS_NOW)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Random Number Generator", @"Random number generator", @"gi_rand.png", @(CS_RAND)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Accelerometer", @"Hardware Accelerometer", @"gi_aclo.png", @(CS_ACLOMETER)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Music Player", @"iTunes Music Player", @"gi_play.png", @(CS_PLAY)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Bluetooth P2P", @"Peer to peer  data communicate", @"gi_bluetooth.png", @(CS_BTOOTH)] forKeys:keys],
                //  -- -- -- -- -- -- -- -- -- -- -- -- --
                    [[NSDictionary alloc] initWithObjects:@[@"NOT", @"Logical NOT Gate", @"gi_not.png", @(CS_NOT)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"AND", @"Logical AND Gate", @"gi_and.png", @(CS_AND)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"OR", @"Logical OR Gate", @"gi_or.png", @(CS_OR)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"XOR", @"Logical Exclusive OR Gate", @"gi_xor.png", @(CS_XOR)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"NAND", @"Logical NAND Gate", @"gi_nand.png", @(CS_NAND)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"NOR", @"Logical NOR Gate", @"gi_nor.png", @(CS_NOR)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"XNOR", @"Logical Exclusive NOR Gate", @"gi_xnor.png", @(CS_XNOR)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Tee", @"Split input value", @"gi_tee.png", @(CS_TEE)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Number Compare", @"Number Compare and output result", @"gi_numcomp.png", @(CS_NUMCOMP)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"String Compare", @"String Compare and output result", @"gi_strcomp.png", @(CS_STRCOMP)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Calculator", @"Number Calculator", @"gi_calc.png", @(CS_CALC)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"String-Number Converter", @"Convert String to Number", @"gi_atof.png", @(CS_ATOF)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"String Concatenator", @"Link String to String", @"gi_strcat.png", @(CS_STRCAT)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"INT , ABS Function", @"Convert Number Integer or Absolute val.", @"gi_abs.png", @(CS_ABS)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Stack", @"First In, Last Out data pocket", @"gi_stack.png", @(CS_STACK)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Queue", @"First In, First Out data pocket", @"gi_queue.png", @(CS_QUEUE)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Radian/Degree Converter", @"Convert Radian value to Degree or Deg to Rad.", @"gi_raddeg.png", @(CS_RADDEG)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Trigonometric Functions", @"Sine, Cosine, and Tangent function", @"gi_trigono.png", @(CS_TRI)] forKeys:keys],
                    //
                    [[NSDictionary alloc] initWithObjects:@[@"Rectangular", @"Rectangular Decoration", @"gi_rect.png", @(CS_RECT)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects:@[@"Horizontal Line", @"Horizontal Line Decoration", @"gi_hline.png", @(CS_LINE_H)] forKeys:keys],
                    [[NSDictionary alloc] initWithObjects: @[@"Vertical Line", @"Vertical Line Decoration", @"gi_vline.png", @(CS_LINE_V)] forKeys:keys]
        ];
        
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
    [_delegate flipsideViewControllerDidFinish:self];
}

//=====================================================================================
// 
#pragma mark - TableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62.0;
}

- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 선택하였다.
    UITableViewCell *theCell = [tView cellForRowAtIndexPath:indexPath];
    [theCell setSelected:NO animated:NO];

    // 이 화면은 닫자.
    [_delegate flipsideViewControllerDidFinish:self];

    // BluePrint 화면에 선택한 놈을 놓자.
    NSMutableDictionary *gearInfo = [NSMutableDictionary dictionaryWithDictionary:gearList[indexPath.row]];
    gearInfo[@"cell"] = theCell;
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

    NSDictionary *cellDic = gearList[indexPath.row];
    [cell.textLabel setText:cellDic[@"name"]];
    [cell.detailTextLabel setText:cellDic[@"desc"]];
    [cell.imageView setImage:[UIImage imageNamed:cellDic[@"icon"]]];

    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [gearList count];
}

@end
