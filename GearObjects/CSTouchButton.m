//
//  CSTouchButton.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 2. 19..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSTouchButton.h"

@implementation CSTouchButton

-(id) object
{
    return ((BButton*)csView);
}

//===========================================================================
#pragma mark -

-(void) setTintColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((BButton*)csView).layer setBackgroundColor:color.CGColor];
}

-(UIColor*) getTintColor
{
    return [UIColor colorWithCGColor:((BButton*)csView).layer.backgroundColor];
}

-(void) setText:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        [((BButton*)csView) setTitle:txt];
    
    else if([txt isKindOfClass:[NSNumber class]] )
        [((BButton*)csView) setTitle:[((NSNumber*)txt) stringValue]];
}

-(NSString*) getText
{
    return ((BButton*)csView).btn.titleLabel.text;
}

-(void) setTextColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((BButton*)csView) setTitleColor:color];
}

-(void) setOutputValue:(NSNumber*) number
{
    if( [number isKindOfClass:[NSNumber class]] )
        output = [number floatValue];
    else if( [number isKindOfClass:[NSString class]] )
        output = [(NSString*)number length];
    else
        EXCLAMATION;
}

-(NSNumber*) getOutputValue
{
    return @(output);
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
    
    csView = [[BButton alloc] initWithFrame:CGRectMake(0, 0, 130, MINSIZE2)];
    [csView setUserInteractionEnabled:YES];
    [((BButton*)csView).layer setBackgroundColor:[UIColor lightGrayColor].CGColor];

    csCode = CS_TOUCHBTN;
    output = 1.0;

    [((BButton*)csView) setTitle:NSLocalizedString(@"Touch Button", @"Touch Button")];
    [((BButton*)csView).btn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchDown];
    [((BButton*)csView).btn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpInside];
    [((BButton*)csView).btn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpOutside];

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Tint Color", P_COLOR, @selector(setTintColor:),@selector(getTintColor));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Button Text", P_TXT, @selector(setText:),@selector(getText));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Output Value", P_NUM, @selector(setOutputValue:),@selector(getOutputValue));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Text Color", P_COLOR, @selector(setTextColor:),@selector(getTextColor));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"Text Font", P_FONT, @selector(setFont:),@selector(getFont));
    
    pListArray = @[xc,yc,d0,d1,d2,d3,d4,d5];
    
    NSMutableDictionary MAKE_ACTION_D(@"Push Up & Down", A_NUM, a1);
    actionArray = @[a1];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [((BButton*)csView).btn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchDown];
        [((BButton*)csView).btn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpInside];
        [((BButton*)csView).btn addTarget:self action:@selector(releaseAction) forControlEvents:UIControlEventTouchUpOutside];
        output = [decoder decodeFloatForKey:@"output"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeFloat:output forKey:@"output"];
}

#pragma mark - Gear's Unique Actions

-(void) pushAction
{
    SEL act;
    NSNumber *nsMagicNum;
    
    // 3. Did Turn Off
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    
    nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
    CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
    
    if( nil != gObj ){
        if( [gObj respondsToSelector:act] )
            [gObj performSelector:act withObject:@(output)];
        else
            EXCLAMATION;
    }
}

-(void) releaseAction
{
    SEL act;
    NSNumber *nsMagicNum;
    
    // 3. Did Turn Off
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    
    nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
    CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
    
    if( nil != gObj ){
        if( [gObj respondsToSelector:act] )
            [gObj performSelector:act withObject:@NO];
        else
            EXCLAMATION;
    }
}

#pragma mark - Code Generator

-(NSArray*) importLinesCode
{
    return @[@"\"CSTouchButton.h\""];
}

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"CSTouchButton";
}

-(NSString*) customClass
{
    NSString *r = @"\n\n// CSTouchButton class\n//\n@interface CSTouchButton : UIView\n\{\n    BOOL toggleValue;\n\
    UIButton    *btn;\n    CGFloat output;\n}\n\n-(void) setTintColor:(UIColor*)color;\n-(UIColor*)getTintColor;\n\
-(void)setText:(NSString*)title;\n-(NSString*)getText;\n\
-(void)setOutputValue:(NSNumber*)val;\n-(NSNumber*)getOutputValue;\n\
-(void) setTextColor:(UIColor*)color;\n-(UIColor*)getTextColor;\n\
-(void) setFont:(UIFont*)font;\n-(UIFont*)getFont;\n\
@property (nonatomic,strong)    UIButton *btn;\n@end\n\n\
@implementation CSTouchButton\n\n@synthesize btn;\n\n\
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
-(void) setTintColor:(UIColor*)color\n{\n\
    [self setBackgroundColor:color];\n}\n\n\
-(UIColor*) getTintColor\n{\n    return self.backgroundColor;\n}\n\n\
-(void) setText:(NSString*)txt;\n{\n\
    [btn setTitle:txt forState:UIControlStateNormal];\n\
    [btn setTitle:txt forState:UIControlStateHighlighted];\n\
    [self setNeedsDisplay];\n}\n\n\
-(NSString*) getText\n{\n    return btn.titleLabel.text;\n}\n\n\
-(void) setOutputValue:(NSNumber*) number\n{\n\
    if( [number isKindOfClass:[NSNumber class]] )\n\
        output = [number floatValue];\n\
    else if( [number isKindOfClass:[NSString class]] )\n\
        output = [(NSString*)number floatValue];\n}\n\n\
-(NSNumber*) getOutputValue\n{\n    return @(output);\n}\n\n\
-(void) setTextColor:(UIColor*)color\n{\n\
    if( [color isKindOfClass:[UIColor class]] ){\n\
        [btn setTitleColor:color forState:UIControlStateNormal];\n\
        [btn setTitleColor:color forState:UIControlStateHighlighted];\n    }\n\
}\n\n\
-(UIColor*) getTextColor\n{\n    return btn.titleLabel.textColor;\n}\n\n\
-(void) setFont:(UIFont*)font\n{\n\
    if( [font isKindOfClass:[UIFont class]] )\n\
        [btn.titleLabel setFont:font];\n}\n\n\
-(UIFont*) getFont\n{\n    return btn.titleLabel.font;\n}\n\n@end\n\n";
    
    return r;
}

-(NSString*) addTargetCode
{
    return [NSString stringWithFormat:@"    [%@.btn addTarget:self action:@selector(%@pushAction) forControlEvents:UIControlEventTouchDown];\n[%@.btn addTarget:self action:@selector(%@upAction) forControlEvents:UIControlEventTouchUpInside];\n",varName,varName,varName,varName];
}

-(NSString*) actionCode
{
    NSMutableString *code = [[NSMutableString alloc] initWithFormat:@"-(void)%@pushAction\n{\n",varName];
    
    SEL act;
    NSNumber *nsMagicNum;
    
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        NSString *selNameStr = [NSString stringWithCString:sel_name_c encoding:NSUTF8StringEncoding];
        
        if( [selNameStr hasSuffix:@"Action:"] )
        {
            [code appendFormat:@"    %@\n",[gObj actionPropertyCode:selNameStr valStr:[NSString stringWithFormat:@"[%@ getOoutputValue]",varName]]];
        }
        else
            [code appendFormat:@"    [%@ %@[%@ getOutputValue]];\n",[gObj getVarName],@(sel_name_c),self.getVarName];
    }
    [code appendString:@"}\n\n"];

    [code appendFormat:@"-(void)%@upAction\n{\n",varName];

    act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        NSString *selNameStr = [NSString stringWithCString:sel_name_c encoding:NSUTF8StringEncoding];
        
        if( [selNameStr hasSuffix:@"Action:"] )
        {
            [code appendFormat:@"    %@\n",[gObj actionPropertyCode:selNameStr valStr:@"NO"]];
        }
        else
            [code appendFormat:@"    [%@ %@@(NO)];\n",[gObj getVarName],@(sel_name_c)];
    }
    [code appendString:@"}\n"];

    return code;
}

@end
