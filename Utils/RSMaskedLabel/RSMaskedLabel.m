//
//  RSMaskedLabel.m
//  RSMaskedLabel
//
//  Created by Robin Senior on 12-01-04.
//  Copyright (c) 2012 Robin Senior. All rights reserved.
//

#import "RSMaskedLabel.h"
#import <QuartzCore/QuartzCore.h>

@interface UIImage (RSAdditions)
+ (UIImage *) imageWithView:(UIView *)view;
- (UIImage *) invertAlpha;
@end

@interface RSMaskedLabel ()
{
    CGImageRef invertedAlphaImage;
}
@property (nonatomic, strong) UILabel *knockoutLabel;
@property (nonatomic, strong) CALayer *textLayer;
- (void) RS_commonInit;
- (void) updateLabel;
@end

@implementation RSMaskedLabel
@synthesize knockoutLabel, textLayer, text;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self RS_commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) 
    {
        [self setBackgroundColor:[UIColor clearColor]];
        knockoutLabel = [aDecoder decodeObjectForKey:@"knockoutLabel"];
        [self setText:[aDecoder decodeObjectForKey:@"text"]];
        [self setFont:[aDecoder decodeObjectForKey:@"font"]];  // TODO:Crash debug
        CALayer *gradientLayer = [self layer];
        [gradientLayer setBackgroundColor:[[aDecoder decodeObjectForKey:@"backColor"] CGColor]];
        [gradientLayer setCornerRadius:10];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:knockoutLabel forKey:@"knockoutLabel"];
    [encoder encodeObject:text forKey:@"text"];
    [encoder encodeObject:[self getFont] forKey:@"font"];
    [encoder encodeObject:[UIColor colorWithCGColor:self.layer.backgroundColor] forKey:@"backColor"];
}

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (void) RS_commonInit
{
    [self setBackgroundColor:[UIColor clearColor]];
     
    // create the UILabel for the text
    knockoutLabel = [[UILabel alloc] initWithFrame:[self frame]];
    [knockoutLabel setTextAlignment:NSTextAlignmentCenter];
    [knockoutLabel setFont:[UIFont boldSystemFontOfSize:30.0]];
    [knockoutLabel setNumberOfLines:1];
    [knockoutLabel setBackgroundColor:[UIColor clearColor]];
    [knockoutLabel setTextColor:[UIColor whiteColor]];

    // create a nice gradient layer to use as our fill
//    CAGradientLayer *gradientLayer = (CAGradientLayer *)[self layer];
    CALayer *gradientLayer = [self layer];
    [gradientLayer setBackgroundColor:[[UIColor darkGrayColor] CGColor]];
//    [gradientLayer setColors: colors];
//    [gradientLayer setLocations:gradientLocations];
//    [gradientLayer setStartPoint:CGPointMake(0.0, 0.0)];
//    [gradientLayer setEndPoint:CGPointMake(0.0, 1.0)];
    [gradientLayer setCornerRadius:10];
}

- (void)setText:(NSString *)value
{
    if(value != text)
    {
        text = value;
        
        [self updateLabel];
    }
}

-(UIFont*) getFont
{
    return knockoutLabel.font;
}

- (void) setFont:(UIFont*) font
{
    [knockoutLabel setFont:font];

    [self updateLabel];
}

- (void)updateLabel
{
    [knockoutLabel setFrame:self.frame];
    [knockoutLabel setText:[self text]];
    
    // render our label to a UIImage
    // if you remove the call to invertAlpha it will mask the text
    invertedAlphaImage = [[[UIImage imageWithView:knockoutLabel] invertAlpha] CGImage];
    
    // create a new CALayer to use as the mask
    textLayer = [CALayer layer];
    
    // stick the image in the layer
    [textLayer setContents:(id)invertedAlphaImage]; // TODO:Crash debug

    [[self layer] setMask:textLayer];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    // resize the text layer
    [textLayer setFrame:[self bounds]];
}

- (void)dealloc 
{
    CGImageRelease(invertedAlphaImage);
    [knockoutLabel release];
    [textLayer     release];
    [super         dealloc];
}

@end

@implementation UIImage (RSAdditions)

/*
 create a UIImage from a UIView
 */
+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

/*
 get the image to invert its alpha channel
 */
- (UIImage *)invertAlpha
{
    // scale is needed for retina devices
    CGFloat scale = [self scale];
    CGSize size = self.size;
    int width = size.width * scale;
    int height = size.height * scale;
    
    CGColorSpaceRef colourSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char *memoryPool = (unsigned char *)calloc(width*height*4, 1);
    
    CGContextRef context = CGBitmapContextCreate(memoryPool, width, height, 8, width * 4, colourSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(colourSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    for(int y = 0; y < height; y++)
    {
        unsigned char *linePointer = &memoryPool[y * width * 4];
        
        for(int x = 0; x < width; x++)
        {
            linePointer[3] = 255-linePointer[3];
            linePointer += 4;
        }
    }
    
    // get a CG image from the context, wrap that into a
    CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage scale:scale orientation:UIImageOrientationUp];
    
    // clean up
    CGImageRelease(cgImage);
    CGContextRelease(context);
    free(memoryPool);
    
    // and return
    return returnImage;
}
@end
