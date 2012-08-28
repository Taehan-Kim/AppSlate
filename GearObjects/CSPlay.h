//
//  CSPlay.h
//  AppSlate
//
//  Created by 김태한 on 12. 4. 23..
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

-(void) setShowList:(NSNumber*)BoolValue;
-(NSNumber*) getShowList;

-(void) setPlayNStop:(NSNumber*)BoolValue;
-(NSNumber*) getPlayNStop;

-(void) setShuffleMode:(NSNumber*)BoolValue;
-(NSNumber*) getShuffleMode;

-(void) setRepeatMode:(NSNumber*)BoolValue;
-(NSNumber*) getRepeatMode;

-(void) setSkipToNext:(NSNumber*)BoolValue;
-(NSNumber*) getSkipToNext;

-(void) setSkipToPre:(NSNumber*)BoolValue;
-(NSNumber*) getSkipToPre;

@end
