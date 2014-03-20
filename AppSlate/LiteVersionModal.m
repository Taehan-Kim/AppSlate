//
//  LiteVersionModal.m
//  AppSlate
//
//  Created by 김태한 on 2013. 12. 21..
//  Copyright (c) 2013년 ChocolateSoft. All rights reserved.
//

#import "LiteVersionModal.h"
#import "BButton.h"
#import "CSAppDelegate.h"

@implementation LiteVersionModal

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    UILabel *info = [[UILabel alloc] init];
    [info setBackgroundColor:[UIColor clearColor]];
    [info setTextColor:[UIColor lightGrayColor]];
    [info setTextAlignment:NSTextAlignmentCenter];
    [info setNumberOfLines:2];

    BButton *button = [[BButton alloc] init];
    [button setTitle:NSLocalizedString(@"DOWNLOAD NOW", @"download button")];
    [button setBackgroundColor:[UIColor yellowColor]];
    [button setTitleColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(gotoAppStore:)];
    
    if (self) {
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            self.outerMargin = 150.0f;
            self.cornerRadius = 10.0;
            self.innerMargin = 10.0f;
            [self setTitleBarHeight:40];

            [info setFrame:CGRectMake(15, 45, frame.size.width-(outerMargin*2)-40, 46)];
            [info setFont:CS_BOLD_FONT(20)];
        }
        else
        {
            self.outerMargin = 8.0f;
            self.cornerRadius = 10.0;
            self.innerMargin = 0.0;
            [self setTitleBarHeight:20];
            [self.headerLabel setFont:CS_FONT(13)];

            [info setFrame:CGRectMake(10, 30, frame.size.width-32, 30)];
            [info setFont:CS_BOLD_FONT(12)];
        }

        self.headerLabel.text = NSLocalizedString(@"Download AppSlate Full-Version!",@"");
        [self.contentView addSubview:info];
        [info setText:NSLocalizedString(@"You can download many other apps & upload your app on the FULL VERSION.", @"buy comment")];
        
        UIImageView *img;
        
        img = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-121-self.outerMargin*2)/2, 76+(outerMargin/2), 121, 132)];
        [img setImage:[UIImage imageNamed:@"liteVersionModal.png"]];
        [self.contentView addSubview:img];
        
        [button setFrame:CGRectMake(img.frame.origin.x - (img.frame.size.width/2), img.frame.origin.y+140+(outerMargin/2), img.frame.size.width*2, 50)];
        [self.contentView addSubview:button];
    }

    return self;
}

- (void) gotoAppStore:(id)sender
{
    Sv = [[SKStoreProductViewController alloc] init];
    [Sv setDelegate:self];
    START_WAIT_VIEW;
    [Sv loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@"511327336"}
                  completionBlock:^(BOOL result, NSError *error)
     {
         STOP_WAIT_VIEW;
         [((CSAppDelegate*)([UIApplication sharedApplication].delegate)).window.rootViewController presentViewController:Sv animated:YES
              completion:^{
              }];
     }];
}

#pragma mark - SKStoreProductViewControllerDelegate

// SK store view 를 닫는 요구가 들어오면
-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:^{
    } ];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
