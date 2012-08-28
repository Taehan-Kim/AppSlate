//
//  CSImage.m
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 27..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSImage.h"
#import "CSAppDelegate.h"

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

    SEL act;
    NSNumber *nsMagicNum;
    
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:[(UIImageView*)csView image]];
            else
                EXCLAMATION;
        }
    }
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
    return @( (((UIImageView*)csView).contentMode == UIViewContentModeScaleAspectFit) );
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

- (void)setEdit:(NSNumber*) BoolValue
{
    if( ![BoolValue boolValue] )
        return;

    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:((UIImageView*)csView).image];
    [editorController setDelegate:self];
    [((CSAppDelegate*)([UIApplication sharedApplication].delegate)).window.rootViewController
     presentViewController:editorController animated:YES completion:NULL];
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

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Image", P_IMG, @selector(setImage:),@selector(getImage));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Aspect Fit", P_BOOL, @selector(setAspectFit:),@selector(getAspectFit));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Background Color", P_COLOR, @selector(setBackgroundColor:),@selector(getBackgroundColor));
    NSDictionary *d4 = MAKE_PROPERTY_D(@">Edit Action", P_BOOL, @selector(setEdit:), @selector(getEdit));
    pListArray = @[xc,yc,d0,d1,d2,d3,d4];


    NSMutableDictionary MAKE_ACTION_D(@"Changed Image", A_IMG, a1);
    actionArray = @[a1];

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

#pragma mark - AFPhotoEditDelegate

- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    [(UIImageView*)csView setImage:image];
    [editor dismissViewControllerAnimated:YES completion:NULL];

    SEL act;
    NSNumber *nsMagicNum;
    
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:[(UIImageView*)csView image]];
            else
                EXCLAMATION;
        }
    }
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    // Handle cancelation here
    [editor dismissViewControllerAnimated:YES completion:NULL];
}

@end
