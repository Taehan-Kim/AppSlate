//
//  CSHLine.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 28..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSHLine.h"

@implementation CSHLine

-(id) object
{
    return (csView);
}

//===========================================================================
#pragma mark -

-(void) setWidthAction:(NSNumber*)num
{
    if( [num isKindOfClass:[NSNumber class]] )
        [csView setFrame:CGRectMake(csView.frame.origin.x, csView.frame.origin.y, [num floatValue], csView.frame.size.height)];
}

-(NSNumber*) getWidth
{
    return @(csView.frame.size.width);
}

-(void) setBackgroundColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [csView setBackgroundColor:color];
}

-(UIColor*) getBackgroundColor
{
    return [csView backgroundColor];
}

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
    
    csView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 5)];
    [csView setBackgroundColor:[UIColor lightGrayColor]];
    [csView setUserInteractionEnabled:YES];
    [csView setClipsToBounds:YES];
    csCode = CS_LINE_H;
    
    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@">Length", P_NUM, @selector(setWidthAction:),@selector(getWidth));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Line Color", P_COLOR, @selector(setBackgroundColor:),@selector(getBackgroundColor));
    pListArray = @[xc,yc,d0,d1,d2];

    return self;
}

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"UIView";
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    if( [apName isEqualToString:@"setWidthAction:"] ){
        return [NSString stringWithFormat:@"[%@ setFrame:CGRectMake(%@.frame.origon.x,%@.frame.origon.y,%@,%@.frame.size.height)];\n",varName,varName,varName,val,varName];
    }
    return nil;
}

@end
