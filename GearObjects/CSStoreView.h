//
//  CSStoreView.h
//  AppSlate
//
//  Created by Tae Han Kim on 2013. 8. 13..
//  Copyright (c) 2013년 ChocolateSoft. All rights reserved.
//

#import "CSGearObject.h"
#import <StoreKit/StoreKit.h>

@interface CSStoreView : CSGearObject <SKStoreProductViewControllerDelegate>
{
    SKStoreProductViewController *Sv;
    NSNumber *appID;
}

-(id) initGear;

-(void) setID:(NSNumber*)num;
-(NSNumber*) getID;

-(void) setShowAction:(NSNumber*)BoolValue;
-(NSNumber*) getShow;

@end
