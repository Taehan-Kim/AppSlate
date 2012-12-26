//
//  SettingViewCommon.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 11. 12. 29..
//  Copyright (c) 2011년 ChocolateSoft. All rights reserved.
//

#import "SettingViewCommon.h"
#import <objc/message.h>

@interface SettingViewCommon ()

@end

@implementation SettingViewCommon


#pragma mark -

-(id) init
{
    if( self = [super init] ){
        NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"setSound" ofType:@"wav"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &myID);
    }
    return self;
}

- (id)initWithGear:(id)gear propertyInfo:(NSDictionary*)infoDic
{
    self = [self init];
    [self setGearValue:gear propertyInfo:infoDic];
    return self;
}

-(void) setGearValue:(id)gear propertyInfo:(NSDictionary*)infoDic
{
    theGear = gear;
    pInfoDic = infoDic;
}

-(void) saveValue:(id)value
{
    SEL selector = [pInfoDic[@"selector"] pointerValue];

    if( [theGear respondsToSelector:selector] )
//        [theGear performSelector:selector withObject:value]; same code with below line
        objc_msgSend(theGear, selector, value);
    else {
        // TODO: Error Handling
        return;
    }
    [self doSound];

    if( UIUserInterfaceIdiomPhone == UI_USER_INTERFACE_IDIOM() )
        [self.navigationController popViewControllerAnimated:YES];
}

-(void) doSound
{
    if( [[NSUserDefaults standardUserDefaults] boolForKey:@"SND_SET"] )
        AudioServicesPlaySystemSound(myID);
}

-(void) viewWillDisappear:(BOOL)animated
{
    AudioServicesDisposeSystemSoundID(myID);
}
@end
