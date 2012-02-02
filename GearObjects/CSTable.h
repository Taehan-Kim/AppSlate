//
//  CSTable.h
//  AppSlate
//
//  Created by 김태한 on 12. 01. 27..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSTable : CSGearObject <UITableViewDelegate, UITableViewDataSource>
{
    float cellHieght;
    NSUInteger cellNumber, accessCellIndex;
    NSMutableArray *cellArray;
}

-(id) initGear;

-(void) setCellNumber:(NSNumber*) number;
-(NSNumber*) getCellNumber;

-(void) setAccessIndex:(NSNumber*) number;
-(NSNumber*) getAccessIndex;

-(void) setTextAtAccessIndex:(NSString*)txt;
-(NSString*) getTextAtAccessIndex;

-(void) setSubtextAtAccessIndex:(NSString*)txt;
-(NSString*) getSubtextAtAccessIndex;

-(void) setCellData:(NSDictionary*) dic index:(NSUInteger)idx;
-(id) getCellDataIndex:(NSUInteger)idx;

@end
