//
//  CSTextAlert.m
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 21..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSTextAlert.h"

@implementation CSTextAlert

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setText:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        message = txt;
    
    else if([txt isKindOfClass:[NSNumber class]] )
        message = [((NSNumber*)txt) stringValue];
}

-(NSString*) getText
{
    return message;
}

-(void) setCancelButtonText:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        btn1 = txt;
    
    else if([txt isKindOfClass:[NSNumber class]] )
        btn1 = [((NSNumber*)txt) stringValue];
}

-(NSString*) getCancelButtonText
{
    return btn1;
}

-(void) setOkButtonText:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        btn2 = txt;
    
    else if([txt isKindOfClass:[NSNumber class]] )
        btn2 = [((NSNumber*)txt) stringValue];
}

-(NSString*) getOkButtonText
{
    return btn2;
}

-(void) setShow:(NSNumber*)BoolValue
{
    UIAlertView *alertView;
    
    // YES 값인 경우만 반응하자.
    if( ![BoolValue isKindOfClass:[NSNumber class]] || NO == [BoolValue boolValue] )
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
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alertView show];
        
        if( nil == txt1 && nil == txt2 ){
            [self performSelector:@selector(closeAlertView:) withObject:alertView afterDelay:3.0];
        }
    }
}

-(NSNumber*) getShow
{
    return [NSNumber numberWithBool:NO];
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_textalert.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_TEXTALERT;
    
    csResizable = NO;
    csShow = NO;
    
    self.info = NSLocalizedString(@"Text Input Alert", @"Text Input Alert");
    
    message = @"Default Message";
    btn1 = @"Cancel";
    btn2 = @"OK";
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Text Message", P_TXT, @selector(setText:),@selector(getText));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Cancel Button Text", P_TXT, @selector(setCancelButtonText:),@selector(getCancelButtonText));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"OK Button Text", P_TXT, @selector(setOkButtonText:),@selector(getOkButtonText));
    NSDictionary *d4 = MAKE_PROPERTY_D(@">Show Action", P_BOOL, @selector(setShow:),@selector(getShow));
    pListArray = [NSArray arrayWithObjects:d1,d2,d3,d4, nil];
    
    NSMutableDictionary MAKE_ACTION_D(@"Commit Text", A_TXT, a1);
    actionArray = [NSArray arrayWithObjects:a1, nil];
    
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
    
    if( 1 != buttonIndex ) return;

    act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:[alertView textFieldAtIndex:0].text];
            else
                EXCLAMATION;
        }
    }
    
}

@end
