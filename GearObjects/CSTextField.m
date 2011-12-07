//
//  CSTextField.m
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 14..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "CSTextField.h"

@implementation CSTextField

@synthesize text;


-(NSArray*) getInStringProperties
{
    return [NSArray arrayWithObjects:@"setText", nil];
}

-(NSArray*) getOutStringProperties
{
    return [NSArray arrayWithObjects:@"text", nil];
}

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;

    csFrame = CGRectMake(0, 0, 310, 20); // 기본 크기 정하기.

    csCode = CS_TEXTFIELD;

    textColor = [UIColor blackColor];

    textFont = CS_FONT(16);

    csLinks = [[NSArray alloc] initWithObjects:
               [NSMutableDictionary dictionaryWithObjectsAndKeys:
                @"changedText",@"name",
                @"send the text when changed it.",@"desc",
                nil,LK_CODE,
                nil,LK_NAME,nil],
               nil];

    return self;
}

// 액션의 종류들, 링크 정보를 알려준다.
// name: xxxxx    desc:xxxxxx...
// linkedmagiccode:xxxxx linkedname: xxxxx...
//-(NSArray*) actionNames
//{
//    ;
//}

@end
