//
//  UserContext.h
//  PuddingSNS
//
//  Created by choipd on 10. 4. 13..
//  Copyright 2010 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaitView.h"
#import "CSGearObject.h"

#define USERCONTEXT     [UserContext sharedUserContext]



@interface UserContext: NSObject 
{	
	WaitView	*waitV;
}

@property (nonatomic, strong)   NSString        *appName;
@property (nonatomic, strong)   NSString        *parseId;
@property (nonatomic, strong)   NSMutableArray  *gearsArray;
@property (nonatomic, strong)   id pop;
@property (nonatomic, strong)   NSArray         *wallpapers;
@property (nonatomic)           NSUInteger      wallpaperIndex;
@property (nonatomic)           BOOL            imRunning;
@property (nonatomic)           BOOL            inviteCheckEnabled;
@property (nonatomic)           BOOL            showPopover;

+ (UserContext *)sharedUserContext;

- (id) initWithDefault;

- (void) startWaitView: (NSInteger) yDeltaPos;
- (void) stopWaitView;
- (void) updateWaitView: (NSUInteger) percentValue;
- (void) errorTik:(CSGearObject*)obj;

-(CSGearObject*) getGearWithMagicNum:(NSUInteger) magicNum;

// Code Generator
-(BOOL) isThereSameVarNameWith:(NSString*) theName;

@end

void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color, CGFloat width);
