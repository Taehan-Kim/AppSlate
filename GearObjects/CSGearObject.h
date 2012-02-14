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
#define CS_BTNTEXTFIELD 104
#define CS_SWITCH       105
#define CS_BUTTON       106
#define CS_TOGGLEBTN    107
#define CS_FLIPCNT      108
#define CS_SLIDER       109
#define CS_TABLE        110
#define CS_RSSTABLE     111
#define CS_WEBVIEW      112
#define CS_BULB         113

#define CS_ALERT        120

#define CS_NOT          200
#define CS_AND          201
#define CS_OR           202
#define CS_XOR          203

#define CS_RECT         300
#define CS_LINE         301


#define MINSIZE         30
#define MINSIZE2        43

#define P_TXT           @"text"
#define P_COLOR         @"color"
#define P_NUM           @"number"
#define P_ALIGN         @"align"
#define P_FONT          @"font"
#define P_BOOL          @"bool"
#define P_CELL          @"cell"

#define A_TXT           @"textAct"
#define A_NUM           @"numberAct"

#define MAKE_PROPERTY_D(_d1,_d2,_d3,_d4) [[NSDictionary alloc]initWithObjectsAndKeys:_d1,@"name",_d2,@"type",[NSValue valueWithPointer:_d3],@"selector",[NSValue valueWithPointer:_d4],@"getSelector",nil]

#define MAKE_ACTION_D(_d1,_d2,_v) *(_v)=[[NSMutableDictionary alloc] initWithCapacity:4];[_v setObject:(_d1) forKey:@"name"];[_v setObject:_d2 forKey:@"type"];[_v setObject:[NSValue valueWithPointer:nil] forKey:@"selector"];[_v setObject:[NSNumber numberWithInteger:0] forKey:@"mNum"]

#define DEFAULT_CENTER_D  NSDictionary*xc=MAKE_PROPERTY_D(@"Center X Position",P_NUM,@selector(setCenterX:),@selector(getCenterX));NSDictionary*yc=MAKE_PROPERTY_D(@"Center Y Position",P_NUM,@selector(setCenterY:),@selector(getCenterY))

#define ALPHA_D [[NSDictionary alloc]initWithObjectsAndKeys:@"Alpha",@"name",P_NUM,@"type",[NSValue valueWithPointer:@selector(setAlpha:)],@"selector",[NSValue valueWithPointer:@selector(getAlpha)],@"getSelector",nil]

#define EXCLAMATION [[UserContext sharedUserContext] errorTik:self]


@interface CSGearObject : NSObject <NSCoding>
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
    NSArray *pListArray, *pListTemp;
    // 액션 목록
    NSArray *actionArray, *actionTemp;

    UITapGestureRecognizer  *tapGR;

    // iOS API 의 컴포넌트를 그대로 사용하는가에 대한 표식.
    BOOL    isUIObj;
}

-(id) object;

-(void) makeUpSelectorArray;

-(NSArray*) getActionList;

-(NSArray*) getPropertiesList;

@property (nonatomic)   NSUInteger csMagicNum;
@property (nonatomic)   BOOL isUIObj;
@property (nonatomic, retain) UIView *csView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSArray *gestureArray;

+(NSArray*) makePListForSave:(NSArray*)list;
+(NSArray*) makePListForUse:(NSArray*)list;
+(NSArray*) makeAListForSave:(NSArray*)list;
+(NSArray*) makeAListForUse:(NSArray*)list;

// 연결 설정
-(BOOL) setActionIndex:(NSUInteger)idx to:(NSUInteger)magicNum selector:(SEL)selectorName;
// 연결 해제
-(BOOL) unlinkActionIndex:(NSUInteger)idx;
-(BOOL) unlinkActionMCode:(NSNumber*) mCode;

-(BOOL) isResizable;

// every getters and setters ...
-(NSNumber*) getCenterX;
-(void) setCenterX:(NSNumber*) xpos;
-(NSNumber*) getCenterY;
-(void) setCenterY:(NSNumber*) ypos;
-(NSNumber*) getAlpha;
-(void) setAlpha:(NSNumber*) alphaValue;

@end
