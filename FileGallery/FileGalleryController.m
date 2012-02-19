//
//  FileGalleryController.m
//  AppSlate
//
//  Created by 김 태한 on 12. 1. 18..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "FileGalleryController.h"

@interface FileGalleryController ()

@end

@implementation FileGalleryController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        toolbar = nil; bookshelfVC = nil;
        self.view = [[UIView alloc] init];
    }
    return self;
}

- (void)loadView
{
    // Implement loadView to create a view hierarchy programmatically, without using a nib.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return( (interfaceOrientation == UIInterfaceOrientationPortrait) ||
           (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) );
}

-(void) viewWillAppear:(BOOL)animated
{
    if( nil == toolbar ){
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        [toolbar setTintColor:[UIColor darkGrayColor]];

        UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeMe)];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delMode)];

        [toolbar setItems:[NSArray arrayWithObjects:closeBtn,flexible,deleteBtn,nil]];
        [self.view addSubview:toolbar];
    }

    // Bookshelf View Controller
    if( nil == bookshelfVC ){
        bookshelfVC = [[BookshelfViewController alloc] init];
        [bookshelfVC setParentController:self];
        [bookshelfVC.view setFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
        [self.view addSubview:bookshelfVC.view];
    }

    mode = SELECTION;
}

#pragma mark - bar actions

- (void) closeMe
{
    if( SELECTION != mode )
    {
        mode = SELECTION;
        [bookshelfVC setMode:mode];

        UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeMe)];
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(delMode)];
        
        [toolbar setItems:[NSArray arrayWithObjects:closeBtn,flexible,deleteBtn,nil] animated:YES];

        return;
    }

    [self dismissModalViewControllerAnimated:YES];
}

- (void) delMode
{
    mode = DELETING;
    [bookshelfVC setMode:mode];

    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *closeBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeMe)];
    
    [toolbar setItems:[NSArray arrayWithObjects:flexible,closeBtn,nil] animated:YES];
}

@end
