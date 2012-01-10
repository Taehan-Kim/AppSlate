//
//  CSGearObject.m
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "CSGearObject.h"

@implementation CSGearObject

@synthesize csMagicNum, csView, tapGR;
@synthesize info;


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
-(NSArray*) getActionList
{
    return nil;
}

// 연결 설정
-(BOOL) setActionIndex:(NSUInteger)idx to:(NSUInteger)magicNum selector:(SEL)selectorName
{
    if( idx >= [actionArray count] ) return NO;

    NSMutableDictionary *item = [actionArray objectAtIndex:idx];

    [item setValue:NSNUM(magicNum) forKey:@"mNum"];
    [item setValue:[NSValue valueWithPointer:selectorName] forKey:@"selector"];

    return YES;
}

// 연결 해제
-(BOOL) unlinkActionIndex:(NSUInteger)idx
{
    if( idx >= [actionArray count] ) return NO;
    
    NSMutableDictionary *item = [actionArray objectAtIndex:idx];

    [item setValue:NSNUM(0) forKey:@"mNum"];
    [item setValue:nil forKey:@"selector"];

    return YES;
}

// 연결 해제
// magic num 에 해당하는 연결을 모두 삭제하므로, 객체를 제거하는 경우 관련 연결을 지울 때 필요하다.
-(BOOL) unlinkActionMCode:(NSNumber*) mCode
{
    for( NSDictionary *item in actionArray )
    {
        if( [[item objectForKey:@"mNum"] isEqualToNumber:mCode] ){
            [item setValue:[NSNumber numberWithInteger:0] forKey:@"mNum"];
            [item setValue:nil forKey:@"selector"];
        }
    }
    return YES;
}

-(NSArray*) getPropertiesList
{
    return nil;
}

@end
