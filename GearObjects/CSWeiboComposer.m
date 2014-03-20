//
//  CSWeiboComposer.m
//  AppSlate
//
//  Created by Tae Han Kim on 2013. 8. 13..
//  Copyright (c) 2013년 ChocolateSoft. All rights reserved.
//

#import "CSWeiboComposer.h"
#import <Social/Social.h>
#import "CSAppDelegate.h"

@implementation CSWeiboComposer

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setText:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        textStr = txt;
    
    else if([txt isKindOfClass:[NSNumber class]] )
        textStr = [((NSNumber*)txt) stringValue];
}

-(NSString*) getText
{
    return textStr;
}

-(void) setLink:(NSString*)txt;
{
    if( [txt isKindOfClass:[NSString class]] )
        linkStr = txt;
    
    else if([txt isKindOfClass:[NSNumber class]] )
        linkStr = [((NSNumber*)txt) stringValue];
}

-(NSString*) getLink
{
    return linkStr;
}

-(void) setImage:(UIImage *)img
{
    if( [img isKindOfClass:[UIImage class]] )
        image = img;
}

-(UIImage*) getImage
{
    return image;
}

-(void) setShowAction:(NSNumber*)BoolValue
{
    // YES 값인 경우만 반응하자.
    if( ![BoolValue boolValue] )
        return;
    
    if( USERCONTEXT.imRunning &&
       [SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo] )
    {
        SLComposeViewController *weiboCntrlr = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        if( [linkStr length] > 5 && [linkStr hasPrefix:@"http"] )
            [weiboCntrlr addURL:[NSURL URLWithString:linkStr]];
        if( [textStr length] > 1 )
            [weiboCntrlr setInitialText:textStr];
        if( nil != image )
            [weiboCntrlr addImage:image];

        [((CSAppDelegate*)([UIApplication sharedApplication].delegate)).window.rootViewController presentViewController:weiboCntrlr animated:YES completion:NULL];
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
    if( !(self=[super init]) ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_weibo.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_WEIBOSEND;

    csResizable = NO;
    csShow = NO;
    
    textStr = @"Hi!";
    linkStr = @"http://www.facebook.com/AppSlate";
    image = nil;
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Text", P_TXT, @selector(setText:),@selector(getText));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"URL", P_TXT, @selector(setLink:),@selector(getLink));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Image", P_IMG, @selector(setImage:),@selector(getImage));
    NSDictionary *d4 = MAKE_PROPERTY_D(@">Show Action", P_BOOL, @selector(setShowAction:),@selector(getShow));
    pListArray = @[d1,d2,d3,d4];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_weibo.png"]];
        linkStr = [decoder decodeObjectForKey:@"linkStr"];
        textStr = [decoder decodeObjectForKey:@"textStr"];
        image = nil;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:linkStr forKey:@"linkStr"];
    [encoder encodeObject:textStr forKey:@"textStr"];
}

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"CSWeiboSend";
}

-(NSArray*) importLinesCode
{
    return @[@"<Social/Social.h>"];
}

-(NSString*) customClass
{
    NSString *r = @"\n// CSWeiboSend class\n//\n@interface CSWeiboSend : NSObject\n{}\n\
-(void)showComp:(UIViewController*)cont;\n\n\
@property (nonatomic,retain) NSString *name, *caption, *text, *link;\n\
@property (nonatomic,retain) UIImage *image;\n\
@end\n\n\
@implementation CSWeiboSend\n\n\
@synthesize name, caption, text, link, image;\n\n\
-(void)showComp:(UIViewController*)cont\n{\n\
    SLComposeViewController *fbCntrlr = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];\n\
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
