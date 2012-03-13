//
//  UserContext.h
//  PuddingSNS
//
//  Created by choipd on 10. 4. 13..
//  Copyright 2010 kth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "WaitView.h"
#import "CSGearObject.h"

#define USERCONTEXT     [UserContext sharedUserContext]



@interface UserContext: NSObject 
{	
	WaitView	*waitV;
    UIPopoverController *pop;
    NSArray     *wallpapers;

    // 청사진에 등록된 객체들을 관리하는 저장소.
    NSString        *appName;
    NSMutableArray  *gearsArray;
    NSUInteger      wallpaperIndex;

    Facebook   *facebook;

    BOOL            imRunning;
}

@property (nonatomic, strong)   NSString        *appName;
@property (nonatomic, strong)   NSMutableArray  *gearsArray;
@property (nonatomic, strong)   UIPopoverController *pop;
@property (nonatomic, strong)   NSArray         *wallpapers;
@property (nonatomic)           NSUInteger      wallpaperIndex;
@property (nonatomic)           BOOL            imRunning;
@property (nonatomic, strong)   Facebook *facebook;


+ (UserContext *)sharedUserContext;

- (id) initWithDefault;

- (void) startWaitView: (NSInteger) yDeltaPos;
- (void) stopWaitView;
- (void) errorTik:(CSGearObject*)obj;

-(CSGearObject*) getGearWithMagicNum:(NSUInteger) magicNum;

@end

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color);
