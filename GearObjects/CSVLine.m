//
//  CSVLine.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 28..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSVLine.h"

@implementation CSVLine

-(id) object
{
    return (csView);
}

//===========================================================================
#pragma mark -

-(void) setHeightAction:(NSNumber*)num
{
    if( [num isKindOfClass:[NSNumber class]] )
        [csView setFrame:CGRectMake(csView.frame.origin.x, csView.frame.origin.y, csView.frame.size.width, [num floatValue])];
}

-(NSNumber*) getHeight
{
    return @(csView.frame.size.height);
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
    
    csView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 200)];
    [csView setBackgroundColor:[UIColor lightGrayColor]];
    [csView setUserInteractionEnabled:YES];
    [csView setClipsToBounds:YES];
    csCode = CS_LINE_V;
    
    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@">Length", P_NUM, @selector(setHeightAction:),@selector(getHeight));
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
    if( [apName isEqualToString:@"setHeightAction:"] ){
        return [NSString stringWithFormat:@"[%@ setFrame:CGRectMake(%@.frame.origon.x,%@.frame.origon.y,%@.frame.size.width,%@)];\n",varName,varName,varName,varName,val];
    }
    return nil;
}

@end
