//
//  CSAlert.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 16..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSAlert.h"

@implementation CSAlert

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setMessage:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        message = txt;
    
    else if([txt isKindOfClass:[NSNumber class]] )
        message = [((NSNumber*)txt) stringValue];
}

-(NSString*) getMessage
{
    return message;
}

-(void) setButton1Text:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        btn1 = txt;
    
    else if([txt isKindOfClass:[NSNumber class]] )
        btn1 = [((NSNumber*)txt) stringValue];
}

-(NSString*) getButton1Text
{
    return btn1;
}

-(void) setButton2Text:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        btn2 = txt;
    
    else if([txt isKindOfClass:[NSNumber class]] )
        btn2 = [((NSNumber*)txt) stringValue];
}

-(NSString*) getButton2Text
{
    return btn2;
}

-(void) setShowAction:(NSNumber*)BoolValue
{
    UIAlertView *alertView;

    // YES 값인 경우만 반응하자.
    if( ![BoolValue boolValue] )
        return;

    NSString *txt1, *txt2;
    if( 0 == [btn1 length] )txt1 = btn2, txt2 = nil;
    else{ txt1 = btn1, txt2 = btn2;
        if( 0 == [btn2 length] ) txt2 = nil;
    }
    if( 0 == [txt1 length] ) txt1 = nil;

    if( USERCONTEXT.imRunning ){
        alertView = [[UIAlertView alloc] initWithTitle:message message:nil
                                                  delegate:self cancelButtonTitle:nil
                                         otherButtonTitles:txt1, txt2, nil];
        [alertView show];

        if( nil == txt1 && nil == txt2 ){
            [self performSelector:@selector(closeAlertView:) withObject:alertView afterDelay:3.0];
        }
    }
}

-(NSNumber*) getShow
{
    return @NO;
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;

    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_alert.png"]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_ALERT;

    csResizable = NO;
    csShow = NO;

    message = @"Default Message";
    btn1 = @"Button1";
    btn2 = @"Button2";

    NSDictionary *d1 = MAKE_PROPERTY_D(@"Text Message", P_TXT, @selector(setMessage:),@selector(getMessage));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Button #1 Text", P_TXT, @selector(setButton1Text:),@selector(getButton1Text));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Button #2 Text", P_TXT, @selector(setButton2Text:),@selector(getButton2Text));
    NSDictionary *d4 = MAKE_PROPERTY_D(@">Show Action", P_BOOL, @selector(setShowAction:),@selector(getShow));
    pListArray = @[d1,d2,d3,d4];

    NSMutableDictionary MAKE_ACTION_D(@"Closed", A_NUM, a1);
    actionArray = @[a1];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_alert.png"]];
        message = [decoder decodeObjectForKey:@"message"];
        btn1 = [decoder decodeObjectForKey:@"btn1"];
        btn2 = [decoder decodeObjectForKey:@"btn2"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:message forKey:@"message"];
    [encoder encodeObject:btn1 forKey:@"btn1"];
    [encoder encodeObject:btn2 forKey:@"btn2"];
}


#pragma mark - Delegate

-(void) closeAlertView:(id) alertView
{
    [alertView dismissWithClickedButtonIndex:99 animated:YES];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SEL act;
    NSNumber *nsMagicNum;

    [alertView setTitle:@""];
    if( buttonIndex >=2 ) return;

    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:@(buttonIndex)];
            else
                EXCLAMATION;
        }
    }

}

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"UIAlertView";
}

// viewDidLoad 에서 alloc - init 하지 않을 것일때는 NO_FIRST_ALLOC 을 리턴하자.
-(NSString*) customClass
{
    return [NSString stringWithFormat:@"    UIAlertView *%@ = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@\"%@\", @\"%@\", nil];\n",varName,btn1,btn2];
}

-(NSString*) delegateName
{
    return @"UIAlertViewDelegate";
}

-(NSArray*) delegateCodes
{
    SEL act;
    NSNumber *nsMagicNum;

    NSMutableString *code = [NSMutableString stringWithFormat:@"    if([%@ isEqual:alertView]){\n",varName];

    // code 추가. actionArray 에 연결된 CSGearObject 의 메소드를 호출하는 코드 작성 & 삽입.
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;

    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);

        [code appendFormat:@"        [%@ %@@(buttonIndex)];\n",[gObj getVarName],@(sel_name_c)];
    }
    [code appendString:@"    }\n"];


    return @[@"-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex\n{\n",code,@"}\n\n"];
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    if( [apName isEqualToString:@"setShowAction:"] ){
        
        return [NSString stringWithFormat:@"[%@ show];",varName];
    }
    return nil;
}

@end
