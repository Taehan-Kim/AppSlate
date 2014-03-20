//
//  CSStoreView.m
//  AppSlate
//
//  Created by Tae Han Kim on 2013. 8. 13..
//  Copyright (c) 2013년 ChocolateSoft. All rights reserved.
//

#import "CSStoreView.h"
#import "CSAppDelegate.h"

@implementation CSStoreView

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setID:(NSNumber*)num;
{
    if( [num isKindOfClass:[NSNumber class]] )
        appID = num;
    
    else if([num isKindOfClass:[NSString class]] )
        appID = @([(NSString*)num floatValue]);
}

-(NSNumber*) getID
{
    return appID;
}

-(void) setShowAction:(NSNumber*)BoolValue
{
    // YES 값인 경우만 반응하자.
    if( ![BoolValue isKindOfClass:[NSNumber class]] || NO == [BoolValue boolValue] )
        return;
    
   
    if( USERCONTEXT.imRunning ){
        if( 0 == appID ) return;

        NSDictionary *parameters =
        @{SKStoreProductParameterITunesItemIdentifier:appID};
        [Sv loadProductWithParameters:parameters completionBlock:^(BOOL result, NSError *error)
         {
             [((CSAppDelegate*)([UIApplication sharedApplication].delegate)).window.rootViewController presentViewController:Sv animated:YES
                              completion:^{
                                  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                                  [UIView animateWithDuration:0.3 animations:^(void) {
                                  } completion:^(BOOL finished) {
                                  }];
                              }];
         }];
    }
}

-(NSNumber*) getShow
{
    return @NO;
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_store.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_STOREVIEW;
    
    csResizable = NO;
    csShow = NO;
    Sv = [[SKStoreProductViewController alloc] init];
    [Sv setDelegate:self];

    NSDictionary *d1 = MAKE_PROPERTY_D(@"App ID", P_NUM, @selector(setID:),@selector(getID));
    NSDictionary *d4 = MAKE_PROPERTY_D(@">Show Action", P_BOOL, @selector(setShowAction:),@selector(getShow));
    pListArray = @[d1,d4];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_store.png"]];
        appID = [decoder decodeObjectForKey:@"appIdStr"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:appID forKey:@"appIdStr"];
}

#pragma mark - SKStoreProductViewControllerDelegate

// SK store view 를 닫는 요구가 들어오면
-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:^{
    } ];
}

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"SKStoreProductViewController";
}

-(NSArray*) importLinesCode
{
    return @[@"<StoreKit/StoreKit.h>"];
}

// viewDidLoad 에서 alloc - init 하지 않을 것일때는 NO_FIRST_ALLOC 을 리턴하자.
-(NSString*) customClass
{
    return NO_FIRST_ALLOC;
}

-(NSString*) delegateName
{
    return @"SKStoreProductViewControllerDelegate";
}

-(NSArray*) delegateCodes
{
    return @[@"-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController\n{\n",@"    [viewController dismissViewControllerAnimated:YES completion:nil];\n",@"}\n\n"];
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    if( [apName isEqualToString:@"setShowAction:"] ){
        return [NSString stringWithFormat:@"    NSDictionary *parameters = @{SKStoreProductParameterITunesItemIdentifier:%@};\n\
    [%@ loadProductWithParameters:parameters completionBlock:^(BOOL result, NSError *error){\n\
        [self presentViewController:%@ animated:YES completion:nil];\n    }];\n", appID,varName,varName];
    }
    return nil;
}
@end
