//
//  CSPlay.m
//  AppSlate
//
//  Created by Taehan Kim on 12. 4. 23..
//  Copyright (c) 2012년 ChocolateSoft. All rights reserved.
//

#import "CSPlay.h"
#import "CSAppDelegate.h"

@implementation CSPlay

-(id) object
{
    return (csView);
}

//===========================================================================

-(void) setShowList:(NSNumber*)BoolValue
{
    if( USERCONTEXT.imRunning )
    {
        MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];

        mediaPicker.delegate = self;
        mediaPicker.allowsPickingMultipleItems = YES;
        mediaPicker.prompt = @"Select songs to play";
        
        [((CSAppDelegate*)([UIApplication sharedApplication].delegate)).window.rootViewController presentViewController:mediaPicker animated:YES completion:NULL];
    }
}

-(NSNumber*) getShowList
{
    return @NO;
}

-(void) setPlayNStop:(NSNumber*)BoolValue
{
    if( USERCONTEXT.imRunning )
    {
//        if ([musicPlayer playbackState] == MPMusicPlaybackStatePlaying) {
        if( ![BoolValue boolValue] )
        {
            [musicPlayer pause];
        } else {
            [musicPlayer play];
        }
    }
}

-(NSNumber*) getPlayNStop
{
    return @NO;
}

-(void) setShuffleMode:(NSNumber*)BoolValue
{
    BOOL value;
    if( [BoolValue isKindOfClass:[NSString class]] )
        value = [(NSString*)BoolValue boolValue];
    else if( [BoolValue isKindOfClass:[NSNumber class]] )
        value = [BoolValue boolValue];
    else
        return;

    if( value )
        [musicPlayer setShuffleMode:MPMusicShuffleModeSongs];
    else
        [musicPlayer setShuffleMode:MPMusicShuffleModeOff];
}

-(NSNumber*) getShuffleMode
{
    return@(MPMusicShuffleModeOff != [musicPlayer shuffleMode]);
}

-(void) setRepeatMode:(NSNumber*)BoolValue
{
    BOOL value;
    if( [BoolValue isKindOfClass:[NSString class]] )
        value = [(NSString*)BoolValue boolValue];
    else if( [BoolValue isKindOfClass:[NSNumber class]] )
        value = [BoolValue boolValue];
    else
        return;
    
    if( value )
        [musicPlayer setShuffleMode:MPMusicRepeatModeOne];
    else
        [musicPlayer setShuffleMode:MPMusicRepeatModeNone];
}

-(NSNumber*) getRepeatMode
{
    return@(MPMusicRepeatModeNone != [musicPlayer repeatMode]);
}

-(void) setSkipToNext:(NSNumber*)BoolValue
{
    if( ![BoolValue boolValue] ) return;
    
    [musicPlayer skipToNextItem];
}

-(NSNumber*) getSkipToNext
{
    return @NO;
}

-(void) setSkipToPre:(NSNumber*)BoolValue
{
    if( ![BoolValue boolValue] ) return;

    [musicPlayer skipToPreviousItem];
}

-(NSNumber*) getSkipToPre
{
    return @NO;
}

#pragma mark -

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
    if (mediaItemCollection)
    {
        [musicPlayer setQueueWithItemCollection: mediaItemCollection];
        [musicPlayer play];
    }
    
    [mediaPicker dismissViewControllerAnimated:YES completion:NULL];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [mediaPicker dismissViewControllerAnimated:YES completion:NULL];
}

//===========================================================================

#pragma mark -

-(id) initGear
{
    if( ![super init] ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_play.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_PLAY;
    
    csResizable = NO;
    csShow = NO;

    musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [self registerMediaPlayerNotifications];

    NSDictionary *d1 = MAKE_PROPERTY_D(@">Show List Action", P_BOOL, @selector(setShowList:),@selector(getShowList));
    NSDictionary *d2 = MAKE_PROPERTY_D(@">Play or Stop", P_BOOL, @selector(setPlayNStop:),@selector(getPlayNStop));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Soungs Shuffle On", P_BOOL, @selector(setShuffleMode:),@selector(getShuffleMode));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Soung Repeat On", P_BOOL, @selector(setRepeatMode:),@selector(getRepeatMode));
    NSDictionary *d5 = MAKE_PROPERTY_D(@">Skip to Next Item", P_BOOL, @selector(setSkipToNext:),@selector(getSkipToNext));
    NSDictionary *d6 = MAKE_PROPERTY_D(@">Skip to Previous Item", P_BOOL, @selector(setSkipToPre:),@selector(getSkipToPre));
    pListArray = @[d1,d2,d3,d4,d5,d6];

    NSMutableDictionary MAKE_ACTION_D(@"Play or Stop", A_NUM, a1);
    NSMutableDictionary MAKE_ACTION_D(@"Music Title", A_TXT, a2);
    NSMutableDictionary MAKE_ACTION_D(@"Music Artist", A_TXT, a3);
    NSMutableDictionary MAKE_ACTION_D(@"Music Album", A_TXT, a4);
    NSMutableDictionary MAKE_ACTION_D(@"Music Artwork", A_IMG, a5);
    actionArray = @[a1,a2,a3,a4,a5];
    
    return self;
}

- (void) registerMediaPlayerNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_NowPlayingItemChanged:)
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                             object: musicPlayer];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_PlaybackStateChanged:)
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                             object: musicPlayer];
    
    [notificationCenter addObserver: self
                           selector: @selector (handle_VolumeChanged:)
                               name: MPMusicPlayerControllerVolumeDidChangeNotification
                             object: musicPlayer];
    
    [musicPlayer beginGeneratingPlaybackNotifications];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    if( (self=[super initWithCoder:decoder]) ) {
        [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_play.png"]];
        musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
        [self registerMediaPlayerNotifications];
    }
    return self;
}

#pragma mark - Delegate

- (void) handle_PlaybackStateChanged: (id) notification
{
    MPMusicPlaybackState playbackState = [musicPlayer playbackState];

    if (playbackState == MPMusicPlaybackStateStopped) {
        [musicPlayer stop];        
    }

    SEL act;
    NSNumber *nsMagicNum;

    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:@(playbackState)];
            else
                EXCLAMATION;
        }
    }

}

- (void) handle_NowPlayingItemChanged: (id) notification
{
    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];

    SEL act;
    NSNumber *nsMagicNum;
    NSString *tmpStr;

    act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];

        tmpStr = [currentItem valueForProperty:MPMediaItemPropertyTitle];
        if(!tmpStr) {
            tmpStr = @"Unknown title";
        }

        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:tmpStr];
            else
                EXCLAMATION;
        }
    }

    act = ((NSValue*)((NSDictionary*)actionArray[2])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[2])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];

        tmpStr = [currentItem valueForProperty:MPMediaItemPropertyArtist];
        if(!tmpStr) {
            tmpStr = @"Unknown artist";
        }
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:tmpStr];
            else
                EXCLAMATION;
        }
    }

    act = ((NSValue*)((NSDictionary*)actionArray[3])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[3])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        tmpStr = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        if(!tmpStr) {
            tmpStr = @"Unknown album";
        }
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:tmpStr];
            else
                EXCLAMATION;
        }
    }

    act = ((NSValue*)((NSDictionary*)actionArray[4])[@"selector"]).pointerValue;
    if( nil != act ){
        nsMagicNum = ((NSDictionary*)actionArray[4])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        
        UIImage *artworkImage = [UIImage imageNamed:@"noArtworkImage.png"];
        MPMediaItemArtwork *artwork = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
        
        if (artwork) {
            artworkImage = [artwork imageWithSize: CGSizeMake (250, 252)];
        }
        
        if( nil != gObj ){
            if( [gObj respondsToSelector:act] )
                [gObj performSelector:act withObject:artworkImage];
            else
                EXCLAMATION;
        }
    }
}

- (void) handle_VolumeChanged:(id) notification
{
//    [volumeSlider setValue:[musicPlayer volume]];
}

//- (void)volumeChanged:(id)sender
//{
//    [musicPlayer setVolume:[volumeSlider value]];
//}

@end
