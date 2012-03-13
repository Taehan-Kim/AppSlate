//
//  CSAccelero.m
//  AppSlate
//
//  Created by 김태한 on 12. 3. 3..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSAccelero.h"

@implementation CSAccelero

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setActivate:(NSNumber*) BoolValue
{
    if( [BoolValue isKindOfClass:[NSString class]] )
        isRun = [(NSString*)BoolValue boolValue];
    else  if( [BoolValue isKindOfClass:[NSNumber class]] )
        isRun = [BoolValue boolValue];
    else
        return;
}

-(NSNumber*) getActivate
{
    return [NSNumber numberWithBool:isRun];
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_aclo.png"]];
    [csView setUserInteractionEnabled:YES];

    csCode = CS_NOR;
    
    csResizable = NO;
    csShow = NO;
    
    self.info = NSLocalizedString(@"Accelerometer", @"ACLO");
    ac = [UIAccelerometer sharedAccelerometer];
    [ac setDelegate:self];
    [ac setUpdateInterval:0.5];
    isRun = NO;


    NSDictionary *d1 = MAKE_PROPERTY_D(@"Activate", P_BOOL, @selector(setActivate:),@selector(getActivate));
    pListArray = [NSArray arrayWithObjects:d1, nil];
    
    NSMutableDictionary MAKE_ACTION_D(@"Output X", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Output Y", A_NUM, a2);
    NSMutableDictionary MAKE_ACTION_D(@"Output Z", A_NUM, a3);
    actionArray = [NSArray arrayWithObjects:a1,a2,a3, nil];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_aclo.png"]];
        ac = [UIAccelerometer sharedAccelerometer];
        [ac setDelegate:self];
        [ac setUpdateInterval:0.5];
        isRun = [decoder decodeBoolForKey:@"isRun"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeBool:isRun forKey:@"isRun"];
}

#pragma mark - Delegate

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    if( USERCONTEXT.imRunning && isRun )
    {
//        double alpha = (1.0/60.0) / ((1.0/60.0) + (1.0/5.0));
//        x = acceleration.x * alpha + x * (1.0 - alpha);
//        y = acceleration.y * alpha + y * (1.0 - alpha);
//        z = acceleration.z * alpha + z * (1.0 - alpha);

        SEL act;
        NSNumber *nsMagicNum;

        act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:0] objectForKey:@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:0]) objectForKey:@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[NSNumber numberWithDouble:acceleration.x]];
            }
        }
        act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:1] objectForKey:@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:1]) objectForKey:@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[NSNumber numberWithDouble:acceleration.y]];
            }
        }
        act = ((NSValue*)[(NSDictionary*)[actionArray objectAtIndex:2] objectForKey:@"selector"]).pointerValue;
        if( nil != act ){
            nsMagicNum = [((NSDictionary*)[actionArray objectAtIndex:2]) objectForKey:@"mNum"];
            CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
            
            if( nil != gObj ){
                if( [gObj respondsToSelector:act] )
                    [gObj performSelector:act withObject:[NSNumber numberWithDouble:acceleration.z]];
            }
        }

    }
}

@end
