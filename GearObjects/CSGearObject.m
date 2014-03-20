//
//  CSGearObject.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "CSGearObject.h"
#import <objc/runtime.h>

@implementation CSGearObject

@synthesize csMagicNum, csView, tapGR, gestureArray, csCode;
@synthesize info, isUIObj;


-(id) object
{
    return (csView);
}

-(id) init
{
    if( !(self=[super init]) ) return nil;
//[NSDate timeIntervalSinceReferenceDate]
    self.csMagicNum = arc4random();

    // 기본적으로 크기 조절이 가능하다고 세팅한다.
    csResizable = YES;

    // 기본적으로 존재하지 않는 UI 객체.
    isUIObj = NO;

    // 기본적으로 실행시 보인다.
    csShow = YES;

    actionArray = nil;

    varName = @"_";

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super init]) ) {
        csCode = [decoder decodeIntegerForKey:@"csCode"];
        csMagicNum = [decoder decodeIntegerForKey:@"csMagicNum"];
        info = [decoder decodeObjectForKey:@"info"];
        csView = [decoder decodeObjectForKey:@"csView"];
        csShow = [decoder decodeBoolForKey:@"csShow"];
        csResizable = [decoder decodeBoolForKey:@"csResizable"];
        csBackColor = [decoder decodeObjectForKey:@"csBackColor"];
        actionTemp = [decoder decodeObjectForKey:@"actionArray"];
        pListTemp = [decoder decodeObjectForKey:@"pListArray"];
        isUIObj = [decoder decodeBoolForKey:@"isUIObj"];
        gestureArray = [decoder decodeObjectForKey:@"gestureArray"];
    }
    return self;
}

// initWithCoder 가 호출되고 나서, 나중에 호출되어서 selector array 를 생성해야 한다.
-(void) makeUpSelectorArray
{
    actionArray = [CSGearObject makeAListForUse:actionTemp];
    pListArray = [CSGearObject makePListForUse:pListTemp];
    actionTemp = pListTemp = nil;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:csCode forKey:@"csCode"];
    [encoder encodeInteger:csMagicNum forKey:@"csMagicNum"];
    [encoder encodeObject:info forKey:@"info"];
    [encoder encodeObject:csView forKey:@"csView"];
    [encoder encodeBool:csShow forKey:@"csShow"];
    [encoder encodeBool:csResizable forKey:@"csResizable"];
    [encoder encodeObject:csBackColor forKey:@"csBackColor"];
    [encoder encodeObject:[CSGearObject makeAListForSave:actionArray] forKey:@"actionArray"];
    [encoder encodeObject:[CSGearObject makePListForSave:pListArray] forKey:@"pListArray"];
    [encoder encodeBool:isUIObj forKey:@"isUIObj"];
    [encoder encodeObject:gestureArray forKey:@"gestureArray"];
}

// 저장할 수 있는 프로퍼티 목록을 생성해서 반환한다.
+(NSArray*) makePListForSave:(NSArray*)list
{
    NSMutableArray *theArray = [[NSMutableArray alloc] initWithCapacity:4];

    for( NSDictionary *dic in list )
    {
        const char *sel_name_c = sel_getName([((NSValue*)dic[@"selector"]) pointerValue]);
        const char *getSel_name_c = sel_getName([((NSValue*)dic[@"getSelector"]) pointerValue]);

        NSDictionary *newDic = [NSDictionary dictionaryWithObjectsAndKeys:dic[@"name"],@"name",
                                dic[@"type"],@"type", @(sel_name_c),@"selector",
                                @(getSel_name_c),@"getSelector", nil];
//        @{
//            @"name":dic[@"name"],
//            @"type":dic[@"type"],
//            @"selector":@(sel_name_c),
//            @"getSelector":@(getSel_name_c) };

        [theArray addObject:newDic];
    }

    return theArray;
}

+(NSArray*) makePListForUse:(NSArray*)list
{
    NSMutableArray *theArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    for( NSDictionary *dic in list )
    {
        const char *sel_name_c = [(NSString*)dic[@"selector"] cStringUsingEncoding:NSUTF8StringEncoding];
        const char *getSel_name_c = [(NSString*)dic[@"getSelector"] cStringUsingEncoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                dic[@"name"], @"name",
                                dic[@"type"], @"type",
                                [NSValue valueWithPointer:sel_registerName(sel_name_c)], @"selector",
                                [NSValue valueWithPointer:sel_registerName(getSel_name_c)], @"getSelector", nil];

        [theArray addObject:newDic];
    }
    
    return theArray;
}

+(NSArray*) makeAListForSave:(NSArray*)list
{
    if( nil == list ) return nil;

    NSMutableArray *theArray = [[NSMutableArray alloc] initWithCapacity:3];

    for( NSDictionary *dic in list )
    {
        const char *sel_name_c;
        if( NULL == [((NSValue*)dic[@"selector"]) pointerValue] )
            sel_name_c = "%";
        else
            sel_name_c = sel_getName([((NSValue*)dic[@"selector"]) pointerValue]);

        NSDictionary *newDic = @{
            @"name":dic[@"name"],
            @"type":dic[@"type"],
            @"selector":@(sel_name_c),
            @"mNum":dic[@"mNum"] };

        [theArray addObject:newDic];
    }
    
    return theArray;
}

+(NSArray*) makeAListForUse:(NSArray*)list
{
    if( nil == list ) return nil;
    NSMutableArray *theArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    for( NSDictionary *dic in list )
    {
        NSValue *selValue;
        const char *sel_name_c = [(NSString*)dic[@"selector"] cStringUsingEncoding:NSUTF8StringEncoding];
        if( '%' == *sel_name_c )
            selValue = [NSValue valueWithPointer:NULL];
        else
            selValue = [NSValue valueWithPointer:sel_registerName(sel_name_c)];
        
        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                dic[@"name"], @"name",
                                dic[@"type"], @"type",
                                selValue, @"selector",
                                dic[@"mNum"], @"mNum", nil];
        
        [theArray addObject:newDic];
    }

    return theArray;
}

// property list can be modifyed
-(NSArray*) getPropertiesList
{
    return pListArray;
}

-(NSArray*) getActionList
{
    return actionArray;
}

-(BOOL) isResizable
{
    return csResizable;
}

-(BOOL) isHiddenGear
{
    return !csShow;
}

// action connect
-(BOOL) setActionIndex:(NSUInteger)idx to:(NSUInteger)magicNum selector:(SEL)selectorName
{
    if( idx >= [actionArray count] ) return NO;

    NSMutableDictionary *item = actionArray[idx];

    [item setValue:@(magicNum) forKey:@"mNum"];
    [item setValue:[NSValue valueWithPointer:selectorName] forKey:@"selector"];

    return YES;
}

// cancel connect
-(BOOL) unlinkActionIndex:(NSUInteger)idx
{
    if( idx >= [actionArray count] ) return NO;
    
    NSMutableDictionary *item = actionArray[idx];

    [item setValue:@(0) forKey:@"mNum"];
    [item setValue:nil forKey:@"selector"];

    return YES;
}

// cancel connect
// if some object removed from screen, use this method with the object's magic number.
-(BOOL) unlinkActionMCode:(NSNumber*) mCode
{
    for( NSDictionary *item in actionArray )
    {
        if( [item[@"mNum"] isEqualToNumber:mCode] ){
            [item setValue:@(0) forKey:@"mNum"];
            [item setValue:nil forKey:@"selector"];
        }
    }
    return YES;
}

#pragma mark -

-(NSNumber*) getCenterX
{
    return @(csView.center.x);
}

-(void) setCenterX:(NSNumber*) xpos
{
    if( ![xpos isKindOfClass:[NSNumber class]] ){
        EXCLAMATION; return;
    }

    CGFloat x = [xpos floatValue];

    if( 0 > x || x > [UIApplication sharedApplication].keyWindow.frame.size.width ) return;

    csView.center = CGPointMake(x, csView.center.y);
}

-(NSNumber*) getCenterY
{
    return @(csView.center.y);
}

-(void) setCenterY:(NSNumber*) ypos
{
    if( ![ypos isKindOfClass:[NSNumber class]] ){
        EXCLAMATION; return;
    }

    CGFloat y = [ypos floatValue];
    
    if( 0 > y || y > [UIApplication sharedApplication].keyWindow.frame.size.height ) return;
    
    csView.center = CGPointMake(csView.center.x, y);
}

-(NSNumber*) getAlpha
{
    return @(csView.alpha);
}

-(void) setAlpha:(NSNumber*) alphaValue
{
    if( ![alphaValue isKindOfClass:[NSNumber class]] ){
        EXCLAMATION; return;
    }
    CGFloat a = [alphaValue floatValue];

    if( a < 0 ) a = 0.0;
    else if( a > 1.0 ) a = 1.0;

    [csView setAlpha:a];
}

#pragma mark - for Code Generator

-(NSString*) getVarName
{
    return varName;
}

-(void) setVarName:(NSString *) newName
{
    varName = newName;
    NSLog(@"Cname:%@",newName);
}

// Make a unique var name for using on code
-(BOOL) setDefaultVarName:(NSString *) _name
{
    NSString *newName = [NSString stringWithFormat:@"%@%@",
                         [[_name substringToIndex:2] lowercaseString],
                         [_name substringFromIndex:2] ];

    if( [USERCONTEXT isThereSameVarNameWith:newName] )
    {
        for( NSUInteger n = 1; n < 255; n ++ ){
            if( ![USERCONTEXT isThereSameVarNameWith:[NSString stringWithFormat:@"%@%02X",newName,n]] ) {
                [self setVarName:[NSString stringWithFormat:@"%@%02X",newName,n]];
                return YES;
            }
        }
    }
    
    [self setVarName:newName];

    return YES;
}

// Needs import statements for this feature
-(NSArray*) importLinesCode
{
    return nil;
}

-(NSString*) sdkClassName
{
    return nil;
}

-(NSString*) delegateName
{
    return nil;
}

-(NSArray*) delegateCodes
{
    return nil;
}

-(NSString*) customClass
{
    return nil;
}

-(NSString*) addTargetCode
{
    return nil;
}

-(NSString*) actionCode
{
    return nil;
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString*)val
{
    return nil;
}

@end
