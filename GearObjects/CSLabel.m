//
//  CSLabel.m
//  AppSlate
//
//  Created by 김태한 on 11. 11. 10..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "CSLabel.h"

@implementation CSLabel

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

    csFrame = CGRectMake(0, 0, 300, 20); // 기본 크기 정하기.

    csCode = CS_LABEL;
    
    textColor = [UIColor blackColor];
    
    textFont = CS_FONT(16);

    return self;
}

@end
