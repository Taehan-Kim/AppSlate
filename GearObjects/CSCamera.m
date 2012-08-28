//
//  CSCamera.m
//  AppSlate
//
//  Created by 김 태한 on 12. 5. 10..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "CSCamera.h"
#import "CSAppDelegate.h"

@implementation CSCamera

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setShow:(NSNumber*)BoolValue
{
    // YES 값인 경우만 반응하자.
    if( ![BoolValue boolValue] )
        return;

    // Does it have a camera?
    if( ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] )
        return;

    if( USERCONTEXT.imRunning )
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
            imagePicker.allowsEditing = NO;
            [((CSAppDelegate*)([UIApplication sharedApplication].delegate)).window.rootViewController presentViewController:imagePicker
                                    animated:YES completion:NULL];
        }
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
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_cam.png"]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_CAMERA;
    csResizable = NO;
    csShow = NO;
    
    self.info = NSLocalizedString(@"Camera", @"Camera");

    NSDictionary *d1 = MAKE_PROPERTY_D(@">Show Action", P_BOOL, @selector(setShow:),@selector(getShow));
    pListArray = @[d1];

    NSMutableDictionary MAKE_ACTION_D(@"Selected Image", A_IMG, a1);
    actionArray = @[a1];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_cam.png"]];
    }
    return self;
}

#pragma mark -

-(void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)infoDic
{    
    NSString *mediaType = infoDic[UIImagePickerControllerMediaType];
    [((CSAppDelegate*)([UIApplication sharedApplication].delegate)).window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *image = infoDic[UIImagePickerControllerOriginalImage];

        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:image];
                else
                    EXCLAMATION;
            }
        }
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}

@end
