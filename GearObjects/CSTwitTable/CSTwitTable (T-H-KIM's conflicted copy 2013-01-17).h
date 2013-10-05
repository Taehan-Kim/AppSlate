//
//  CSTwitTable.h
//  AppSlate
//
//  Created by 김태한 on 12. 3. 7..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"
#import <Accounts/ACAccount.h>
#import <Accounts/ACAccountType.h>
#import <Accounts/ACAccountStore.h>

@interface CSTwitTable : CSGearObject <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>
{
    float cellHeight;
    ACAccountStore *accountStore;
    NSArray *accounts;
    BOOL _loading;

    NSArray *timeline;
    ACAccount *account;
}

-(id) initGear;

-(void) setCellHeight:(NSNumber*) number;
-(NSNumber*) getCellHeight;

-(void) setLoadTimeline:(NSNumber*)BoolValue;
-(NSNumber*) getLoadTimeline;

@end
