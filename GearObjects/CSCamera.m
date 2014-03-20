//
//  CSCamera.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 5. 10..
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

-(void) setShowAction:(NSNumber*)BoolValue
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
    if( !(self = [super init]) ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_cam.png"]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_CAMERA;
    csResizable = NO;
    csShow = NO;
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@">Show Action", P_BOOL, @selector(setShowAction:),@selector(getShow));
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

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"MPMusicPlayerController";
}

-(NSArray*) importLinesCode
{
    return @[@"<AVFoundation/AVFoundation.h>"];
}

// viewDidLoad 에서 alloc - init 하지 않을 것일때는 NO_FIRST_ALLOC 을 리턴하자.
-(NSString*) customClass
{
    return NO_FIRST_ALLOC;
}

-(NSString*) delegateName
{
    return @"UINavigationControllerDelegate, UIImagePickerControllerDelegate";
}

-(NSArray*) delegateCodes
{
    SEL act;
    NSNumber *nsMagicNum;
    
    NSMutableString *code = [NSMutableString stringWithFormat:@"    if([%@ isEqual:picker]){\n",varName];
    // code 추가. actionArray 에 연결된 CSGearObject 의 메소드를 호출하는 코드 작성 & 삽입.
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;

    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);

        [code appendString:@"    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){\n\
        UIImage *image = infoDic[UIImagePickerControllerOriginalImage];\n"];
        [code appendFormat:@"        [%@ %@image];\n    }\n",[gObj getVarName],@(sel_name_c)];
    }
    [code appendString:@"    }\n"];

    return @[@"-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)infoDic\n{\n\
    NSString *mediaType = infoDic[UIImagePickerControllerMediaType];\n\
    [self dismissViewControllerAnimated:YES completion:NULL];\n",code,@"}\n\n"];
}


-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    if( [apName isEqualToString:@"setShowAction:"] ){
        return @"    // Does it have a camera?\n    if( ![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] ) return;\n\
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])\n\
    {\n\
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];\n\
        imagePicker.delegate = self;\n\
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;\n\
        imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];\n\
        imagePicker.allowsEditing = NO;\n\
        [self presentViewController:imagePicker animated:YES completion:NULL];\n\
    }\n";
    }
    return nil;
}
@end
