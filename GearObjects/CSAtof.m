//
//  CSAtof.m
//  AppSlate
//
//  Created by Taehan Kim 태한 김 on 12. 2. 24..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSAtof.h"

@implementation CSAtof

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setInputStringAction:(NSString*) str
{
    if( [str isKindOfClass:[NSNumber class]] )
        return;

    CGFloat value = [str floatValue];

    if( HUGE_VAL == value || -HUGE_VAL == value ){
        EXCLAMATION;
        return;
    }

    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@(value)];
                else
                    EXCLAMATION;
            }
        }
    }
}

-(NSString*) getInputString
{
    return @"";
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_atof.png"]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_ATOF;

    csResizable = NO;
    csShow = NO;

    NSDictionary *d1 = MAKE_PROPERTY_D(@">Input Text", P_TXT, @selector(setInputStringAction:),@selector(getInputString));
    pListArray = @[d1];

    NSMutableDictionary MAKE_ACTION_D(@"Output Number", A_NUM, a1);
    actionArray = @[a1];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_atof.png"]];
    }
    return self;
}

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return YES;
}

// viewDidLoad 에서 alloc - init 하지 않을 것일때는 NO_FIRST_ALLOC 을 리턴하자.
-(NSString*) customClass
{
    return NO_FIRST_ALLOC;
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    if( [apName isEqualToString:@"setInputStringAction:"] ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( act )
        {
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            const char *sel_name_c = sel_getName(act);
            return [NSString stringWithFormat:@"[%@ %@@([@\"%@\" floatValue])];\n",[gObj getVarName],@(sel_name_c),val];
        }
    }
    return nil;
}

@end
