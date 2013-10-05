//
//  AFPhotoEditorProduct.h
//  AviarySDK
//
//  Copyright (c) 2012 Aviary, Inc. All rights reserved.
//

/** @defgroup AFPhotoEditorProducts In-App Purchase Products */

/** @addtogroup AFPhotoEditorProducts
    @{
 */

/**
 The internal product identifier for the Grunge effect pack.
 */
static NSString *const kAFProductEffectsGrunge = @"com.aviary.effectpack.01";

/**
 The internal product identifier for the Nostalgia effect pack.
 */
static NSString *const kAFProductEffectsNostalgia = @"com.aviary.effectpack.02";

/**
 The internal product identifier for the Viewfinder effect pack.
 */
static NSString *const kAFProductEffectsViewfinder = @"com.aviary.effectpack.03";

/** @} */

/**
 This class encapsulates information about non-consumable, in-app
 purchaseable products produced by Aviary and made available to users. This
 class is used in conjunction with the AFPhotoEditorInAppPurchaseDelegate
 protocol methods.
 */
@interface AFPhotoEditorProduct : NSObject

/**
 The name of the product in English. 
 
 This should match the name entered into iTunes Connect for this product.
 */
@property (nonatomic, copy, readonly) NSString *productName;

/**
 The description of the product in English. 
 
 This should match the
 description entered into iTunes Connect for this product.
 */
@property (nonatomic, copy, readonly) NSString *productDescription;

/**
 The internal product identifier. 
 
 This key is guaranteed to be
 unique among all in-app purchase product identifiers used internally by
 Aviary. This key should *not* be entered into iTunes Connect. Create a new
 key, and implement the AFPhotoEditorInAppPurchaseDelegate protocol methods
 to pass your unique identifier to the SDK. See the Aviary iOS SDK In-App
 Purchase Guide for more information.
*/
@property (nonatomic, copy, readonly) NSString *internalProductIdentifier;

@end
