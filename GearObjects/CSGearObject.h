//
//  CSGearObject.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 11. 11. 9..
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
#define CS_TOUCHBTN     114
#define CS_FLIPCNT      108
#define CS_SLIDER       109
#define CS_TABLE        110
#define CS_RSSTABLE     111
#define CS_TWTABLE      118
#define CS_WEBVIEW      112
#define CS_BULB         113
#define CS_PROGRESS     115
#define CS_IMAGE        116
#define CS_MAPVIEW      117
#define CS_NUMLABEL     119
#define CS_NOTE         120
#define CS_CLOCK        121

#define CS_ALERT        150
#define CS_TEXTALERT    151
#define CS_MAIL         152
#define CS_TWITSEND     153
#define CS_TICK         154
#define CS_RAND         155
#define CS_NOW          156
#define CS_ACLOMETER    157
#define CS_ALBUM        158
#define CS_FBSEND       159
#define CS_PLAY         160
#define CS_CAMERA       161
#define CS_BTOOTH       162
#define CS_WEIBOSEND    163
#define CS_STOREVIEW    164

#define CS_NOT          200
#define CS_AND          201
#define CS_OR           202
#define CS_XOR          203
#define CS_NAND         204
#define CS_NOR          205
#define CS_XNOR         206
#define CS_TEE          207
#define CS_NUMCOMP      208
#define CS_STRCOMP      209
#define CS_CALC         210
#define CS_ATOF         211
#define CS_ABS          212
#define CS_STRCAT       213
#define CS_STACK        214
#define CS_QUEUE        215
#define CS_TRI          216
#define CS_RADDEG       217

#define CS_RECT         300
#define CS_LINE_H       301
#define CS_LINE_V       302


#define MINSIZE         30
#define MINSIZE2        43

#define P_TXT           @"text"
#define P_COLOR         @"color"
#define P_NUM           @"number"
#define P_ALIGN         @"align"
#define P_FONT          @"font"
#define P_BOOL          @"bool"
#define P_CELL          @"cell"
#define P_IMG           @"image"
#define P_NO            @"dont"

#define A_TXT           @"textAct"
#define A_NUM           @"numberAct"
#define A_IMG           @"image"

#define MAKE_PROPERTY_D(_d1,_d2,_d3,_d4) [[NSDictionary alloc]initWithObjectsAndKeys:_d1,@"name",_d2,@"type",[NSValue valueWithPointer:_d3],@"selector",[NSValue valueWithPointer:_d4],@"getSelector",nil]

#define MAKE_ACTION_D(_d1,_d2,_v) *(_v)=[[NSMutableDictionary alloc] initWithCapacity:4];[_v setObject:(_d1) forKey:@"name"];[_v setObject:_d2 forKey:@"type"];[_v setObject:[NSValue valueWithPointer:nil] forKey:@"selector"];[_v setObject:@(0) forKey:@"mNum"]

#define DEFAULT_CENTER_D  NSDictionary*xc=MAKE_PROPERTY_D(@">Center X Position",P_NUM,@selector(setCenterX:),@selector(getCenterX));NSDictionary*yc=MAKE_PROPERTY_D(@">Center Y Position",P_NUM,@selector(setCenterY:),@selector(getCenterY))

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

    // visible thing.
    UIView  *csView;

    // is hidden or not?
    BOOL    csShow;

    // is resizable object?
    BOOL    csResizable;

    // background color
    UIColor *csBackColor;

    // property list
    NSArray *pListArray, *pListTemp;
    // action list
    NSArray *actionArray, *actionTemp;

    UITapGestureRecognizer  *tapGR;

    // is iOS UI object or not
    BOOL    isUIObj;
}

-(id) object;

-(void) makeUpSelectorArray;

-(NSArray*) getActionList;

-(NSArray*) getPropertiesList;

@property (nonatomic)   NSUInteger csMagicNum, csCode;
@property (nonatomic)   BOOL isUIObj;
@property (nonatomic, retain) UIView *csView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSArray *gestureArray;

+(NSArray*) makePListForSave:(NSArray*)list;
+(NSArray*) makePListForUse:(NSArray*)list;
+(NSArray*) makeAListForSave:(NSArray*)list;
+(NSArray*) makeAListForUse:(NSArray*)list;

// set up action connection
-(BOOL) setActionIndex:(NSUInteger)idx to:(NSUInteger)magicNum selector:(SEL)selectorName;
// cancel action connection
-(BOOL) unlinkActionIndex:(NSUInteger)idx;
-(BOOL) unlinkActionMCode:(NSNumber*) mCode;

-(BOOL) isResizable;
-(BOOL) isHiddenGear;

// every getters and setters ...
-(NSNumber*) getCenterX;
-(void) setCenterX:(NSNumber*) xpos;
-(NSNumber*) getCenterY;
-(void) setCenterY:(NSNumber*) ypos;
-(NSNumber*) getAlpha;
-(void) setAlpha:(NSNumber*) alphaValue;

@end
