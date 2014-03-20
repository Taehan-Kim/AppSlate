//
//  CSMakeCode.h
//  AppSlate
//
//  Created by Taehan Kim on 2014. 1. 7..
//  Copyright (c) 2014년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSMakeCode : NSObject
{
    NSString *fileName;
    NSMutableString *mainDoc;
}

- (id) initWithControllerName:(NSString*)name;
- (NSString *) generate;

@end
