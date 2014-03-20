//
//  CSLinkStr.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 3. 5..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSLinkStr : CSGearObject
{
    NSString *str1, *str2, *str3, *str4, *str5;
}

-(id) initGear;

-(void) setInput1Str:(NSString*)string;
-(NSString*) getInput1Str;

-(void) setInput2Str:(NSString*)string;
-(NSString*) getInput2Str;

-(void) setInput3Str:(NSString*)string;
-(NSString*) getInput3Str;

-(void) setInput4Str:(NSString*)string;
-(NSString*) getInput4Str;

-(void) setInput5Str:(NSString*)string;
-(NSString*) getInput5Str;

-(void) setStringAction:(NSNumber*)BoolValue;
-(NSNumber*) getStringAct;

@end
