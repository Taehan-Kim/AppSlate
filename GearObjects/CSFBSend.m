//
//  CSFBSend.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 3. 13..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSFBSend.h"
#import <Social/Social.h>
#import "CSAppDelegate.h"

@implementation CSFBSend

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setText:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        message = txt;
    
    else if([txt isKindOfClass:[NSNumber class]] )
        message = [((NSNumber*)txt) stringValue];
}

-(NSString*) getText
{
    return message;
}

-(void) setLink:(NSString*)txt
{
    if( [txt isKindOfClass:[NSString class]] )
        link = txt;
}

-(NSString*) getLink
{
    return link;
}

-(void) setImage:(UIImage*)image
{
    if( ![image isKindOfClass:[UIImage class]] )
    {
        EXCLAMATION;
        return;
    }

    img = image;
}

-(UIImage*) getImage
{
    return img;
}

-(void) setShowAction:(NSNumber*)BoolValue
{
    // YES 값인 경우만 반응하자.
    if( ![BoolValue boolValue] )
        return;

    if( USERCONTEXT.imRunning &&
       [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook] )
    {
        SLComposeViewController *fbCntrlr = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        if( [link length] > 5 && [link hasPrefix:@"http"] )
            [fbCntrlr addURL:[NSURL URLWithString:link]];
        if( [message length] > 1 )
            [fbCntrlr setInitialText:message];
        if( nil != img )
            [fbCntrlr addImage:img];

        [((CSAppDelegate*)([UIApplication sharedApplication].delegate)).window.rootViewController presentViewController:fbCntrlr animated:YES completion:NULL];
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
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_fbook.png"]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_FBSEND;
    
    csResizable = NO;
    csShow = NO;

    message = @"";
    link = @"http://www.facebook.com/AppSlate";
    img = nil;

    NSDictionary *d3 = MAKE_PROPERTY_D(@"Text Message", P_TXT, @selector(setText:),@selector(getText));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Link URL", P_TXT, @selector(setLink:),@selector(getLink));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"Image", P_IMG, @selector(setImage:),@selector(getImage));
    NSDictionary *d6 = MAKE_PROPERTY_D(@">Show Action", P_BOOL, @selector(setShowAction:),@selector(getShow));
    pListArray = @[d3,d4,d5,d6];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_fbook.png"]];
        message = [decoder decodeObjectForKey:@"message"];
        link = [decoder decodeObjectForKey:@"link"];
        img = [decoder decodeObjectForKey:@"img"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:message forKey:@"message"];
    [encoder encodeObject:link forKey:@"link"];
    [encoder encodeObject:img forKey:@"img"];
}

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"CSFBSend";
}

-(NSArray*) importLinesCode
{
    return @[@"<Social/Social.h>"];
}

-(NSString*) customClass
{
    NSString *r = @"\n// CSFBSend class\n//\n@interface CSFBSend : NSObject\n{}\n\
-(void)showComp:(UIViewController*)cont;\n\n\
@property (nonatomic,retain) NSString *name, *caption, *text, *link;\n\
@property (nonatomic,retain) UIImage *image;\n\
@end\n\n\
@implementation CSFBSend\n\n\
@synthesize name, caption, text, link, image;\n\n\
-(void)showComp:(UIViewController*)cont\n{\n\
    SLComposeViewController *fbCntrlr = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];\n\
    if( [self.link length] > 5 && [self.link hasPrefix:@\"http\"] )\n\
    [fbCntrlr addURL:[NSURL URLWithString:self.link]];\n\
    if( [self.text length] > 1 )\n\
    [fbCntrlr setInitialText:self.text];\n\
    if( nil != image )\n\
    [fbCntrlr addImage:image];\n\n\
    [cont presentViewController:twtCntrlr animated:YES completion:NULL];\n\
}\n\n\
@end\n\n";
    
    return r;
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    if( [apName isEqualToString:@"setShowAction:"] ){
        
        return [NSString stringWithFormat:@"[%@ showComp:self];",varName];
    }
    return nil;
}

@end
