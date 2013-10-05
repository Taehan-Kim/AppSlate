//
//  WorldCell.m
//  AppSlate
//
//  Created by Tae Han Kim on 13. 5. 27..
//  Copyright (c) 2013년 ChocolateSoft. All rights reserved.
//

#import "WorldCell.h"
#import "UIBAlertView.h"
#import "ParseGalleryViewController.h"

@interface WorldCell ()
{
    UILabel *dateLbl, *nameLbl, *titleLbl, *detailLbl;
    UIButton *delBtn;
    ParseGalleryViewController *target;
    NSIndexPath *idPath;
}
@end

@implementation WorldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        // Initialization code
        [self.textLabel setBackgroundColor:[UIColor clearColor]];

        titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, self.frame.size.width-70, 25)];
        [titleLbl setFont:[UIFont boldSystemFontOfSize:18]];
        [self.contentView addSubview:titleLbl];

        detailLbl = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, self.frame.size.width-70, 45)];
        [detailLbl setFont:[UIFont systemFontOfSize:13]];
        [detailLbl setTextColor:[UIColor grayColor]];
        [detailLbl setNumberOfLines:3];
        [self.contentView addSubview:detailLbl];

        dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 80, self.frame.size.width/2-8, 10)];
        [dateLbl setFont:[UIFont systemFontOfSize:9.0]];
        [dateLbl setTextColor:[UIColor darkGrayColor]];
        [dateLbl setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:dateLbl];

        nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(titleLbl.frame.origin.x, 80, self.frame.size.width/2-60, 10)];
        [nameLbl setFont:[UIFont systemFontOfSize:9.0]];
        [nameLbl setTextColor:[UIColor blueColor]];
        [self.contentView addSubview:nameLbl];
        
        delBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [delBtn setBackgroundImage:[UIImage imageNamed:@"editbtn_x"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(deleteAppTrigger:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:delBtn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -

- (void) layoutSubviews
{
    [super layoutSubviews];

    [self.imageView setFrame:CGRectMake(5, 5, 60, 90)];
}

- (void) setObject:(PFObject*)obj target:(id)_target idx:(NSIndexPath *)indexPath
{
    [titleLbl setFrame:CGRectMake(75, 0, self.frame.size.width-70, 25)];
    titleLbl.text = [obj objectForKey:@"name"];

    [detailLbl setFrame:CGRectMake(75, 30, self.frame.size.width-70, 45)];
    detailLbl.text = [obj objectForKey:@"description"];
    [detailLbl sizeToFit];

//    [self.imageView setFrame:CGRectMake(5, 5, 60, 90)];
    [self.imageView setFile:[obj objectForKey:@"thumbnail"]];
    [self.imageView loadInBackground];

    [delBtn setHidden:YES];

    PFUser *theUser = [obj objectForKey:@"user"];
    [theUser refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        [nameLbl setFrame:CGRectMake(titleLbl.frame.origin.x, 80, self.frame.size.width/2-60, 10)];
        [nameLbl setText:theUser.username];
        [dateLbl setFrame:CGRectMake(nameLbl.frame.size.width+titleLbl.frame.origin.x, 80, self.frame.size.width-(nameLbl.frame.size.width+titleLbl.frame.origin.x)-10, 10)];

        // Me ?
        if( [theUser.username isEqualToString:[PFUser currentUser].username]
             && [theUser.email isEqualToString:[PFUser currentUser].email] )
            [delBtn setHidden:NO];
    }];

    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateLbl setText:[dFormatter stringFromDate:obj.createdAt]];

    [delBtn setFrame:CGRectMake(self.bounds.size.width - 35, 5, 30, 30)];

    target = _target;
}

-(void) deleteAppTrigger:(id)sender
{
    UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:@"Delete" message:@"Do you want to delete your app?" cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    [alert showWithDismissHandler:^(NSInteger selectedIndex, BOOL didCancel) {
        if (didCancel) {
            NSLog(@"User cancelled");
            return;
        }
        switch (selectedIndex) {
            case 1:
                [target deleteApp:idPath];
                break;
        }
    }];
}

@end
