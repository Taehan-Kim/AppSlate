//
//  CSNote.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 3. 20..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSNote.h"

@implementation CSNote

-(id) object
{
    return ((UITextView*)csView);
}

//===========================================================================
#pragma mark -

-(void) setText:(NSString*)txt
{
    if( [txt isKindOfClass:[NSString class]] )
        [((UITextView*)csView) setText:txt];
    
    else if([txt isKindOfClass:[NSNumber class]] )
        [((UITextView*)csView) setText:[((NSNumber*)txt) stringValue]];
}

-(NSString*) getText
{
    return ((UITextView*)csView).text;
}

-(void) setTextColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((UITextView*)csView) setTextColor:color];
}

-(UIColor*) getTextColor
{
    return ((UITextView*)csView).textColor;
}

-(void) setBackgroundColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((UITextView*)csView) setBackgroundColor:color];
}

-(UIColor*) getBackgroundColor
{
    return ((UITextView*)csView).backgroundColor;
}

-(void) setFont:(UIFont*)font
{
    if( [font isKindOfClass:[UIFont class]] )
        [((UITextView*)csView) setFont:font];
}

-(UIFont*) getFont
{
    return ((UITextView*)csView).font;
}

-(void) setSendTextAction:(NSNumber*)BoolValue
{
    if( NO == [BoolValue boolValue] ) return;

    SEL act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
    
    if( nil == act ) return;  // do nothing

    NSNumber *nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
    
    CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
    
    if( nil != gObj ){
        if( [gObj respondsToSelector:act] )
            [gObj performSelector:act withObject:[(UITextView*)csView text]];
        else
            EXCLAMATION;
    }
}

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
    
    csView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 310, 200)];
    [csView setBackgroundColor:[UIColor whiteColor]];
    
    csCode = CS_NOTE;
    isUIObj = YES;

    ((UITextView*)csView).textColor = [UIColor blackColor];
    ((UITextView*)csView).font = CS_FONT(16);
    [(UITextView*)csView setBackgroundColor:CS_RGB(255, 255, 200)];
    [(UITextView*)csView setText:NSLocalizedString(@"Note",@"Note")];
    [(UITextView*)csView setDelegate:self];
    [(UITextView*)csView setUserInteractionEnabled:YES];

    
    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Text", P_TXT, @selector(setText:),@selector(getText));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Text Color", P_COLOR, @selector(setTextColor:),@selector(getTextColor));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Background Color", P_COLOR, @selector(setBackgroundColor:),@selector(getBackgroundColor));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Text Font", P_FONT, @selector(setFont:),@selector(getFont));
    NSDictionary *d5 = MAKE_PROPERTY_D(@">Send Text", P_BOOL, @selector(setSendTextAction:),@selector(getFont));

    pListArray = @[xc,yc,d0,d1,d2,d3,d4,d5];

    NSMutableDictionary MAKE_ACTION_D(@"End Editing", A_TXT, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Send Text", A_TXT, a2);
    actionArray = @[a1, a2];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UITextView*)csView setDelegate:self];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
}


#pragma mark - Gear's Unique Actions

// Enter Text 동작.
-(BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];

    SEL act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    
    if( nil == act ) return YES;  // do nothing
    
    NSNumber *nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
    
    CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
    
    if( nil != gObj ){
        if( [gObj respondsToSelector:act] )
            [gObj performSelector:act withObject:textView.text];
        else
            EXCLAMATION;
    }
    return YES;
}


#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"UITextView";
}

-(NSString*) delegateName
{
    return @"UITextViewDelegate";
}

-(NSArray*) delegateCodes
{
    SEL act;
    NSNumber *nsMagicNum;
    
    NSMutableString *code1 = [NSMutableString stringWithFormat:@"    if([%@ isEqual:textField]){\n",varName];
    
    // code 추가. actionArray 에 연결된 CSGearObject 의 메소드를 호출하는 코드 작성 & 삽입.
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    // [connectedVarName selectorName:@(buttonIndex)];
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        
        [code1 appendFormat:@"        [%@ %@textView.text];\n",[gObj getVarName],@(sel_name_c)];
    }
    [code1 appendString:@"    }\n"];

    return @[@"-(BOOL) textViewShouldEndEditing:(UITextView *)textView\n{\n",code1,@"    return YES;\n}\n\n"];
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    if( [apName isEqualToString:@"setSendTextAction:"] ){
        SEL act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
        NSNumber *nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        return [NSString stringWithFormat:@"[%@ %@:%@.text];",[gObj getVarName], @(sel_getName(act)),varName];
    }
    return nil;
}

@end
