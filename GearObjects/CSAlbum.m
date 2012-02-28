//
//  CSAlbum.m
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 21..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSAlbum.h"
#import "CSAppDelegate.h"

@implementation CSAlbum

-(id) object
{
    return (csView);
}

-(void) setShow:(NSNumber*)BoolValue
{
    // YES 값인 경우만 반응하자.
    if( ![BoolValue isKindOfClass:[NSNumber class]] || NO == [BoolValue boolValue] )
        return;
    
    if( USERCONTEXT.imRunning )
    {
        if( nil == imgPicker ){
            imgPicker = [[UIImagePickerController alloc] init];
            [imgPicker setDelegate:self];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        if( nil == albumPop )
            albumPop = [[UIPopoverController alloc] initWithContentViewController:imgPicker];

        [albumPop presentPopoverFromRect:csView.frame inView:((CSAppDelegate*)([UIApplication sharedApplication].delegate)).window.rootViewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(NSNumber*) getShow
{
    return [NSNumber numberWithBool:NO];
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_album.png"]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_ALBUM;
    
    csResizable = NO;
    csShow = NO;

    self.info = NSLocalizedString(@"Photo Album", @"Photo Album");
    albumPop = nil;
    imgPicker = nil;

    NSDictionary *d1 = MAKE_PROPERTY_D(@">Show Action", P_BOOL, @selector(setShow:),@selector(getShow));
    pListArray = [NSArray arrayWithObjects:d1, nil];

    NSMutableDictionary MAKE_ACTION_D(@"Image Select", A_NUM, a1);
    actionArray = [NSArray arrayWithObjects:a1, nil];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_album.png"]];
        albumPop = nil;
        imgPicker = nil;
    }
    return self;
}

#pragma mark - Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[albumPop dismissPopoverAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)Info
{
    SEL act;
    NSNumber *nsMagicNum;
    
    act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:image];
            else
                EXCLAMATION;
        }
    }
	
	[albumPop dismissPopoverAnimated:YES];
}

@end
