//
//  CSToggleButton.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 01. 20..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSToggleButton.h"

@implementation CSToggleButton

-(id) object
{
    return ((BButton*)csView);
}

//===========================================================================
#pragma mark -

-(void) setOnTintColor:(UIColor*)color
{
    onColor = color;

    if( toggleValue && [color isKindOfClass:[UIColor class]] )
        [((BButton*)csView) setBackgroundColor:color];
}

-(UIColor*) getOnTintColor
{
    return onColor;
}

-(void) setOffTintColor:(UIColor*)color
{
    offColor = color;

    if( !toggleValue && [color isKindOfClass:[UIColor class]] )
        [((BButton*)csView) setBackgroundColor:color];
}

-(UIColor*) getOffTintColor
{
    return offColor;
}

-(void) setOnText:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        onText = txt;
    else if([txt isKindOfClass:[NSNumber class]] )
        onText = [((NSNumber*)txt) stringValue];

    if( toggleValue )
        [((BButton*)csView) setTitle:onText];
}

-(NSString*) getOnText
{
    return onText;
}

-(void) setOnValue:(NSNumber*) number
{
    if( [number isKindOfClass:[NSNumber class]] )
        outputOn = [number floatValue];
    else if( [number isKindOfClass:[NSString class]] )
        outputOn = [(NSString*)number length];
    else
        EXCLAMATION;
}

-(NSNumber*) getOnValue
{
    return @(outputOn);
}

-(void) setOffText:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        offText = txt;
    else if([txt isKindOfClass:[NSNumber class]] )
        offText = [((NSNumber*)txt) stringValue];

    if( !toggleValue )
        [((BButton*)csView) setTitle:offText];
}

-(NSString*) getOffText
{
    return offText;
}

-(void) setOffValue:(NSNumber*) number
{
    if( [number isKindOfClass:[NSNumber class]] )
        outputOff = [number floatValue];
    else if( [number isKindOfClass:[NSString class]] )
        outputOff = [(NSString*)number length];
    else
        EXCLAMATION;
}

-(NSNumber*) getOffValue
{
    return @(outputOff);
}

-(void) setTextColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((BButton*)csView) setTitleColor:color];
}

-(UIColor*) getTextColor
{
    return ((BButton*)csView).btn.titleLabel.textColor;
}

-(void) setFont:(UIFont*)font
{
    if( [font isKindOfClass:[UIFont class]] )
        [((BButton*)csView).btn.titleLabel setFont:font];
}

-(UIFont*) getFont
{
    return ((BButton*)csView).btn.titleLabel.font;
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;

    csView = [[BButton alloc] initWithFrame:CGRectMake(0, 0, 100, MINSIZE2)];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_BUTTON;
    toggleValue = NO;
    onColor = [UIColor blueColor];
    offColor = [UIColor grayColor];
    onText = @"Button On";
    offText = @"Button Off";
    outputOn = 1.0;
    outputOff = 0.0;

    [((BButton*)csView) setTitle:onText];
    [(BButton*)csView addTarget:self action:@selector(pushAction:)];

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"On Tint Color", P_COLOR, @selector(setOnTintColor:),@selector(getOnTintColor));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Off Tint Color", P_COLOR, @selector(setOffTintColor:),@selector(getOffTintColor));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Button On Text", P_TXT, @selector(setOnText:),@selector(getOnText));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"On Output Value", P_NUM, @selector(setOnValue:),@selector(getOnValue));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"Button Off Text", P_TXT, @selector(setOffText:),@selector(getOffText));
    NSDictionary *d6 = MAKE_PROPERTY_D(@"Off Output Value", P_NUM, @selector(setOffValue:),@selector(getOffValue));
    NSDictionary *d7 = MAKE_PROPERTY_D(@"Text Color", P_COLOR, @selector(setTextColor:),@selector(getTextColor));
    NSDictionary *d8 = MAKE_PROPERTY_D(@"Text Font", P_FONT, @selector(setFont:),@selector(getFont));

    pListArray = @[xc,yc,d0,d1,d2,d3,d4,d5,d6,d7,d8];

    NSMutableDictionary MAKE_ACTION_D(@"Button On", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Button Off", A_NUM, a2);
    NSMutableDictionary MAKE_ACTION_D(@"Changed", A_NUM, a3);
    actionArray = @[a1,a2,a3];

    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if( (self=[super initWithCoder:aDecoder]) ){
        toggleValue = [aDecoder decodeBoolForKey:@"toggleValue"];
        onColor = [aDecoder decodeObjectForKey:@"onColor"];
        offColor = [aDecoder decodeObjectForKey:@"offColor"];
        onText = [aDecoder decodeObjectForKey:@"onText"];
        offText = [aDecoder decodeObjectForKey:@"offText"];
        [(BButton*)csView addTarget:self action:@selector(pushAction:)];
        outputOn = [aDecoder decodeFloatForKey:@"outputOn"];
        outputOff = [aDecoder decodeFloatForKey:@"outputOff"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeBool:toggleValue forKey:@"toggleValue"];
    [encoder encodeObject:onColor forKey:@"onColor"];
    [encoder encodeObject:offColor forKey:@"offColor"];
    [encoder encodeObject:onText forKey:@"onText"];
    [encoder encodeObject:offText forKey:@"offText"];
    [encoder encodeFloat:outputOn forKey:@"outputOn"];
    [encoder encodeFloat:outputOff forKey:@"outputOff"];
}

#pragma mark - Gear's Unique Actions

-(void) pushAction:(id) sender
{
    SEL act;
    NSNumber *nsMagicNum;
    NSUInteger actNum;

    toggleValue = (toggleValue) ? NO : YES;

    // 1. State Changed
    act = ((NSValue*)((NSDictionary*)actionArray[2])[@"selector"]).pointerValue;
    nsMagicNum = ((NSDictionary*)actionArray[2])[@"mNum"];
    CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
    
    if( nil != gObj ){
        if( [gObj respondsToSelector:act] )
            [gObj performSelector:act withObject:@(toggleValue)];
        else
            EXCLAMATION;
    }

    // 2. On or Off actions
    actNum = ( toggleValue ) ? 1 : 0;

    act = ((NSValue*)((NSDictionary*)actionArray[actNum])[@"selector"]).pointerValue;
    nsMagicNum = ((NSDictionary*)actionArray[actNum])[@"mNum"];
    gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];

    if( nil != gObj ){
        if( [gObj respondsToSelector:act] ){
            [gObj performSelector:act withObject:@((toggleValue)?outputOn:outputOff)];
        }else
            EXCLAMATION;
    }

    // 버튼의 상태를 세팅한다.
    if( toggleValue ){
        [((BButton*)csView) setTitle:onText];
        [((BButton*)csView).layer setBackgroundColor:onColor.CGColor];
    }else{
        [((BButton*)csView) setTitle:offText];
        [((BButton*)csView).layer setBackgroundColor:offColor.CGColor];
    }
}

#pragma mark - Code Generator

-(NSArray*) importLinesCode
{
    return @[@"\"CSToggleButton.h\""];
}

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"CSToggleButton";
}

// 커스텀 클래스가 필요한 경우. 이 클래스의 get/set 메소드들은 모두 실제 CSGear 에서 사용하는 것과 같은 이름으로 사용하도록 한다. 코드 자동 생성기가 메소드 이름을 가지고 코드를 만들 수 있게 하기 위해서이다.
-(NSString*) customClass
{
    NSString *r = @"\n\n// CSToggleButton class\n//\n@interface CSToggleButton : UIView\n\{\n    BOOL toggleValue;\n\
    UIButton    *btn;\n    CGFloat outputOn, outputOff;\n    UIColor *onColor, *offColor;\n}\n\n-(void) setOnTintColor:(UIColor*)color;\n-(UIColor*)getOnTintColor;\n-(void) setOffTintColor:(UIColor*)color;\n-(UIColor*)getOffTintColor;\n\
-(void)setOnText:(NSString*)title;\n-(NSString*)getOnText;\n\
-(void)setOffText:(NSString*)title;\n-(NSString*)getOffText;\n\
-(void)setOnValue:(NSNumber*)val;\n-(NSNumber*)getOnValue;\n\
-(void) setTextColor:(UIColor*)color;\n-(UIColor*)getTextColor;\n\
-(void) setFont:(UIFont*)font;\n-(UIFont*)getFont;\n\
@property (nonatomic,strong)    UIButton *btn;\n@property (nonatomic,assign)    BOOL toggleValue;\n@end\n\n\
@implementation CSToggleButton\n\n@synthesize btn;\n@synthesize toggleValue;\n\n\
-(id)init{\n    if(self=[super init]){\n\
        self.clipsToBounds = YES;\n        [self.layer setBorderWidth:2.5];\n        [self.layer setCornerRadius:5.0];\n\
        [self.layer setBorderColor:[UIColor darkGrayColor].CGColor];\n\
        btn = [[UIButton alloc] initWithFrame:self.bounds];\n\
        [btn setBackgroundColor:[UIColor clearColor]];\n\
        [btn setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];\n\
        [self addSubview:btn];\n\
        [self setBackgroundColor:[UIColor blueColor]];\n\n\
        [btn addTarget:self action:@selector(touchIn:) forControlEvents:UIControlEventTouchDown];\n\
        [btn addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpOutside];\n\
        [btn addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];\n\
    }\n}\n\n\
-(void) touchIn:(id)sender\n{\n    UIColor *swapColor = self.backgroundColor;\n\
    [self setBackgroundColor: [btn titleColorForState:UIControlStateNormal]];\n\
    [btn setTitleColor:swapColor forState:UIControlStateHighlighted];\n\
    [self.layer setBorderColor:[UIColor whiteColor].CGColor];\n}\n\n\
-(void) touchUp:(id)sender\n{\n    [self setBackgroundColor: [btn titleColorForState:UIControlStateHighlighted]];\n\
    [self.layer setBorderColor:[UIColor darkGrayColor].CGColor];\n}\n\n\
-(void) setOnTintColor:(UIColor*)color\n{\n    onColor = color;\n\
    if( toggleValue && [color isKindOfClass:[UIColor class]] )\n\
        [self setBackgroundColor:color];\n}\n\n\
-(UIColor*) getOnTintColor\n{\n    return onColor;\n}\n\n\
-(void) setOffTintColor:(UIColor*)color\n{\n    offColor = color;\n\
    if( toggleValue && [color isKindOfClass:[UIColor class]] )\n\
        [self setBackgroundColor:color];\n}\n\n\
-(UIColor*) getOffTintColor\n{\n    return offColor;\n}\n\n\
-(void) setText:(NSString*)txt;\n{\n\
    [btn setTitle:txt forState:UIControlStateNormal];\n\
    [btn setTitle:txt forState:UIControlStateHighlighted];\n\
    [self setNeedsDisplay];\n}\n\n\
-(NSString*) getText\n{\n    return btn.titleLabel.text;\n}\n\n\
-(void) setOnValue:(NSNumber*) number\n{\n\
    if( [number isKindOfClass:[NSNumber class]] )\n\
        outputOn = [number floatValue];\n\
    else if( [number isKindOfClass:[NSString class]] )\n\
        outputOn = [(NSString*)number floatValue];\n}\n\n\
-(NSNumber*) getOnValue\n{\n    return @(outputOn);\n}\n\n\
-(void) setOffValue:(NSNumber*) number\n{\n\
    if( [number isKindOfClass:[NSNumber class]] )\n\
        outputOff = [number floatValue];\n\
    else if( [number isKindOfClass:[NSString class]] )\n\
        outputOff = [(NSString*)number floatValue];\n}\n\n\
-(NSNumber*) getOffValue\n{\n    return @(outputOff);\n}\n\n\
-(void) setTextColor:(UIColor*)color\n{\n\
    if( [color isKindOfClass:[UIColor class]] ){\n\
        [btn setTitleColor:color forState:UIControlStateNormal];\n\
        [btn setTitleColor:color forState:UIControlStateHighlighted];\n    }\n\
}\n\n\
-(UIColor*) getTextColor\n{\n    return btn.titleLabel.textColor;\n}\n\n\
-(void) setFont:(UIFont*)font\n{\n\
    if( [font isKindOfClass:[UIFont class]] )\n\
        [btn.titleLabel setFont:font];\n}\n\n\
-(UIFont*) getFont\n{\n    return btn.titleLabel.font;\n}\n\n\
-(void)pushAction{\n    toggleValue = (toggleValue) ? NO : YES;\n\
    if( toggleValue ){\n        [btn setTitle:onText];\n\
        [((BButton*)csView).layer setBackgroundColor:onColor.CGColor];\n\
    }else{\n        [((BButton*)csView) setTitle:offText];\n\
        [((BButton*)csView).layer setBackgroundColor:offColor.CGColor];\n\
    }\n}\n\n@end\n\n";

    return r;
}

-(NSString*) addTargetCode
{
    return [NSString stringWithFormat:@"    [%@.btn addTarget:self action:@selector(%@Action) forControlEvents:UIControlEventTouchUpInside];\n",varName,varName];
}

-(NSString*) actionCode
{
    NSMutableString *code = [[NSMutableString alloc] initWithFormat:@"-(void)%@Action\n{\n",varName];
    
    SEL act;
    NSNumber *nsMagicNum;

    [code appendFormat:@"    [%@ pushAction];\n",varName];

    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        [code appendFormat:@"    if( !%@.toggleValue)\n",varName];
        NSString *selNameStr = [NSString stringWithCString:sel_name_c encoding:NSUTF8StringEncoding];
        
        if( [selNameStr hasSuffix:@"Action:"] )
        {
            [code appendFormat:@"    %@\n",[gObj actionPropertyCode:selNameStr valStr:[NSString stringWithFormat:@"[%@ getOnValue]",varName]]];
        }
        else
            [code appendFormat:@"        [%@ %@[%@ getOnValue]];\n",[gObj getVarName],@(sel_name_c),self.getVarName];
    }
    act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        
        [code appendFormat:@"    if( %@.toggleValue)\n",varName];
        NSString *selNameStr = [NSString stringWithCString:sel_name_c encoding:NSUTF8StringEncoding];
        
        if( [selNameStr hasSuffix:@"Action:"] )
        {
            [code appendFormat:@"    %@\n",[gObj actionPropertyCode:selNameStr valStr:[NSString stringWithFormat:@"[%@ getOnValue]",varName]]];
        }
        else
            [code appendFormat:@"        [%@ %@[%@ getOffValue]];\n",[gObj getVarName],@(sel_name_c),self.getVarName];
    }
    act = ((NSValue*)((NSDictionary*)actionArray[2])[@"selector"]).pointerValue;
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[2])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        NSString *selNameStr = [NSString stringWithCString:sel_name_c encoding:NSUTF8StringEncoding];
        
        if( [selNameStr hasSuffix:@"Action:"] )
        {
            [code appendFormat:@"    %@\n",[gObj actionPropertyCode:selNameStr valStr:[NSString stringWithFormat:@"[%@ getOnValue]",varName]]];
        }
        else
            [code appendFormat:@"    [%@ %@%@.toggleValue];\n",[gObj getVarName],@(sel_name_c),self.getVarName];
    }
    [code appendString:@"}\n"];
    
    return code;
}

@end
