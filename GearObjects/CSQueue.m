//
//  CSQueue.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 3. 10..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSQueue.h"

@implementation CSQueue

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setPushValueAction:(id) object
{
    [queue addObject:object];
}

-(id) getPushValue
{
    return nil;
}

-(void) setPopAction:(NSNumber*) BoolValue
{
    if( 0 >= [queue count] ) return;

    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;

        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:queue[0]];
                else
                    EXCLAMATION;
            }
        }
        [queue removeObjectAtIndex:0];
    }
}

-(NSNumber*) getPop
{
    return nil;
}

// Stop 버튼 호출 후 항상 호출되어야 하는 메소드.
-(void) removeAll
{
    [queue removeAllObjects];
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( !(self = [super init]) ) return nil;
   
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_queue.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_QUEUE;
    
    csResizable = NO;
    csShow = NO;
    queue = [[NSMutableArray alloc] initWithCapacity:10];

    NSDictionary *d1 = MAKE_PROPERTY_D(@">Push", P_NUM, @selector(setPushValueAction:),@selector(getPushValue));
    NSDictionary *d2 = MAKE_PROPERTY_D(@">Get", P_NUM, @selector(setPopAction:),@selector(getPop));
    pListArray = @[d1,d2];

    NSMutableDictionary MAKE_ACTION_D(@"Get Output", A_NUM, a1);
    actionArray = @[a1];

    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_queue.png"]];
        queue = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"NSMutableArray";
}

-(NSString*) customClass
{
    return [NSString stringWithFormat:@"    %@ = [[NSMutableArray alloc] initWithCapacity:10];\n", varName];
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    SEL act;
    NSNumber *nsMagicNum;
    
    if( [apName isEqualToString:@"setPushValueAction:"] ){
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( act )
        {
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            return [NSString stringWithFormat:@"[%@ addObject:%@];\n",[gObj getVarName],val];
        }
    }
    if( [apName isEqualToString:@"setPopAction:"] ){
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( act )
        {
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            const char *sel_name_c = sel_getName(act);
            return [NSString stringWithFormat:@"[%@ %@%@[0]];\n    [%@ removeObjectAtIndex:0];\n",[gObj getVarName],@(sel_name_c),varName,varName];
        }
    }
    return nil;
}

@end
