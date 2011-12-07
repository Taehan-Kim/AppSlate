//
//  CSGearObject.h
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 Chocolatesoft. All rights reserved.
//

//  Superclass of all gear objects.
//  

#define CS_LABEL        101
#define CS_LAMP         102
#define CS_TEXTFIELD    103

#define LK_CODE         @"linkedmagiccode"
#define LK_NAME         @"linkedname"


#import <Foundation/Foundation.h>

@interface CSGearObject : NSObject
{
    // Gear Code
    NSUInteger csCode;
    // Magic Number Code
    NSUInteger csMagicNum;

    // 좌표
    CGRect  csFrame;

    // 보이는가 아닌가?
    BOOL    csShow;

    // 크기 조절이 가능한가?
    BOOL    csResizable;

    // 설계 화면에 보여질 형태 이미지
    UIImage *csFaceImage;

    // 배경색
    UIColor *csBackColor;

    // 객체간 링크 정보
    NSArray *csLinks;
}

-(NSArray*) getInStringProperties;

-(NSArray*) getInNumberProperties;

-(NSArray*) getOutStringProperties;

-(NSArray*) getOutNumberProperties;

-(NSArray*) actionNames;

@property (nonatomic)   NSUInteger csMagicNum;
@property (nonatomic)   CGRect  csFrame;

// 연결 설정
-(BOOL) setActionName:(NSString*)name to:(NSUInteger)magicNum property:(NSString*)toName;
// 연결 해제
-(BOOL) unlinkActionName:(NSString*)name;
-(BOOL) unlinkActionMCode:(NSNumber*) mCode;

@end
