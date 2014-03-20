//
//  CSMailComposer.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 21..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSMailComposer.h"
#import "CSAppDelegate.h"
#import "NSData+Base64.h"

@implementation CSMailComposer

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setText:(NSString*)txt
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

-(void) setTitle:(NSString*)txt
{
    if( [txt isKindOfClass:[NSString class]] )
        titleStr = txt;
    
    else if([txt isKindOfClass:[NSNumber class]] )
        titleStr = [((NSNumber*)txt) stringValue];
}

-(NSString*) getTitle
{
    return titleStr;
}

-(void) setToAddr:(NSString*)txt
{
    if( [txt isKindOfClass:[NSString class]] )
        toAddressStr = txt;
    
    else if([txt isKindOfClass:[NSNumber class]] )
        toAddressStr = [((NSNumber*)txt) stringValue];
}

-(NSString*) getToAddr
{
    return toAddressStr;
}

-(void) setCcAddr:(NSString*)txt
{
    if( [txt isKindOfClass:[NSString class]] )
        ccAddressStr = txt;
    
    else if([txt isKindOfClass:[NSNumber class]] )
        ccAddressStr = [((NSNumber*)txt) stringValue];
}

-(NSString*) getCcAddr
{
    return ccAddressStr;
}

-(void) setImage:(UIImage *)img
{
    if( [img isKindOfClass:[UIImage class]] )
        mailImage = img;
}

-(UIImage*) getImage
{
    return mailImage;
}

-(void) setShowAction:(NSNumber*)BoolValue
{
    // YES 값인 경우만 반응하자.
    if( ![BoolValue boolValue] )
        return;

    if( USERCONTEXT.imRunning ){
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:titleStr];
        if( nil != toAddressStr )
            [picker setToRecipients:@[toAddressStr]];
        if( nil != ccAddressStr )
            [picker setCcRecipients:@[ccAddressStr]];
        NSMutableString *emailBody = [[NSMutableString alloc] initWithString:@"<html><body>"];
        [emailBody appendFormat:@"<p>%@</p>", textStr];
        if( nil != mailImage ){
            NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(mailImage)];
            NSString *base64String = [imageData base64EncodedString];
            [emailBody appendFormat:@"<p><b><img src='data:image/png;base64,%@'></b></p>",base64String];
        }
        [emailBody appendString:@"</body></html>"];
        [picker setMessageBody:emailBody isHTML:YES];

        //[self.view addSubview:picker.view];
        [((CSAppDelegate*)([UIApplication sharedApplication].delegate)).window.rootViewController presentViewController:picker animated:YES completion:NULL];
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
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_mail.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_MAIL;

    csResizable = NO;
    csShow = NO;
    mailImage = nil;

    titleStr = @"My E-mail";
    textStr = @"AppSlate is awesome.";
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Title", P_TXT, @selector(setTitle:),@selector(getTitle));
    NSDictionary *d2 = MAKE_PROPERTY_D(@"Mail Text", P_TXT, @selector(setText:),@selector(getText));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"To Recipient", P_TXT, @selector(setToAddr:),@selector(getToAddr));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Cc Recipient", P_TXT, @selector(setCcAddr:),@selector(getCcAddr));
    NSDictionary *d5 = MAKE_PROPERTY_D(@"Image", P_IMG, @selector(setImage:),@selector(getImage));
    NSDictionary *d6 = MAKE_PROPERTY_D(@">Show Action", P_BOOL, @selector(setShowAction:),@selector(getShow));
    pListArray = @[d1,d2,d3,d4,d5,d6];

    NSMutableDictionary MAKE_ACTION_D(@"Closed", A_NUM, a1);
    actionArray = @[a1];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_mail.png"]];
        titleStr = [decoder decodeObjectForKey:@"titleStr"];
        textStr = [decoder decodeObjectForKey:@"textStr"];
        toAddressStr = [decoder decodeObjectForKey:@"toAddressStr"];
        ccAddressStr = [decoder decodeObjectForKey:@"ccAddressStr"];
        mailImage = nil;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:titleStr forKey:@"titleStr"];
    [encoder encodeObject:textStr forKey:@"textStr"];
    [encoder encodeObject:toAddressStr forKey:@"toAddressStr"];
    [encoder encodeObject:ccAddressStr forKey:@"ccAddressStr"];
}


#pragma mark -

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{
    NSString *message;
    BOOL goodOrBad = NO;

	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message = NSLocalizedString(@"Your E-mail has canceled.",@"mail cancel");// @"메일 전송이 취소되었습니다.";
			break;
		case MFMailComposeResultSaved:
			message = NSLocalizedString(@"Your E-mail has saved.",@"mal save");// @"메일이 저장되었습니다.";
            goodOrBad = YES;
			break;
		case MFMailComposeResultSent:
			message = NSLocalizedString(@"Your E-mail has sent",@"mail sent"); //@"메일이 전송되었습니다.";
            goodOrBad = YES;
			break;
		case MFMailComposeResultFailed:
			message = NSLocalizedString(@"Fail to send the mail.",@"mail fail"); //@"메일 전송이 실패하였습니다.";
			break;
		default:
			message = NSLocalizedString(@"I Can not send the mail now.",@"mail cant"); //@"메일 전송이 되지 않습니다.";
			break;
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"E-Mail"
													message:message
												   delegate:nil cancelButtonTitle:@"Confirm"
										  otherButtonTitles: nil];
	[alert show];	
	
	[controller dismissViewControllerAnimated:YES completion:NULL];

    SEL act;
    NSNumber *nsMagicNum;

    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:@(goodOrBad)];
            else
                EXCLAMATION;
        }
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
    return @"CSMail";
}

-(NSArray*) importLinesCode
{
    return @[@"<MessageUI/MessageUI.h>",@"<MessageUI/MFMailComposeViewController.h>"];
}

-(NSString*) delegateName
{
    return @"MFMailComposeViewControllerDelegate";
}

-(NSString*) customClass
{
    NSString *r = @"\n// CSMail class\n//\n@interface CSMail : NSObject\n{}\n\
-(void)showMailCom:(UIViewController*)cont;\n\n\
@property (nonatomic,retain) NSString *title, *text, *toAddr, *ccAddr;\n\
@property (nonatomic,retain) UIImage *image;\n\
@end\n\n\
@implementation CSMail\n\n\
@synthesize title, text, toAddr, ccAddr, image;\n\n\
-(void)showMailCom:(UIViewController*)cont\n{\n\
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];\n\
    picker.mailComposeDelegate = cont;\n\
    [picker setSubject:self.title];\n\n\
    if( nil != self.toAddr )\n\
        [picker setToRecipients:@[self.toAddr]];\n\
    if( nil != ccAddr )\n\
        [picker setCcRecipients:@[self.ccAddr]];\n\n\
    NSMutableString *emailBody = [[NSMutableString alloc] initWithString:@\"<html><body>\"];\n\
    [emailBody appendFormat:@\"<p>%@</p>\", self.text];\n\
    if( nil != self.image ){\n\
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(self.image)];\n\
        NSString *base64String = [imageData base64EncodedString];\n\
        [emailBody appendFormat:@\"<p><b><img src='data:image/png;base64,%@'></b></p>\",base64String];\n\
    }\n\
    [emailBody appendString:@\"</body></html>\"];\n\
    [picker setMessageBody:emailBody isHTML:YES];\n\n\
    [cont presentViewController:picker animated:YES completion:NULL];\n}\n\n\
@end\n\n";

    return r;
}

-(NSArray*) delegateCodes
{
    SEL act;
    NSNumber *nsMagicNum;
    
    NSMutableString *code1 = [NSMutableString stringWithFormat:@"    if([%@ isEqual:controller]){\n",varName];
    
    // code 추가. actionArray 에 연결된 CSGearObject 의 메소드를 호출하는 코드 작성 & 삽입.
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    // [connectedVarName selectorName:@(buttonIndex)];
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        
        [code1 appendFormat:@"        [%@ %@@(YES)];\n",[gObj getVarName],@(sel_name_c)];
    }
    [code1 appendString:@"    }\n"];
    
    return @[@"- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error\n{\n    switch (result)\n    {\n\
             // do your works...\
        case MFMailComposeResultSent:\n            break;\n\
        case MFMailComposeResultCancelled:\n            break;\n\
        // etc...\n\
        }\n    }\n",code1,@"}\n\n"];
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    if( [apName isEqualToString:@"setShowAction:"] ){

        return [NSString stringWithFormat:@"[%@ showMailCom:self];",varName];
    }
    return nil;
}

@end
