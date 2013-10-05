//
//  CSXor.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 2. 17..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSXor.h"

@implementation CSXor

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setInput1Value:(NSNumber*) BoolValue
{    
    if( [BoolValue isKindOfClass:[NSString class]] )
        value1 = [(NSString*)BoolValue boolValue];
    else if( [BoolValue isKindOfClass:[NSNumber class]] )
        value1 = [BoolValue boolValue];
    else
        return;
    
    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@( !(value1 == value2) )];
                else
                    EXCLAMATION;
            }
        }
        
    }
}

-(NSNumber*) getInput1Value
{
    return @(value1);
}

-(void) setInput2Value:(NSNumber*) BoolValue
{    
    if( [BoolValue isKindOfClass:[NSString class]] )
        value2 = [(NSString*)BoolValue boolValue];
    else if( [BoolValue isKindOfClass:[NSNumber class]] )
        value2 = [BoolValue boolValue];
    else
        return;
    
    if( USERCONTEXT.imRunning ){
        SEL act;
        NSNumber *nsMagicNum;
        
        act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:@( !(value1 == value2) )];
                else
                    EXCLAMATION;
            }
        }
        
    }
}

-(NSNumber*) getInput2Value
{
    return @(value2);
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_xor.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_XOR;

    csResizable = NO;
    csShow = NO;
    
    NSDictionary *d1 = MAKE_PROPERTY_D(@"Input #1", P_NUM, @selector(setInput1Value:),@selector(getInput1Value));
    NSDictionary *d2 = MAKE_PROPERTY_D(@">Input #2", P_NUM, @selector(setInput2Value:),@selector(getInput2Value));
    pListArray = @[d1,d2];
    
    NSMutableDictionary MAKE_ACTION_D(@"Output", A_NUM, a1);
    actionArray = @[a1];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_xor.png"]];
        value1 = [decoder decodeBoolForKey:@"value1"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeBool:value1 forKey:@"value1"];
}

@end
