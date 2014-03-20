//
//  CSBulb.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 1. 31..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSBulb.h"

@implementation CSBulb

-(id) object
{
    return ((UIView*)csView);
}

//===========================================================================
#pragma mark -

-(void) setLightColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [light setBackgroundColor:color];

//    [self drawBulb];
}

-(UIColor*) getLightColor
{
    return light.backgroundColor;
}

-(void) setOnValue:(NSNumber*)BoolValue
{
    onValue = [BoolValue boolValue];
    
    [self drawBulb];
}

-(NSNumber*) getOnValue
{    
    return @(onValue);
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;

    csView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [csView setClipsToBounds:YES];
    [csView.layer setCornerRadius:15];
    [csView setBackgroundColor:[UIColor lightGrayColor]];
    [csView setUserInteractionEnabled:YES];

    light = [[UIView alloc] initWithFrame:CGRectMake(9, 9, 12, 12)];
    [light setClipsToBounds:YES];
    [light.layer setCornerRadius:6];
    [light setBackgroundColor:[UIColor redColor]];
    [csView addSubview:light];
    
    onValue = YES;

    csCode = CS_BULB;
    csResizable = NO;

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Light Color", P_COLOR, @selector(setLightColor:),@selector(getLightColor));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"On Value", P_BOOL, @selector(setOnValue:),@selector(getOnValue));
    pListArray = @[xc,yc,d0,d1,d2];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        light = [csView subviews][0];
//        light = [[UIView alloc] initWithFrame:CGRectMake(8, 8, 12, 12)];
        [light setClipsToBounds:YES];
        [light.layer setCornerRadius:6];
//        [light setBackgroundColor:[UIColor redColor]];
        [csView addSubview:light];
    }
    return self;
}

-(void) drawBulb
{
    if( onValue ){
        [light setAlpha:1.0];
        UIView *flar = [[UIView alloc] initWithFrame:light.frame];
        [flar setClipsToBounds:YES];
        [flar.layer setCornerRadius:6.0];
        [flar setBackgroundColor:CSCLEAR];
        [flar.layer setBorderColor:light.backgroundColor.CGColor];
        [flar.layer setBorderWidth:2.0];
        [csView addSubview:flar];
        [UIView animateWithDuration:0.3 animations:^(){
            CGAffineTransform sct = CGAffineTransformMakeScale(3.0, 3.0);
            [flar setTransform:sct];
            [flar setAlpha:0.0];
        } completion:^(BOOL finished){
            [flar removeFromSuperview];
        }];
    } else
        [light setAlpha:0.0];
}

#pragma mark - Code Generator

-(NSArray*) importLinesCode
{
    return @[@"\"CSBulb.h\""];
}

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"CSBulb";
}

// 커스텀 클래스가 필요한 경우. 이 클래스의 get/set 메소드들은 모두 실제 CSGear 에서 사용하는 것과 같은 이름으로 사용하도록 한다. 코드 자동 생성기가 메소드 이름을 가지고 코드를 만들 수 있게 하기 위해서이다.
-(NSString*) customClass
{
    NSString *r = @"\n\n// CSBulb class\n//\n@interface CSBulb : NSObject\n\
{\n\
    UIView *light;\n}\n\
-(void) setLightColor:(UIColor*)color;\n\
-(void) setOnValue:(NSNumber*) isOn;\n\
@end\n\n\
@implementation CSBulb\n\n\
-(id)init{\n    if(self=[super init] ){\n\
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];\n\
        [self.view setClipsToBounds:YES];\n\
        [self.view.layer setCornerRadius:15];\n\
        [self.view setBackgroundColor:[UIColor lightGrayColor]];\n\n\
        light = [[UIView alloc] initWithFrame:CGRectMake(9, 9, 12, 12)];\n\
        [light setClipsToBounds:YES];\n\
        [light.layer setCornerRadius:6.0];\n\
        [light setBackgroundColor:[UIColor redColor]];\n\
        [self.view addSubview:light];\n\
    }\n    return self;\n}\n\n\
-(void) setLightColor:(UIColor*)color\n{\n\
    [light setBackgroundColor:color];\n\
}\n\n\
-(void)setOnValue:(NSNumber*)isOn{\n\
    if( [isOn boolValue] ){\n\
        [light setAlpha:1.0];\n\
        UIView *flar = [[UIView alloc] initWithFrame:light.frame];\n\
        [flar setClipsToBounds:YES];\n\
        [flar.layer setCornerRadius:6.0];\n\
        [flar setBackgroundColor:[UIColor clearColor]];\n\
        [flar.layer setBorderColor:light.backgroundColor.CGColor];\n\
        [flar.layer setBorderWidth:2.0];\n\
        [csView addSubview:flar];\n\
        [UIView animateWithDuration:0.3 animations:^(){\n\
            CGAffineTransform sct = CGAffineTransformMakeScale(3.0, 3.0);\n\
            [flar setTransform:sct];\n\
            [flar setAlpha:0.0];\n\
        } completion:^(BOOL finished){\n\
            [flar removeFromSuperview];\n\
        }];\n\
    } else\n\
        [light setAlpha:0.0];\n\
}\n\
@end\n\n";

    return r;
}

@end
