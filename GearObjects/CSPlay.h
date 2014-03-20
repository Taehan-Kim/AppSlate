//
//  CSPlay.h
//  AppSlate
//
//  Created by Taehan Kim on 12. 4. 23..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CSGearObject.h"

@interface CSPlay : CSGearObject <MPMediaPickerControllerDelegate>
{
    MPMusicPlayerController *musicPlayer;
}

-(id) initGear;

-(void) setShowListAction:(NSNumber*)BoolValue;
-(NSNumber*) getShowList;

-(void) setPlayNStopAction:(NSNumber*)BoolValue;
-(NSNumber*) getPlayNStop;

-(void) setShuffleMode:(NSNumber*)BoolValue;
-(NSNumber*) getShuffleMode;

-(void) setRepeatMode:(NSNumber*)BoolValue;
-(NSNumber*) getRepeatMode;

-(void) setSkipToNextAction:(NSNumber*)BoolValue;
-(NSNumber*) getSkipToNext;

-(void) setSkipToPreAction:(NSNumber*)BoolValue;
-(NSNumber*) getSkipToPre;

@end
