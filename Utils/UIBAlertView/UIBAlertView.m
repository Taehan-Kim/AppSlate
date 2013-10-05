//
//  UIBAlertView.m
//  UIBAlertView
//
//  Created by Stav Ashuri on 1/31/13.
//  Copyright (c) 2013 Stav Ashuri. All rights reserved.
//

#import "UIBAlertView.h"

@interface UIBAlertView() <UIAlertViewDelegate>

@property (strong, nonatomic) UIBAlertView *strongAlertReference;

@property (copy) AlertDismissedHandler activeDismissHandler;

@property (strong, nonatomic) NSString *activeTitle;
@property (strong, nonatomic) NSString *activeMessage;
@property (strong, nonatomic) NSString *activeCancelTitle;
@property (strong, nonatomic) NSString *activeOtherTitles;
@property (strong, nonatomic) UIAlertView *activeAlert;

@end

@implementation UIBAlertView

#pragma mark - Public (Initialization)

- (id)initWithTitle:(NSString *)aTitle message:(NSString *)aMessage cancelButtonTitle:(NSString *)aCancelTitle otherButtonTitles:(NSString *)otherTitles,... {
    self = [super init];
    if (self) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:aTitle message:aMessage delegate:self cancelButtonTitle:aCancelTitle otherButtonTitles:nil];
        if (otherTitles != nil) {
            [alert addButtonWithTitle:otherTitles];
            va_list args;
            va_start(args, otherTitles);
            NSString * title = nil;
            while((title = va_arg(args,NSString*))) {
                [alert addButtonWithTitle:title];
            }
            va_end(args);
        }
        self.activeAlert = alert;
    }
    return self;
}

#pragma mark - Public (Functionality)

- (void)showWithDismissHandler:(AlertDismissedHandler)handler {
    self.activeDismissHandler = handler;
    self.strongAlertReference = self;
    [self.activeAlert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.activeDismissHandler) {
        self.activeDismissHandler(buttonIndex,buttonIndex == 0);
    }
    self.strongAlertReference = nil;
}

@end
