//
//  UserContext.h
//  PuddingSNS
//
//  Created by choipd on 10. 4. 13..
//  Copyright 2010 kth. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreLocation/CoreLocation.h>
#import "WaitView.h"

#define USERCONTEXT     [UserContext sharedUserContext]

/**
 @brief 로그인 유저의 정보를 담고 있는 자료구조
 */

@interface UserContext: NSObject 
{	
	WaitView	*waitV;
}

+ (UserContext *)sharedUserContext;
- (id) initWithDefault;

- (void) startWaitView: (NSInteger) yDeltaPos;
- (void) stopWaitView;

@end
