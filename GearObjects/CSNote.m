//
//  CSNote.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 3. 20..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSNote.h"
#import "THTTPClient.h"
#import "TBinaryProtocol.h"
#import "NoteStore.h"

NSString * const consumerKey  = @"bladekim";
NSString * const consumerSecret = @"f0d50ab0d379ffe5";
NSString * const userStoreUri = @"https://www.evernote.com/edam/user";
NSString * const noteStoreUriBase = @"https://www.evernote.com/edam/note/"; 
NSString * const applicationName = @"AppSlate";
NSString * const applicationVersion = @"1.1";

@implementation CSNote

-(id) object
{
    return ((UITextView*)csView);
}

//===========================================================================
#pragma mark -

-(void) setText:(NSString*)txt
{
    if( [txt isKindOfClass:[NSString class]] )
        [((UITextView*)csView) setText:txt];
    
    else if([txt isKindOfClass:[NSNumber class]] )
        [((UITextView*)csView) setText:[((NSNumber*)txt) stringValue]];
}

-(NSString*) getText
{
    return ((UITextView*)csView).text;
}

-(void) setTextColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((UITextView*)csView) setTextColor:color];
}

-(UIColor*) getTextColor
{
    return ((UITextView*)csView).textColor;
}

-(void) setBackgroundColor:(UIColor*)color
{
    if( [color isKindOfClass:[UIColor class]] )
        [((UITextView*)csView) setBackgroundColor:color];
}

-(UIColor*) getBackgroundColor
{
    return ((UITextView*)csView).backgroundColor;
}

-(void) setFont:(UIFont*)font
{
    if( [font isKindOfClass:[UIFont class]] )
        [((UITextView*)csView) setFont:font];
}

-(UIFont*) getFont
{
    return ((UITextView*)csView).font;
}

-(void) setUsername:(NSString*)txt
{
    if( [txt isKindOfClass:[NSString class]] )
        userid = txt;

    else if([txt isKindOfClass:[NSNumber class]] )
        userid = [((NSNumber*)txt) stringValue];
}

-(NSString*) getUsername
{
    return userid;
}

-(void) setPassword:(NSString*)txt
{
    if( [txt isKindOfClass:[NSString class]] )
        passwd = txt;
    
    else if([txt isKindOfClass:[NSNumber class]] )
        passwd = [((NSNumber*)txt) stringValue];
}

-(NSString*) getPassword
{
    return passwd;
}

-(void) setEvernote:(NSNumber*)BoolValue
{
    if( NO == [BoolValue boolValue] ) return;

    if( 2 > [userid length] || 2 > [passwd length] ) return;

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title"
                                                          message:nil delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"OK", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setText:title];
//    [renameAlert setTag:kRenameAlert];
    [alert show];
}

-(NSNumber*) getEvernote
{
    return @NO;
}

-(void) setSendText:(NSNumber*)BoolValue
{
    if( NO == [BoolValue boolValue] ) return;

    SEL act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
    
    if( nil == act ) return;  // do nothing

    NSNumber *nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
    
    CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
    
    if( nil != gObj ){
        if( [gObj respondsToSelector:act] )
            [gObj performSelector:act withObject:[(UITextView*)csView text]];
        else
            EXCLAMATION;
    }
}

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 310, 200)];
    [csView setBackgroundColor:[UIColor whiteColor]];
    
    csCode = CS_NOTE;
    isUIObj = YES;

    ((UITextView*)csView).textColor = [UIColor blackColor];
    ((UITextView*)csView).font = CS_FONT(16);
    [(UITextView*)csView setBackgroundColor:CS_RGB(255, 255, 200)];
    [(UITextView*)csView setText:NSLocalizedString(@"Note",@"Note")];
    [(UITextView*)csView setDelegate:self];
    [(UITextView*)csView setUserInteractionEnabled:YES];

    userid = @"";
    passwd = @"";
    title = @"My Memo";
    
    DEFAULT_CENTER_D;
    NSDictionary *d0 = ALPHA_D;
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Text", P_TXT, @selector(setText:),@selector(getText));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Text Color", P_COLOR, @selector(setTextColor:),@selector(getTextColor));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Background Color", P_COLOR, @selector(setBackgroundColor:),@selector(getBackgroundColor));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Text Font", P_FONT, @selector(setFont:),@selector(getFont));
    NSDictionary *d5 = MAKE_PROPERTY_D(@">Send Text", P_BOOL, @selector(setFont:),@selector(getEvernote));
    NSDictionary *d6 = MAKE_PROPERTY_D(@"Evernote ID", P_TXT, @selector(setUsername:),@selector(getUsername));
    NSDictionary *d7 = MAKE_PROPERTY_D(@"Evernote Password", P_TXT, @selector(setPassword:),@selector(getPassword));
    NSDictionary *d8 = MAKE_PROPERTY_D(@">Save to Evernote", P_BOOL, @selector(setEvernote:),@selector(getEvernote));

    pListArray = @[xc,yc,d0,d1,d2,d3,d4,d5,d6,d7,d8];
    
    NSMutableDictionary MAKE_ACTION_D(@"End Editing", A_TXT, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Send Text", A_TXT, a2);
    actionArray = @[a1, a2];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UITextView*)csView setDelegate:self];
        userid = [decoder decodeObjectForKey:@"userid"];
        passwd = [decoder decodeObjectForKey:@"passwd"];
        title = [decoder decodeObjectForKey:@"title"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:userid forKey:@"userid"];
    [encoder encodeObject:passwd forKey:@"passwd"];
    [encoder encodeObject:title forKey:@"title"];
}


#pragma mark - Gear's Unique Actions

// Enter Text 동작.
-(BOOL) textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];

    SEL act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    
    if( nil == act ) return YES;  // do nothing
    
    NSNumber *nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
    
    CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
    
    if( nil != gObj ){
        if( [gObj respondsToSelector:act] )
            [gObj performSelector:act withObject:textView.text];
        else
            EXCLAMATION;
    }
    return YES;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if( 0 == buttonIndex ) return;  // cancel is do nothing.

    START_WAIT_VIEW;

    //----------------------------------------------------------

    if( nil == authToken )
    {
        NSURL * NSURLuserStoreUri = [[NSURL alloc] initWithString: userStoreUri];
        
        THTTPClient *userStoreHttpClient = [[THTTPClient alloc] initWithURL:  NSURLuserStoreUri];
        TBinaryProtocol *userStoreProtocol = [[TBinaryProtocol alloc] initWithTransport:userStoreHttpClient];
        EDAMUserStoreClient *userStore = [[EDAMUserStoreClient alloc] initWithProtocol:userStoreProtocol];
        
        // Check that we can talk to the server
        bool versionOk = [userStore checkVersion: applicationName :[EDAMUserStoreConstants EDAM_VERSION_MAJOR] :    [EDAMUserStoreConstants EDAM_VERSION_MINOR]];
        
        if (!versionOk) {
            // Alerting the user that the note was created
            UIAlertView *alertDone = [[UIAlertView alloc] initWithTitle: @"Evernote" message: @"Incompatible EDAM client protocol version" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
            
            [alertDone show];            
            return;
        }

        
        // Returned result from the Evernote servers after authentication
        EDAMAuthenticationResult* authResult = [userStore authenticate:userid :passwd :consumerKey :consumerSecret];

        // User object describing the account
        user = [authResult user];
        // We are going to save the authentication token
        authToken = [authResult authenticationToken];
        // and the shard id
        shardId = [user shardId];
    }

    title = [alertView textFieldAtIndex:0].text;

    [self performSelector:@selector(performEvernoteSave) withObject:nil afterDelay:0.3];
}

-(void) performEvernoteSave
{    
    NSURL * noteStoreUri;
    EDAMNoteStoreClient *noteStore;

    // Creating the user's noteStore's URL
    noteStoreUri =  [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@", noteStoreUriBase, shardId]];
    
    // Creating the User-Agent
    UIDevice *device = [UIDevice currentDevice];
    NSString * userAgent = [NSString stringWithFormat:@"%@/%@;%@(%@)/%@", applicationName,applicationVersion, [device systemName], [device model], [device systemVersion]]; 
    
    
    // Initializing the NoteStore client
    THTTPClient *noteStoreHttpClient = [[THTTPClient alloc] initWithURL:noteStoreUri userAgent: userAgent timeout:15000];
    TBinaryProtocol *noteStoreProtocol = [[TBinaryProtocol alloc] initWithTransport:noteStoreHttpClient];
    noteStore = [[EDAMNoteStoreClient alloc] initWithProtocol:noteStoreProtocol];
    
    EDAMNote * note = [[EDAMNote alloc] init];
    
    // Setting initial values sent by the user
    note.title = title;
    note.notebookGuid = [[noteStore listNotebooks:authToken][0] guid]; 
    
    NSString * ENML = [NSString stringWithFormat: @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">\n<en-note>%@</en-note>",[((UITextView*)csView).text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"]];
    [note setContent:ENML];
    
    @try {
        [noteStore createNote:authToken :note];
    }
    @catch (EDAMUserException * e) {
        UIAlertView *alertDone = [[UIAlertView alloc] initWithTitle: @"Error" message:@"Can not save." delegate:nil cancelButtonTitle: @"Confirm" otherButtonTitles: nil];
        [alertDone show];
        STOP_WAIT_VIEW;
        return;
    }
    
    // Alerting the user that the note was created
    UIAlertView *alertDone = [[UIAlertView alloc] initWithTitle: @"Evernote" message: @"Note was saved!" delegate:nil cancelButtonTitle: @"OK" otherButtonTitles:nil];
    
    [alertDone show];
    STOP_WAIT_VIEW;
}

@end
