//
//  BookshelfViewController.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 1. 18..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "BookshelfViewController.h"
#import "FileCell.h"
#import "CSAppDelegate.h"

@interface BookshelfViewController ()

@end

@implementation BookshelfViewController

@synthesize gridView=_gridView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.gridView = [[AQGridView alloc] initWithFrame:CGRectMake(0, 0, 640, 640)];
        self.view = self.gridView;
        self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.gridView.autoresizesSubviews = YES;
        self.gridView.delegate = self;
        self.gridView.dataSource = self;
        mode = SELECTION;
    }
    _imageNames = [[NSMutableArray alloc] initWithCapacity:6];

#ifdef TARGET_IPHONE_SIMULATOR
    documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
#else
    documentsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#endif
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:documentsPath];

    NSString *file;
    while (file = [dirEnum nextObject]) {
        NSDictionary *attr = [dirEnum fileAttributes];
        if( [attr[@"NSFileType"] isEqualToString:NSFileTypeDirectory] ){
            NSLog(@"%@",file);
            [_imageNames addObject:file]; // add name.
        }

        [dirEnum skipDescendants];  // do not recursion.
    }
    return self;
}

- (void)loadView
{
    // Implement loadView to create a view hierarchy programmatically, without using a nib.
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.gridView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return( (interfaceOrientation == UIInterfaceOrientationPortrait) ||
            (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) );
}

// normal mode, delete mode, or another modes...
-(void) setMode:(NSUInteger)md
{
    mode = md;

    [_gridView reloadData];
}

#pragma mark Grid View Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) aGridView
{
    return ( [_imageNames count] );
}

- (AQGridViewCell *) gridView: (AQGridView *) aGridView cellForItemAtIndex: (NSUInteger) index
{
    AQGridViewCell * cell = nil;

    FileCell *plainCell = (FileCell*)[aGridView dequeueReusableCellWithIdentifier:@"PlainCell"];
    if ( plainCell == nil )
    {
        CGFloat widthF = 200.0;

        if( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() )
            widthF = 158.0;
            
        plainCell = [[FileCell alloc] initWithFrame: CGRectMake(0.0, 0.0, widthF, 150.0)
                                                 reuseIdentifier:@"PlainCell"];
        plainCell.selectionGlowColor = [UIColor lightGrayColor];
    }

    plainCell.image = [UIImage imageWithContentsOfFile:[documentsPath stringByAppendingFormat:@"/%@/Face.png",_imageNames[index]]];
    plainCell.title = [_imageNames[index] substringToIndex:[_imageNames[index] length]-4];
    [plainCell showTrash: DELETING == mode ];

    cell = plainCell;

    return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) aGridView
{
    if( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() )
        return ( CGSizeMake(158.0, 160.0) );

    // else, iPad.
    return ( CGSizeMake(224.0, 168.0) );
}

-(void) setParentController:(id) obj
{
    pObj = obj;
}

#pragma mark - GridView Delegate

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index
{
    NSString *fs;
    NSError *error;
    NSLog(@"Icon selected: %d, mode:%d", index, mode);

    switch ( mode ) {
        case SELECTION:
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_FILELOAD
                                                                object:[documentsPath stringByAppendingFormat:@"/%@",_imageNames[index]]];
            [pObj dismissModalViewControllerAnimated:YES];
            break;

        case DELETING:
            fs = [documentsPath stringByAppendingFormat:@"/%@",_imageNames[index]];
            if( [[NSFileManager defaultManager] removeItemAtPath:fs error:&error] )
            {
                NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:documentsPath];
                [_imageNames removeAllObjects];
                NSString *file;
                while (file = [dirEnum nextObject]) {
                    NSDictionary *attr = [dirEnum fileAttributes];
                    if( [attr[@"NSFileType"] isEqualToString:NSFileTypeDirectory] ){
                        NSLog(@"%@",file);
                        [_imageNames addObject:file]; // add name.
                    }
                    
                    [dirEnum skipDescendants];  // do not recursion.
                }

                [self.gridView deleteItemsAtIndices:[NSIndexSet indexSetWithIndex:index]
                                      withAnimation:AQGridViewItemAnimationFade];
            }
            break;

        case SENDING:
            fs = [documentsPath stringByAppendingFormat:@"/%@",_imageNames[index]];

            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            [picker setSubject:@"AppSlate"];
            [picker setMessageBody:@"AppSlate - http://www.facebook.com/AppSlate\n" isHTML:NO];
            NSData *attachData = [[NSData alloc] initWithContentsOfFile:fs];
            [picker addAttachmentData:attachData mimeType:@"application/octet-stream" fileName:_imageNames[index]];
            
            [self presentViewController:picker animated:YES completion:NULL];
            break;
    }
}

#pragma mark -

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
    NSString *message;
//    BOOL goodOrBad = NO;
    
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message = NSLocalizedString(@"Your E-mail has canceled.",@"mail cancel");
			break;
		case MFMailComposeResultSaved:
			message = NSLocalizedString(@"Your E-mail has saved.",@"mal save");
//            goodOrBad = YES;
			break;
		case MFMailComposeResultSent:
			message = NSLocalizedString(@"Your E-mail has sent",@"mail sent");
//            goodOrBad = YES;
			break;
		case MFMailComposeResultFailed:
			message = NSLocalizedString(@"Fail to send the mail.",@"mail fail");
			break;
		default:
			message = NSLocalizedString(@"I Can not send the mail now.",@"mail cant");
			break;
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-Mail"
													message:message
												   delegate:nil cancelButtonTitle:@"Confirm"
										  otherButtonTitles: nil];
	[alert show];	
	
	[controller dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

@end
