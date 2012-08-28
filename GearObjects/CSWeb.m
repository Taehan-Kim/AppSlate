//
//  CSWeb.m
//  AppSlate
//
//  Created by 김 태한 on 12. 2. 29..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSWeb.h"

@implementation CSWeb

-(id) object
{
    return ((UIWebView*)csView);
}

//===========================================================================
#pragma mark -

-(void) setURL:(NSString*) _urlStr
{
    if( [_urlStr isKindOfClass:[NSString class]] ){
        urlStr = [_urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
        [((UIWebView*)csView) loadRequest:request];
    } else {
        EXCLAMATION;
    }
}

-(NSString*) getURL
{
    return urlStr;
}

-(void) setScaleFit:(NSNumber*)BoolValue
{
    BOOL value;

    if( [BoolValue isKindOfClass:[NSString class]] )
        value = [(NSString*)BoolValue boolValue];
    else if( [BoolValue isKindOfClass:[NSNumber class]] )
        value = [BoolValue boolValue];
    else
        return;

    [((UIWebView*)csView) setScalesPageToFit:value];
    [((UIWebView*)csView) reload];
}

-(NSNumber*) getScaleFit
{
    return@( ((UIWebView*)csView).scalesPageToFit );
}

-(void) setReloadAction:(NSNumber*)act
{
    if( [act boolValue] ){
        [((UIWebView*)csView) reload];
    }
}

-(NSNumber*) getReloadAction
{
    return @NO;
}

-(void) setBackAction:(NSNumber*)act
{
    if( [act boolValue] ){
        [((UIWebView*)csView) goBack];
    }
}

-(NSNumber*) getBackAction
{
    return @NO;
}

-(void) setForwardAction:(NSNumber*)act
{
    if( [act boolValue] ){
        [((UIWebView*)csView) goForward];
    }
}

-(NSNumber*) getForwardAction
{
    return @NO;
}

-(void) setStopAction:(NSNumber*)BoolValue
{
    if( [BoolValue boolValue] ){
        [((UIWebView*)csView) stopLoading];
    }
}

-(NSNumber*) getStopAction
{
    return @NO;
}


#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [csView setBackgroundColor:[UIColor whiteColor]];
    [(UIWebView*)csView setDelegate:self];
    [(UIWebView*)csView setScalesPageToFit:YES];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_IMAGE;
    isUIObj = YES;
    
    self.info = NSLocalizedString(@"Web View", @"Web View");
    urlStr = @"http://";

    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"URL", P_TXT, @selector(setURL:),@selector(getURL));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Scale Fit", P_BOOL, @selector(setScaleFit:),@selector(getScaleFit));
    NSDictionary *d3 = MAKE_PROPERTY_D(@">Reload", P_BOOL, @selector(setReloadAction:),@selector(getReloadAction));
    NSDictionary *d4 = MAKE_PROPERTY_D(@">Go Back", P_BOOL, @selector(setBackAction:),@selector(getBackAction));
    NSDictionary *d5 = MAKE_PROPERTY_D(@">Go Forward", P_BOOL, @selector(setForwardAction:),@selector(getForwardAction));
    NSDictionary *d6 = MAKE_PROPERTY_D(@">Stop", P_BOOL, @selector(setStopAction:),@selector(getStopAction));
    pListArray = @[xc,yc,d0,d1,d2,d3,d4,d5,d6];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        urlStr = [decoder decodeObjectForKey:@"urlStr"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:urlStr forKey:@"urlStr"];
}

#pragma mark - Delegate

-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    return YES;
}

-(void) webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
