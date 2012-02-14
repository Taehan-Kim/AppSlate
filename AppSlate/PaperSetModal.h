//
//  PaperSetModal.h
//  AppSlate
//
//  Created by 김태한 on 12. 2. 4..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UATitledModalPanel.h"

@interface PaperSetModal : UATitledModalPanel <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tbv;
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
//- (void)buttonPressed:(id)sender;

@end
