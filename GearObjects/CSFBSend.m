//
//  CSFBSend.m
//  AppSlate
//
//  Created by 김 태한 on 12. 3. 13..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSFBSend.h"

@implementation CSFBSend

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setName:(NSString*)txt
{
    if( [txt isKindOfClass:[NSString class]] )
        name = txt;
    
    else if([txt isKindOfClass:[NSNumber class]] )
        name = [((NSNumber*)txt) stringValue];
}

-(NSString*) getName
{
    return name;
}

-(void) setCaption:(NSString*)txt
{
    if( [txt isKindOfClass:[NSString class]] )
        caption = txt;

    else if([txt isKindOfClass:[NSNumber class]] )
        caption = [((NSNumber*)txt) stringValue];
}

-(NSString*) getCaption
{
    return caption;
}

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

-(void) setShow:(NSNumber*)BoolValue
{
    // YES 값인 경우만 반응하자.
    if( ![BoolValue boolValue] )
        return;

    if( USERCONTEXT.imRunning ){
        NSMutableDictionary *params = 
        [NSMutableDictionary dictionaryWithObjectsAndKeys:
            name, @"name",
            caption, @"caption",
            message, @"description",
            link, @"link",
///         @"http://fbrell.com/f8.jpg", @"picture",
            nil];  
        [USERCONTEXT.facebook dialog:@"feed"
                           andParams:params andDelegate:self];
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
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_fbook.png"]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_FBSEND;
    
    csResizable = NO;
    csShow = NO;

    self.info = NSLocalizedString(@"Facebook Feed", @"Facebook Feed");

    name = @"AppSlate";
    caption = @"Check this app.";
    message = @"";
    link = @"https://www.facebook.com/AppSlate";
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Feed Name", P_TXT, @selector(setName:),@selector(getName));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Feed Caption", P_TXT, @selector(setCaption:),@selector(getCaption));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Text Message", P_TXT, @selector(setText:),@selector(getText));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Link URL", P_TXT, @selector(setLink:),@selector(getLink));
    NSDictionary *d5 = MAKE_PROPERTY_D(@">Show Action", P_BOOL, @selector(setShow:),@selector(getShow));
    pListArray = [NSArray arrayWithObjects:d1,d2,d3,d4,d5, nil];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_fbook.png"]];
        message = [decoder decodeObjectForKey:@"message"];
        name = [decoder decodeObjectForKey:@"name"];
        caption = [decoder decodeObjectForKey:@"caption"];
        link = [decoder decodeObjectForKey:@"link"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:message forKey:@"message"];
    [encoder encodeObject:name forKey:@"name"];
    [encoder encodeObject:caption forKey:@"caption"];
    [encoder encodeObject:link forKey:@"link"];
}

#pragma mark - Delegate

- (void)dialogDidNotComplete:(FBDialog *)dialog
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"error" message:@"Do not completed to feed." delegate:nil cancelButtonTitle:@"Confirm" otherButtonTitles: nil];
    [alert show];
}


@end
