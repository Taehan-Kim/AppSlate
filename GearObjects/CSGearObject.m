//
//  CSGearObject.m
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "CSGearObject.h"

@implementation CSGearObject

@synthesize csMagicNum, csFrame;


// 객체에 전달되어 입력될 수 있는 문자열 자료 연결점에 대한 배열을 외부에 알려준다.
-(NSArray*) getInStringProperties
{
    return nil;
}

// 객체에 전달되어 입력될 수 있는 숫자 자료 연결점에 대한 배열을 외부에 알려준다.
-(NSArray*) getInNumberProperties
{
    return nil;
}

// 객체로부터 외부에 출력될 수 있는 문자열 자료 연결점에 대한 배열을 외부에 알려준다.
-(NSArray*) getOutStringProperties
{
    return nil;
}

// 객체로부터 외부에 출력될 수 있는 숫자 자료 연결점에 대한 배열을 외부에 알려준다.
-(NSArray*) getOutNumberProperties
{
    return nil;
}

-(id) init
{
    if( ![super init] ) return nil;
//[NSDate timeIntervalSinceReferenceDate]
    csMagicNum = rand();

    return self;
}

// 액션의 종류들, 링크 정보를 알려준다.
// name: xxxxx    desc:xxxxxx...
// linkedmagiccode:xxxxx linkedname: xxxxx...
-(NSArray*) actionNames
{
    return nil;
}

// 연결 설정
-(BOOL) setActionName:(NSString*)name to:(NSUInteger)magicNum property:(NSString*)toName
{
    for( NSDictionary *item in csLinks )
    {
        if( [[item objectForKey:@"name"] isEqualToString:name] ){
            [item setValue:NSNUM(magicNum) forKey:LK_CODE];
            [item setValue:toName forKey:LK_NAME];
            return YES;
        }
    }
    return NO;
}

// 연결 해제
-(BOOL) unlinkActionName:(NSString*)name
{
    for( NSDictionary *item in csLinks )
    {
        if( [[item objectForKey:@"name"] isEqualToString:name] ){
            [item setValue:nil forKey:LK_CODE];
            [item setValue:nil forKey:LK_NAME];
            return YES;
        }
    }
    return NO;
}

// 연결 해제
-(BOOL) unlinkActionMCode:(NSNumber*) mCode
{
    for( NSDictionary *item in csLinks )
    {
        if( [[item objectForKey:LK_CODE] isEqualToNumber:mCode] ){
            [item setValue:nil forKey:LK_CODE];
            [item setValue:nil forKey:LK_NAME];
        }
    }
    return YES;
}

@end
