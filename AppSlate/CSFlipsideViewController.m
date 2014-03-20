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

#define NM  @"name"
#define DE  @"desc"
#define IC  @"icon"
#define TG  @"tag"

@implementation CSFlipsideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.preferredContentSize = CGSizeMake(320.0, 400.0);

        // make up the parts list. one dictionary for one item.
        gearList = @[
                    @{NM:NSLocalizedString(@"Text Label", @"Text Label"), DE:NSLocalizedString(@"Simple Text Label",@"tl_s"), IC:@"gi_label.png", TG:@(CS_LABEL)},
                    @{NM:NSLocalizedString(@"Number Label", @"Number Label"),DE:NSLocalizedString(@"Number/Currency Label",@"nl_s"), IC:@"gi_numLabel.png", TG:@(CS_NUMLABEL)},
                    @{NM:NSLocalizedString(@"Note", @"Note"),DE:NSLocalizedString(@"Text Note",@"tn_s"), IC:@"gi_note.png", TG:@(CS_NOTE)},
                    @{NM:NSLocalizedString(@"Light Bulb", @"Light Bulb"), DE:NSLocalizedString(@"Color light bulb", @"lb_s"), IC:@"gi_bulb.png", TG:@(CS_BULB) },
                    @{NM:NSLocalizedString(@"Flip Counter", @"Flip Counter"),DE:NSLocalizedString(@"Flip animation integer number",@"fc_s"), IC:@"gi_flipcount.png", TG:@(CS_FLIPCNT)},
                    @{NM:NSLocalizedString(@"Text Field", @"Text Field"),DE:NSLocalizedString(@"User can input some text",@"tf_s"), IC:@"gi_textfield.png", TG:@(CS_TEXTFIELD)},
                    @{NM:NSLocalizedString(@"Button Text Field", @"Button Text Field"),DE:NSLocalizedString(@"Input text filed with button",@"tfb_s"),IC:@"gi_textfieldbtn.png", TG:@(CS_BTNTEXTFIELD)},
                    @{NM:NSLocalizedString(@"Basic Switch", @"Basic Switch"),DE:NSLocalizedString(@"On/Off switch",@""), IC:@"gi_switch.png", TG:@(CS_SWITCH)},
                    @{NM:NSLocalizedString(@"Button", @"Button"), DE:NSLocalizedString(@"Basic button",@""),IC:@"gi_button.png", TG:@(CS_BUTTON)},
                    @{NM:NSLocalizedString(@"Toggle Button", @"Toggle Button"), DE:NSLocalizedString(@"Toggle push button",@""), IC:@"gi_togglebtn.png", TG:@(CS_TOGGLEBTN)},
                    @{NM:NSLocalizedString(@"Touch Button", @"Touch Button"), DE:NSLocalizedString(@"On value only when touch status",@""), IC:@"gi_touchbtn.png", TG:@(CS_TOUCHBTN)},
                    @{NM:NSLocalizedString(@"Slider", @"Slider"), DE:NSLocalizedString(@"Horizontal Bar Slider",@""), IC:@"gi_slider.png", TG:@(CS_SLIDER)},
                    @{NM:NSLocalizedString(@"Progress Bar", @"Progress Bar"), DE:NSLocalizedString(@"Horizontal Progress Bar",@""), IC:@"gi_progress.png", TG:@(CS_PROGRESS)},
                    @{NM:NSLocalizedString(@"Table", @"Table"), DE:NSLocalizedString(@"Basic table view",@""), IC:@"gi_table.png", TG:@(CS_TABLE)},
                    @{NM:NSLocalizedString(@"RSS Table", @"RSS Table"), DE:NSLocalizedString(@"RSS Feed table view",@""), IC:@"gi_rsstable.png", TG:@(CS_RSSTABLE)},
                    @{NM:NSLocalizedString(@"Twitter Table", @"Twitter Table"), DE:NSLocalizedString(@"Twitter Timeline table view",@""), IC:@"gi_twtable.png", TG:@(CS_TWTABLE)},
                    @{NM:NSLocalizedString(@"Image", @"Image"), DE:NSLocalizedString(@"Image view & editor",@""), IC:@"gi_image.png", TG:@(CS_IMAGE)},
                    @{NM:NSLocalizedString(@"Web View", @"Web View"), DE:NSLocalizedString(@"Internet Web view",@""), IC:@"gi_webview.png", TG:@(CS_WEBVIEW)},
                    @{NM:NSLocalizedString(@"Map View", @"Map View"), DE:NSLocalizedString(@"Apple Map view",@""), IC:@"gi_mapview.png", TG:@(CS_MAPVIEW)},
                    @{NM:NSLocalizedString(@"Analog Clock", @"Analog Clock"), DE:NSLocalizedString(@"Now time clock, and time editable",@""), IC:@"gi_clock.png", TG:@(CS_CLOCK)},
                    //  -- -- -- -- -- -- -- -- -- -- -- -- --
                    @{NM:NSLocalizedString(@"Alert View", @"Alert View"), DE:NSLocalizedString(@"Popup Alert View",@""), IC:@"gi_alert.png", TG:@(CS_ALERT)},
                    @{NM:NSLocalizedString(@"Text Input Alert", @"Text Input Alert"), DE:NSLocalizedString(@"Popup Alert has Text Field",@""), IC:@"gi_textalert.png", TG:@(CS_TEXTALERT)},
                    @{NM:NSLocalizedString(@"Mail Composer", @"Mail Composer"), DE:NSLocalizedString(@"E-mail Composer View",@""), IC:@"gi_mail.png", TG:@(CS_MAIL)},
                    @{NM:NSLocalizedString(@"Tweet Composer", @"Tweet Composer"), DE:NSLocalizedString(@"Tweet Composer for Twitter",@""), IC:@"gi_tweet.png", TG:@(CS_TWITSEND)},
                    @{NM:NSLocalizedString(@"Facebook Feed", @"Facebook Feed"), DE:NSLocalizedString(@"Composer for Facebook Feed",@""), IC:@"gi_fbook.png", TG:@(CS_FBSEND)},
                    @{NM:NSLocalizedString(@"Weibo Composer", @"Weibo Composer"), DE:NSLocalizedString(@"Composer for Sina Weibo",@""), IC:@"gi_weibo.png", TG:@(CS_WEIBOSEND)},
                    @{NM:NSLocalizedString(@"Photo Album", @"Photo Album"), DE:NSLocalizedString(@"iOS Photo Library",@""), IC:@"gi_album.png", TG:@(CS_ALBUM)},
                    @{NM:NSLocalizedString(@"Camera", @"Camera"), DE:NSLocalizedString(@"iOS Camera for take a photo",@""), IC:@"gi_cam.png", TG:@(CS_CAMERA)},
                    @{NM:NSLocalizedString(@"Tick Signal Generator", @"Tick"), DE:NSLocalizedString(@"Tick Signal Generator", @"Tick sig_"), IC:@"gi_tick.png", TG:@(CS_TICK)},
                    @{NM:NSLocalizedString(@"Now",@""), DE:NSLocalizedString(@"Now Date & Time", @"Date"), IC:@"gi_date.png", TG:@(CS_NOW)},
                    @{NM:NSLocalizedString(@"Random Number Generator", @"RAND"), DE:NSLocalizedString(@"Random Number Generator",@"RAND"), IC:@"gi_rand.png", TG:@(CS_RAND)},
                    @{NM:NSLocalizedString(@"Accelerometer", @"ACLO"), DE:NSLocalizedString(@"Hardware Accelerometer",@""), IC:@"gi_aclo.png", TG:@(CS_ACLOMETER)},
                    @{NM:NSLocalizedString(@"Music Player", @"Music Player"), DE:NSLocalizedString(@"iTunes Music Player",@""), IC:@"gi_play.png", TG:@(CS_PLAY)},
                    @{NM:NSLocalizedString(@"Multi-connect", @"Multi-connect"), DE:NSLocalizedString(@"Nearby text communicate",@""), IC:@"gi_bluetooth.png", TG:@(CS_BTOOTH)},
                    @{NM:NSLocalizedString(@"AppStore View", @"AppStore View"), DE:NSLocalizedString(@"AppStore View", @"AppStore View"), IC:@"gi_store.png", TG:@(CS_STOREVIEW)},
                //  -- -- -- -- -- -- -- -- -- -- -- -- --
                    @{NM:@"NOT", DE:NSLocalizedString(@"Logical NOT", @"Not"), IC:@"gi_not.png", TG:@(CS_NOT)},
                    @{NM:@"AND", DE:NSLocalizedString(@"Logical AND", @"AND"), IC:@"gi_and.png", TG:@(CS_AND)},
                    @{NM:@"OR", DE:NSLocalizedString(@"Logical OR", @"OR"), IC:@"gi_or.png", TG:@(CS_OR)},
                    @{NM:@"XOR", DE:NSLocalizedString(@"Logical Exclusive OR", @"XOR"), IC:@"gi_xor.png", TG:@(CS_XOR)},
                    @{NM:@"NAND", DE:NSLocalizedString(@"Logical NAND", @"NAND"), IC:@"gi_nand.png", TG:@(CS_NAND)},
                    @{NM:@"NOR", DE:NSLocalizedString(@"Logical NOR", @"NOR"), IC:@"gi_nor.png", TG:@(CS_NOR)},
                    @{NM:@"XNOR", DE:NSLocalizedString(@"Logical Exclusive NOR", @"XNOR"), IC:@"gi_xnor.png", TG:@(CS_XNOR)},
                    @{NM:NSLocalizedString(@"Tee", @"Tee"), DE:NSLocalizedString(@"Split input value",@""), IC:@"gi_tee.png", TG:@(CS_TEE)},
                    @{NM:NSLocalizedString(@"Number Compare", @"Num Comp"), DE:NSLocalizedString(@"Number Compare and output result",@""), IC:@"gi_numcomp.png", TG:@(CS_NUMCOMP)},
                    @{NM:NSLocalizedString(@"String Compare", @"Str Comp"), DE:NSLocalizedString(@"String Compare and output result",@""), IC:@"gi_strcomp.png", TG:@(CS_STRCOMP)},
                    @{NM:NSLocalizedString(@"Calculator + - x /", @"calc"), DE:NSLocalizedString(@"Number Calculator",@""), IC:@"gi_calc.png", TG:@(CS_CALC)},
                    @{NM:NSLocalizedString(@"String-Number Converter",@"sc-n conv"), DE:NSLocalizedString(@"Convert string to number", @"ATOF"), IC:@"gi_atof.png", TG:@(CS_ATOF)},
                    @{NM:NSLocalizedString(@"String Linker", @"strcat"), DE:NSLocalizedString(@"Link String to String",@""), IC:@"gi_strcat.png", TG:@(CS_STRCAT)},
                    @{NM:NSLocalizedString(@"ABS and INT function", @"ABS"), DE:NSLocalizedString(@"Convert Number Integer or Absolute val.",@""), IC:@"gi_abs.png", TG:@(CS_ABS)},
                    @{NM:NSLocalizedString(@"Stack Data Structure", @"Stack"), DE:NSLocalizedString(@"First In, Last Out data pocket",@""), IC:@"gi_stack.png", TG:@(CS_STACK)},
                    @{NM:NSLocalizedString(@"Queue Data Structure", @"Queue"), DE:NSLocalizedString(@"First In, First Out data pocket",@""), IC:@"gi_queue.png", TG:@(CS_QUEUE)},
                    @{NM:NSLocalizedString(@"Radian/Degree Converter", @"RadDeg"), DE:NSLocalizedString(@"Convert Radian value to Degree or Deg to Rad.",@""), IC:@"gi_raddeg.png", TG:@(CS_RADDEG)},
                    @{NM:NSLocalizedString(@"Trigonometric Functions", @"Trigonometric"), DE:NSLocalizedString(@"Sine, Cosine, and Tangent function",@""), IC:@"gi_trigono.png", TG:@(CS_TRI)},
                    //
                    @{NM:NSLocalizedString(@"Rectangular", @"Rectangular"), DE:NSLocalizedString(@"Rectangular Decoration",@""), IC:@"gi_rect.png", TG:@(CS_RECT)},
                    @{NM:NSLocalizedString(@"Horizontal Line", @"H Line"), DE:NSLocalizedString(@"Horizontal Line Decoration",@""), IC:@"gi_hline.png", TG:@(CS_LINE_H)},
                    @{NM:NSLocalizedString(@"Vertical Line", @"V Line"), DE:NSLocalizedString(@"Vertical Line Decoration",@""), IC:@"gi_vline.png", TG:@(CS_LINE_V)}
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
        [cell.backgroundView setBackgroundColor:[UIColor whiteColor]];
    }

    NSDictionary *cellDic = gearList[indexPath.row];
    [cell.textLabel setText:cellDic[NM]];
    [cell.detailTextLabel setText:cellDic[DE]];
    [cell.imageView setImage:[UIImage imageNamed:cellDic[IC]]];

    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [gearList count];
}

@end
