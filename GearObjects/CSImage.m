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

-(void) setAspectFit:(NSNumber*) boolValue
{
    BOOL var;
    if( [boolValue isKindOfClass:[NSString class]] )
        var = [(NSString*)boolValue boolValue];
    else  if( [boolValue isKindOfClass:[NSNumber class]] )
        var = [boolValue boolValue];
    else
        return;

    if( var )
        [(UIImageView*)csView setContentMode:UIViewContentModeScaleAspectFit];
    else
        [(UIImageView*)csView setContentMode:UIViewContentModeScaleToFill];
}

-(NSNumber*) getAspectFit
{
    return [NSNumber numberWithBool:(((UIImageView*)csView).contentMode == UIViewContentModeScaleAspectFit)];
}

-(void) setBackgroundColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [csView setBackgroundColor:color];
}

-(UIColor*) getBackgroundColor
{
    return csView.backgroundColor;
}

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [csView setBackgroundColor:[UIColor grayColor]];
    [csView setUserInteractionEnabled:YES];
    [(UIImageView*)csView setContentMode:UIViewContentModeScaleAspectFit];

    csCode = CS_IMAGE;
    isUIObj = YES;

    self.info = NSLocalizedString(@"Image", @"Image");
//    [((UIImageView*)csView) ];

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Image", P_IMG, @selector(setImage:),@selector(getImage));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Aspect Fit", P_BOOL, @selector(setAspectFit:),@selector(getAspectFit));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Background Color", P_COLOR, @selector(setBackgroundColor:),@selector(getBackgroundColor));
    pListArray = [NSArray arrayWithObjects:xc,yc,d0,d1,d2,d3, nil];

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
