//
//  CSImage.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 27..
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

-(void) setContentMode:(NSNumber*) value
{
    NSUInteger var;
    if( [value isKindOfClass:[NSString class]] )
        var = [(NSString*)value integerValue];
    else  if( [value isKindOfClass:[NSNumber class]] )
        var = [value integerValue];
    else
        return;

    [(UIImageView*)csView setContentMode:var];
}

-(NSNumber*) getContentMode
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

- (void)setEditAction:(NSNumber*) BoolValue
{
    if( ![BoolValue boolValue] || nil == ((UIImageView*)csView).image )
        return;

    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:((UIImageView*)csView).image];
    [editorController setDelegate:self];
    [((CSAppDelegate*)([UIApplication sharedApplication].delegate)).window.rootViewController
     presentViewController:editorController animated:YES completion:NULL];
}

- (BOOL)getEdit
{
    return NO;
}

- (void) setSaveAction:(NSNumber*) BoolValue
{
    if( ![BoolValue boolValue] || nil == ((UIImageView*)csView).image )
        return;

    UIImageWriteToSavedPhotosAlbum(((UIImageView*)csView).image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    START_WAIT_VIEW;
}

- (BOOL)getSave
{
    return NO;
}

- (void) image:(UIImage *)image didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo
{
    STOP_WAIT_VIEW;
}

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [csView setBackgroundColor:[UIColor grayColor]];
    [csView setUserInteractionEnabled:YES];
    [(UIImageView*)csView setContentMode:UIViewContentModeScaleAspectFit];

    csCode = CS_IMAGE;
    isUIObj = YES;

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Image", P_IMG, @selector(setImage:),@selector(getImage));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Content Mode (0,1,2)", P_NUM, @selector(setContentMode:),@selector(getContentMode));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Background Color", P_COLOR, @selector(setBackgroundColor:),@selector(getBackgroundColor));
    NSDictionary *d4 = MAKE_PROPERTY_D(@">Edit Action", P_BOOL, @selector(setEditAction:), @selector(getEdit));
    NSDictionary *d5 = MAKE_PROPERTY_D(@">Save to Album", P_BOOL, @selector(setSaveAction:), @selector(getSave));
    pListArray = @[xc,yc,d0,d1,d2,d3,d4,d5];


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

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"UIImageView";
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    if( [apName isEqualToString:@"setEditAction:"] ){
        return @"// Connect to Aviary editor or something...";
    } else if( [apName isEqualToString:@"setSaveAction:"] ){
        return [NSString stringWithFormat:@"UIImageWriteToSavedPhotosAlbum(%@).image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);",varName];
    }
    return nil;
}

@end
