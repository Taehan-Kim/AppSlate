//
//  CSTwitComposer.m
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 21..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSTwitComposer.h"
#import <Twitter/TWTweetComposeViewController.h>
#import "CSAppDelegate.h"

@implementation CSTwitComposer

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

-(void) setShow:(NSNumber*)BoolValue
{
    // YES 값인 경우만 반응하자.
    if( ![BoolValue boolValue] )
        return;
    
    if( USERCONTEXT.imRunning && [TWTweetComposeViewController canSendTweet] )
    {
        TWTweetComposeViewController *twtCntrlr = [[TWTweetComposeViewController alloc] init];
        if( [linkStr length] > 5 && [linkStr hasPrefix:@"http"] )
            [twtCntrlr addURL:[NSURL URLWithString:linkStr]];
        if( [textStr length] > 1 )
            [twtCntrlr setInitialText:textStr];
        if( nil != image )
            [twtCntrlr addImage:image];

        [((CSAppDelegate*)([UIApplication sharedApplication].delegate)).window.rootViewController presentModalViewController:twtCntrlr animated:YES];
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
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_tweet.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_TWITSEND;

    csResizable = NO;
    csShow = NO;

    self.info = NSLocalizedString(@"Tweet Composer", @"Tweet Composer");

    textStr = @"Hi!";
    linkStr = @"http://www.facebook.com/AppSlate";
    image = nil;

    NSDictionary *d1 = MAKE_PROPERTY_D(@"Text", P_TXT, @selector(setText:),@selector(getText));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"URL", P_TXT, @selector(setLink:),@selector(getLink));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Image", P_IMG, @selector(setImage:),@selector(getImage));
    NSDictionary *d4 = MAKE_PROPERTY_D(@">Show Action", P_BOOL, @selector(setShow:),@selector(getShow));
    pListArray = [NSArray arrayWithObjects:d1,d2,d3,d4, nil];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_tweet.png"]];
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

@end
