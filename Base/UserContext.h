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
#import "CSGearObject.h"

#define USERCONTEXT     [UserContext sharedUserContext]

/**
 @brief 로그인 유저의 정보를 담고 있는 자료구조
 */

@interface UserContext: NSObject 
{	
	WaitView	*waitV;
    UIPopoverController *pop;

    // 청사진에 등록된 객체들을 관리하는 저장소.
    NSMutableArray  *gearsArray;
}

@property (nonatomic, strong)   NSMutableArray  *gearsArray;
@property (nonatomic, strong)   UIPopoverController *pop;


+ (UserContext *)sharedUserContext;
- (id) initWithDefault;

- (void) startWaitView: (NSInteger) yDeltaPos;
- (void) stopWaitView;

-(CSGearObject*) getGearWithMagicNum:(NSUInteger) magicNum;

@end

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);
