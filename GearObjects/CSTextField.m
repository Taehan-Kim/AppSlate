//
//  CSTextField.m
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 14..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "CSTextField.h"

@implementation CSTextField

-(id) object
{
    return ((UITextField*)csView);
}

//===========================================================================
#pragma mark -

-(void) setText:(NSString*)txt;
{
    [((UITextField*)csView) setText:txt];
}

-(NSString*) getText
{
    return ((UITextField*)csView).text;
}

-(void) setTextColor:(UIColor*)color
{
    [((UITextField*)csView) setTextColor:color];
}

-(UIColor*) getTextColor
{
    return ((UITextField*)csView).textColor;
}

-(void) setBackgroundColor:(UIColor*)color
{
    [((UITextField*)csView) setBackgroundColor:color];
}

-(UIColor*) getBackgroundColor
{
    return ((UITextField*)csView).backgroundColor;
}

-(void) setFont:(UIFont*)font
{
    [((UITextField*)csView) setFont:font];
}
-(UIFont*) getFont
{
    return ((UITextField*)csView).font;
}

-(void) setTextAlignment:(NSNumber*)alignNum
{
    UITextAlignment align = [alignNum integerValue];
    [((UITextField*)csView) setTextAlignment:align];
}

-(NSNumber*) getTextAlignment
{
    return [NSNumber numberWithInteger:((UITextField*)csView).textAlignment];
}

//===========================================================================


-(NSArray*) getInStringProperties
{
    return [NSArray arrayWithObjects:@"setText", nil];
}

-(NSArray*) getOutStringProperties
{
    return [NSArray arrayWithObjects:@"text", nil];
}

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;

    csView = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 310, MINSIZE)];
    [csView setBackgroundColor:[UIColor whiteColor]];

    csCode = CS_TEXTFIELD;

    ((UITextField*)csView).textColor = [UIColor blackColor];
    ((UITextField*)csView).font = CS_FONT(16);
    [(UITextField*)csView setText:NSLocalizedString(@"Text Field",@"Text Field")];
    [(UITextField*)csView setBorderStyle:UITextBorderStyleRoundedRect];
    [(UITextField*)csView setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [(UITextField*)csView setDelegate:self];

    self.info = NSLocalizedString(@"Text Field", @"Text Field");

    NSDictionary *d1 = MAKE_PROPERTY_D(@"Default Text", P_TXT, @selector(setText:),@selector(getText));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Text Color", P_COLOR, @selector(setTextColor:),@selector(getTextColor));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Background Color", P_COLOR, @selector(setBackgroundColor:),@selector(getBackgroundColor));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Text Font", P_FONT, @selector(setFont:),@selector(getFont));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"L/R Alignment", P_ALIGN, @selector(setTextAlignment:),@selector(getTextAlignment));
    
    pListArray = [NSArray arrayWithObjects:d1,d2,d3,d4,d5, nil];

    NSMutableDictionary MAKE_ACTION_D(@"Enter Text", A_TXT, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Close Keyboard", A_TXT, a2);
    actionArray = [NSArray arrayWithObjects:a1, a2, nil];

    return self;
}

// 설정될 수 있는 속성 목록.
-(NSArray*) getPropertiesList
{
    return pListArray;
}

-(NSArray*) getActionList
{
    return actionArray;
}

#pragma mark - Gear's Unique Actions

// Enter Text 동작.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{    
    [textField resignFirstResponder];

    SEL act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
    
    if( nil == act ) return YES;  // do nothing
    
    NSNumber *nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
    
    CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];

    if( nil != gObj )
        [gObj performSelector:act withObject:textField.text];

    return YES;
}


// End Text Editing 동작.
-(void) textFieldDidEndEditing:(UITextField *)textField
{
    SEL act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:1] objectForKey:@"selector"]).pointerValue;
    
    if( nil == act ) return;  // do nothing
    
    NSNumber *nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:1]) objectForKey:@"mNum"];
    
    CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];

    if( nil != gObj )
        [gObj performSelector:act withObject:textField.text];
}

@end
