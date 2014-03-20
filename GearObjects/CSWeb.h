//
//  CSWeb.h
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 29..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSGearObject.h"

@interface CSWeb : CSGearObject <UIWebViewDelegate>
{
    NSString *urlStr;
}

-(id) initGear;

-(void) setURL:(NSString*) urlStr;
-(NSString*) getURL;

-(void) setReloadAction:(NSNumber*)act;
-(NSNumber*) getReloadAction;

-(void) setBackAction:(NSNumber*)act;
-(NSNumber*) getBackAction;

-(void) setForwardAction:(NSNumber*)act;
-(NSNumber*) getForwardAction;

-(void) setScalesPageToFit:(NSNumber*)BoolValue;
-(NSNumber*) getScalesPageToFit;

-(void) setStopAction:(NSNumber*)BoolValue;
-(NSNumber*) getStopAction;

@end
