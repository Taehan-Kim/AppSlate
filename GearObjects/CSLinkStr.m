//
//  CSLinkStr.m
//  AppSlate
//
//  Created by 김 태한 on 12. 3. 5..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSLinkStr.h"

@implementation CSLinkStr

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setString1:(NSString*)string
{
    if( [string isKindOfClass:[NSString class]] )
        str1 = string;
    else if( [string isKindOfClass:[NSNumber class]] )
        str1 = [((NSNumber*)string) stringValue];
    else
        EXCLAMATION;
}

-(NSString*) getString1
{
    return str1;
}

-(void) setString2:(NSString*)string
{
    if( [string isKindOfClass:[NSString class]] )
        str2 = string;
    else if( [string isKindOfClass:[NSNumber class]] )
        str2 = [((NSNumber*)string) stringValue];
    else
        EXCLAMATION;
}

-(NSString*) getString2
{
    return str2;
}

-(void) setString3:(NSString*)string
{
    if( [string isKindOfClass:[NSString class]] )
        str3 = string;
    else if( [string isKindOfClass:[NSNumber class]] )
        str3 = [((NSNumber*)string) stringValue];
    else
        EXCLAMATION;
}

-(NSString*) getString3
{
    return str3;
}

-(void) setString4:(NSString*)string
{
    if( [string isKindOfClass:[NSString class]] )
        str4 = string;
    else if( [string isKindOfClass:[NSNumber class]] )
        str4 = [((NSNumber*)string) stringValue];
    else
        EXCLAMATION;
}

-(NSString*) getString4
{
    return str4;
}

-(void) setString5:(NSString*)string
{
    if( [string isKindOfClass:[NSString class]] )
        str5 = string;
    else if( [string isKindOfClass:[NSNumber class]] )
        str5 = [((NSNumber*)string) stringValue];
    else
        EXCLAMATION;
}

-(NSString*) getString5
{
    return str5;
}

-(void) setStringAct:(NSNumber*)BoolValue
{
    BOOL value;

    if( [BoolValue isKindOfClass:[NSString class]] )
        value = [(NSString*)BoolValue boolValue];
    else if( [BoolValue isKindOfClass:[NSNumber class]] )
        value = [BoolValue boolValue];
    else
        return;

    SEL act;
    NSNumber *nsMagicNum;
    
    act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] ){
                NSString *result = [NSString stringWithFormat:@"%@%@%@%@%@",str1,str2,str3,str4,str5];
                [gObj performSelector:act withObject:result];
            }else
                EXCLAMATION;
        }
    }
}

-(NSNumber*) getStringAct
{
    return [NSNumber numberWithBool:NO];
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_strcat.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_STRCAT;

    csResizable = NO;
    csShow = NO;

    self.info = NSLocalizedString(@"String Linker", @"strcat");
    str1 = @"";
    str2 = @"";
    str3 = @"";
    str4 = @"";
    str5 = @"";
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Input String #1", P_TXT, @selector(setString1:),@selector(getString1));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Input String #2", P_TXT, @selector(setString2:),@selector(getString2));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Input String #3", P_TXT, @selector(setString3:),@selector(getString3));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Input String #4", P_TXT, @selector(setString4:),@selector(getString4));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"Input String #5", P_TXT, @selector(setString5:),@selector(getString5));
    NSDictionary *d6 = MAKE_PROPERTY_D(@">Output Linked String", P_NUM, @selector(setStringAct:),@selector(getStringAct));
    pListArray = [NSArray arrayWithObjects:d1,d2,d3,d4,d5,d6, nil];
    
    NSMutableDictionary MAKE_ACTION_D(@"Output", A_TXT, a1);
    actionArray = [NSArray arrayWithObjects:a1, nil];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_strcat.png"]];
        str1 = [decoder decodeObjectForKey:@"str1"];
        str2 = [decoder decodeObjectForKey:@"str2"];
        str3 = [decoder decodeObjectForKey:@"str3"];
        str4 = [decoder decodeObjectForKey:@"str4"];
        str5 = [decoder decodeObjectForKey:@"str5"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:str1 forKey:@"str1"];
    [encoder encodeObject:str2 forKey:@"str2"];
    [encoder encodeObject:str3 forKey:@"str3"];
    [encoder encodeObject:str4 forKey:@"str4"];
    [encoder encodeObject:str5 forKey:@"str5"];
}

@end
