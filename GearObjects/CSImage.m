//
//  CSImage.m
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 27..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSImage.h"

@implementation CSImage

-(id) object
{
    return ((UIImageView*)csView);
}

//===========================================================================
#pragma mark -

-(void) setImage:(UIImage*) imageD
{
    if( ![imageD isKindOfClass:[UIImage class]] )
    {
        EXCLAMATION;
        return;
    }

    [((UIImageView*)csView) setImage:imageD];
}

-(UIImage*) getImage
{
    return ((UIImageView*)csView).image;
}

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [csView setBackgroundColor:[UIColor grayColor]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_IMAGE;
    isUIObj = YES;

    self.info = NSLocalizedString(@"Image", @"Image");
//    [((UIImageView*)csView) ];

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Image", P_IMG, @selector(setImage:),@selector(getImage));
    pListArray = [NSArray arrayWithObjects:xc,yc,d0,d1, nil];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
//        value1 = [decoder decodeFloatForKey:@"imageData"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
//    [encoder encodeFloat:value1 forKey:@"imageData"];
}

@end
