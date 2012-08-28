//
//  CMTextStylePickerViewController.m
//  CMTextStylePicker
//
//  Created by Chris Miles on 18/10/10.
//  Copyright (c) Chris Miles 2010.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "CMTextStylePickerViewController.h"

#import "CMUpDownControl.h"

#define kDisabledCellAlpha		0.4


#pragma mark -
#pragma mark Private Interface

@interface CMTextStylePickerViewController ()
@property (nonatomic, retain)	NSArray		*tableLayout;
@end


#pragma mark -
#pragma mark Implementation

@implementation CMTextStylePickerViewController

@synthesize delegate, defaultSettingsSwitchValue, selectedTextColour, selectedFont;
@synthesize tableLayout, fontSizeControl;
@synthesize sizeCell, colourCell, fontCell, defaultSettingsCell, applyAsDefaultCell, fontNameLabel, defaultSettingsSwitch;
@synthesize colourView, doneButtonItem;

+ (CMTextStylePickerViewController *)textStylePickerViewController {
	CMTextStylePickerViewController *textStylePickerViewController = [[CMTextStylePickerViewController alloc] initWithNibName:@"CMTextStylePickerViewController" bundle:nil];
	return textStylePickerViewController;
}

- (void)notifyDelegateSelectedFontChanged {
	if (delegate && [delegate respondsToSelector:@selector(textStylePickerViewController:userSelectedFont:)]) {
		[delegate textStylePickerViewController:self userSelectedFont:self.selectedFont];
	}
}

- (void)notifyDelegateSelectedTextColorChanged {
	if (delegate && [delegate respondsToSelector:@selector(textStylePickerViewController:userSelectedTextColor:)]) {
		[delegate textStylePickerViewController:self userSelectedTextColor:self.selectedTextColour];
	}
}

- (void)updateFontColourSelections {
	self.fontNameLabel.text = selectedFont.fontName;
	self.fontSizeControl.value = selectedFont.pointSize;
}

- (IBAction)doneAction {
	if (delegate && [delegate respondsToSelector:@selector(textStylePickerViewControllerIsDone:)]) {
		[delegate textStylePickerViewControllerIsDone:self];
	}
}

- (IBAction)fontSizeValueChanged:(CMUpDownControl *)control {
	CGFloat size = (CGFloat)control.value;
	UIFont *textFont = [UIFont fontWithName:self.selectedFont.fontName size:size];
	self.selectedFont = textFont;
	
	[self notifyDelegateSelectedFontChanged];
}


#pragma mark  -
#pragma mark ColourSelectTableViewControllerDelegate methods

//- (void)colourSelectTableViewController:(CMColourSelectTableViewController *)colourSelectTableViewController didSelectColour:(UIColor *)colour {
//	self.selectedTextColour = colour;
//	self.colourView.colour = colour;	// Update the colour swatch
//	[self notifyDelegateSelectedTextColorChanged];
//}


#pragma mark -
#pragma mark FontSelectTableViewControllerDelegate methods

- (void)fontSelectTableViewController:(CMFontSelectTableViewController *)fontSelectTableViewController didSelectFont:(UIFont *)textFont {
	self.selectedFont = textFont;
	self.fontNameLabel.text = [textFont fontName];
	[self notifyDelegateSelectedFontChanged];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Text Style";
		
	self.fontSizeControl.minimumAllowedValue = 8;
	self.fontSizeControl.maximumAllowedValue = 72;
	
	[self updateFontColourSelections];
	
	self.tableLayout = @[@[self.sizeCell,
						 self.fontCell]];
	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		// iPhone UI
		self.navigationItem.rightBarButtonItem = self.doneButtonItem;
	}
	else {
		// iPad UI
		self.contentSizeForViewInPopover = CGSizeMake(320.0, 330.0);
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [tableLayout count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [tableLayout[section] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *cell = tableLayout[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = tableLayout[indexPath.section][indexPath.row];
	return cell.bounds.size.height;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSIndexPath *selectedIndexPath = indexPath;
	UITableViewCell *cell = tableLayout[indexPath.section][indexPath.row];
	
	if (cell == self.sizeCell || cell == self.defaultSettingsCell) {
		// Disable selection of cell
		selectedIndexPath = nil;
	}
	
	return selectedIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = tableLayout[indexPath.section][indexPath.row];
	
	if (cell == self.fontCell) {
		CMFontSelectTableViewController *fontSelectTableViewController = [[CMFontSelectTableViewController alloc] initWithNibName:@"CMFontSelectTableViewController" bundle:nil];
		fontSelectTableViewController.delegate = self;
		fontSelectTableViewController.selectedFont = self.selectedFont;
		[self.parentViewController.navigationController pushViewController:fontSelectTableViewController animated:YES];
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}


@end

