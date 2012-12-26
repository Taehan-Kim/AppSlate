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

-(void) setString1:(NSString*)string;
-(NSString*) getString1;

-(void) setString2:(NSString*)string;
-(NSString*) getString2;

-(void) setString3:(NSString*)string;
-(NSString*) getString3;

-(void) setString4:(NSString*)string;
-(NSString*) getString4;

-(void) setString5:(NSString*)string;
-(NSString*) getString5;

-(void) setStringAct:(NSNumber*)BoolValue;
-(NSNumber*) getStringAct;

@end
