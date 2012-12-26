//
//  PaperSetModal.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 2. 4..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "PaperSetModal.h"
#import "CSMainViewController.h"

@implementation PaperSetModal

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
	if ((self = [super initWithFrame:frame]))
    {
		self.headerLabel.text = title;

        // Margin between edge of container frame and panel. Default = 20.0
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            // I am iPad
            self.outerMargin = 200.0f;
            self.cornerRadius = 10.0;
        }
        else {
            // I am iPhone
        }
        // Margin between edge of panel and the content area. Default = 20.0
        self.innerMargin = 10.0f;

        // Border color of the panel. self.borderColor = [UIColor whiteColor]
        // Border width of the panel. Default = 1.5f; self.borderWidth

        // Color of the panel itself. Default = [UIColor colorWithWhite:0.0 alpha:0.8]
//        self.contentColor = [UIColor colorWithRed:(arc4random() % 2) green:(arc4random() % 2) blue:(arc4random() % 2) alpha:1.0];

        // Height of the title view. Default = 40.0f
        [self setTitleBarHeight:30];

        // The background color gradient of the title
//        CGFloat colors[8] = {
//            (arc4random() % 2), (arc4random() % 2), (arc4random() % 2), 1,
//            (arc4random() % 2), (arc4random() % 2), (arc4random() % 2), 1
//        };
//        [[self titleBar] setColorComponents:colors];
        
        // The gradient style (Linear, linear reversed, radial, radial reversed, center highlight). Default = UAGradientBackgroundStyleLinear
        
        // The line mode of the gradient view (top, bottom, both, none). Top is a white line, bottom is a black line.
//        [[self titleBar] setLineMode: pow(2, (arc4random() % 3))];
        // The header label, a UILabel with the same frame as the titleBar
        [self headerLabel].font = [UIFont boldSystemFontOfSize:floor(self.titleBarHeight / 2.0)];

        tbv = [[UITableView alloc] initWithFrame:CGRectMake(0, 31, self.frame.size.width, self.frame.size.height-30) style:UITableViewStylePlain];
        [tbv setDelegate:self];
        [tbv setDataSource:self];
        [tbv setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        [tbv setBackgroundColor:[UIColor clearColor]];
        [tbv setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [tbv setSeparatorColor:[UIColor clearColor]];
        [self.contentView addSubview:tbv];
	}
	return self;
}


- (void)layoutSubviews {
	[super layoutSubviews];

	[tbv setFrame:self.contentView.bounds];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

#pragma mark - Table Delegates

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

-(UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [tView dequeueReusableCellWithIdentifier:@"wallpaperCell"];
    if( nil == cell ){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"wallpaperCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    [cell.contentView setBackgroundColor:(USERCONTEXT.wallpapers)[indexPath.row]];

    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [USERCONTEXT.wallpapers count];
}

- (void)tableView:(UITableView *)tView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *theCell = [tView cellForRowAtIndexPath:indexPath];
    UIView *checkView = [[UIView alloc] initWithFrame:theCell.bounds];
    [checkView setBackgroundColor:[UIColor blackColor]];

    [theCell.contentView addSubview:checkView];
    [UIView animateWithDuration:0.5 animations:^(){
        [checkView setAlpha:0.0];
    } completion:^(BOOL finished){
        [checkView removeFromSuperview];
    }];

    // Wallpaper apply
    [((CSMainViewController*)delegate) setBlueprintColor:(USERCONTEXT.wallpapers)[indexPath.row]];

    // save the index.
    USERCONTEXT.wallpaperIndex = indexPath.row;
}

@end
