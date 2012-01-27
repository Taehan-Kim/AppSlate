//
//  CSGearObject.h
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 Chocolatesoft. All rights reserved.
//

//  Superclass of all gear objects.
//  
#import <Foundation/Foundation.h>

#define CS_LABEL        101
#define CS_MASKEDLABEL  102
#define CS_TEXTFIELD    103
#define CS_BTNTEXTFIELD   104
#define CS_SWITCH       105
#define CS_BUTTON       106
#define CS_TOGGLEBTN    107
#define CS_FLIPCNT      108
#define CS_SLIDER       109


#define MINSIZE         30
#define MINSIZE2        43

#define P_TXT           @"text"
#define P_COLOR         @"color"
#define P_NUM           @"number"
#define P_ALIGN         @"align"
#define P_FONT          @"font"
#define P_BOOL          @"bool"

#define A_TXT           @"textAct"
#define A_NUM           @"numberAct"

#define MAKE_PROPERTY_D(_d1,_d2,_d3,_d4) [[NSDictionary alloc]initWithObjectsAndKeys:_d1,@"name",_d2,@"type",[NSValue valueWithPointer:_d3],@"selector",[NSValue valueWithPointer:_d4],@"getSelector",nil]

#define MAKE_ACTION_D(_d1,_d2,_v) *(_v)=[[NSMutableDictionary alloc] initWithCapacity:4];[_v setObject:(_d1) forKey:@"name"];[_v setObject:_d2 forKey:@"type"];[_v setObject:[NSValue valueWithPointer:nil] forKey:@"selector"];[_v setObject:[NSNumber numberWithInteger:0] forKey:@"mNum"]

@interface CSGearObject : NSObject
{
    // Gear Code
    NSUInteger csCode;
    // Magic Number Code
    NSUInteger csMagicNum;
    // Information
    NSString    *info;

    // 보이는 실체.
    UIView  *csView;

    // 보이는가 아닌가?
    BOOL    csShow;

    // 크기 조절이 가능한가?
    BOOL    csResizable;

    // 설계 화면에 보여질 형태 이미지
    //UIImage *csFaceImage;

    // 배경색
    UIColor *csBackColor;

    // 속성 목록
    NSArray *pListArray;
    // 액션 목록
    NSArray *actionArray;

    UITapGestureRecognizer  *tapGR;

    // iOS API 의 컴포넌트를 그대로 사용하는가에 대한 표식.
    BOOL    isUIObj;
}

-(id) object;

-(NSArray*) getInStringProperties;

-(NSArray*) getInNumberProperties;

-(NSArray*) getOutStringProperties;

-(NSArray*) getOutNumberProperties;

-(NSArray*) getActionList;

-(NSArray*) getPropertiesList;

@property (nonatomic)   NSUInteger csMagicNum;
@property (nonatomic)   BOOL isUIObj;
@property (nonatomic, retain) UIView *csView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSArray *gestureArray;


// 연결 설정
-(BOOL) setActionIndex:(NSUInteger)idx to:(NSUInteger)magicNum selector:(SEL)selectorName;
// 연결 해제
-(BOOL) unlinkActionIndex:(NSUInteger)idx;
-(BOOL) unlinkActionMCode:(NSNumber*) mCode;

-(BOOL) isResizable;

// every getters and setters ...
-(void) setText:(NSString*)txt;
-(NSString*) getText;

-(void) setTextColor:(UIColor*)color;
-(UIColor*) getTextColor;

-(void) setBackgroundColor:(UIColor*)color;
-(UIColor*) getBackgroundColor;

-(void) setFont:(UIFont*)font;
-(UIFont*) getFont;

-(void) setTextAlignment:(UITextAlignment)align;
-(UITextAlignment) getTextAlignment;

@end
