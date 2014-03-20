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

-(void) setShowListAction:(NSNumber*)BoolValue
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

-(void) setPlayNStopAction:(NSNumber*)BoolValue
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

-(void) setSkipToNextAction:(NSNumber*)BoolValue
{
    if( ![BoolValue boolValue] ) return;
    
    [musicPlayer skipToNextItem];
}

-(NSNumber*) getSkipToNext
{
    return @NO;
}

-(void) setSkipToPreAction:(NSNumber*)BoolValue
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
    if( !(self = [super init]) ) return nil;
    
    csView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 33, 33)];
    [(UIImageView*)csView setImage:[UIImage imageNamed:@"gi_play.png"]];
    [csView setUserInteractionEnabled:YES];
    
    csCode = CS_PLAY;
    
    csResizable = NO;
    csShow = NO;

    musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    [self registerMediaPlayerNotifications];

    NSDictionary *d1 = MAKE_PROPERTY_D(@">Show List Action", P_BOOL, @selector(setShowListAction:),@selector(getShowList));
    NSDictionary *d2 = MAKE_PROPERTY_D(@">Play or Stop", P_BOOL, @selector(setPlayNStopAction:),@selector(getPlayNStop));
    NSDictionary *d3 = MAKE_PROPERTY_D(@"Soungs Shuffle On", P_BOOL, @selector(setShuffleMode:),@selector(getShuffleMode));
    NSDictionary *d4 = MAKE_PROPERTY_D(@"Soung Repeat On", P_BOOL, @selector(setRepeatMode:),@selector(getRepeatMode));
    NSDictionary *d5 = MAKE_PROPERTY_D(@">Skip to Next Item", P_BOOL, @selector(setSkipToNextAction:),@selector(getSkipToNext));
    NSDictionary *d6 = MAKE_PROPERTY_D(@">Skip to Previous Item", P_BOOL, @selector(setSkipToPreAction:),@selector(getSkipToPre));
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

#pragma mark - Code Generator

// If not supported gear, return NO.
-(BOOL) setDefaultVarName:(NSString *) _name
{
    return [super setDefaultVarName:NSStringFromClass([self class])];
}

-(NSString*) sdkClassName
{
    return @"MPMusicPlayerController";
}

-(NSArray*) importLinesCode
{
    return @[@"<MediaPlayer/MediaPlayer.h>"];
}

-(NSString*) delegateName
{
    return @"MPMediaPickerControllerDelegate";
}

-(NSString*) customClass
{
    return [NSString stringWithFormat:@"    *%@ = [MPMusicPlayerController iPodMusicPlayer];\n\
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];\n\
    [notificationCenter addObserver: self\n\
                           selector: @selector (handle_NowPlayingItemChanged:)\n\
                               name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification\n\
                             object: musicPlayer];\n\
    [notificationCenter addObserver: self\n\
                           selector: @selector (handle_PlaybackStateChanged:)\n\
                               name: MPMusicPlayerControllerPlaybackStateDidChangeNotification\n\
                             object: musicPlayer];\n\
    [%@ beginGeneratingPlaybackNotifications];\n",varName,varName];
}

-(NSArray*) delegateCodes
{
    SEL act;
    NSNumber *nsMagicNum;

    NSMutableString *code1 = [[NSMutableString alloc] initWithCapacity:50];
    [code1 appendFormat:@"    MPMusicPlaybackState playbackState = [%@ playbackState];\n\
     if (playbackState == MPMusicPlaybackStateStopped)\n        [%@ stop];\n", varName, varName];
    
    act = ((NSValue*)((NSDictionary*)actionArray[0])[@"selector"]).pointerValue;
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[0])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        [code1 appendFormat:@"        [%@ %@@(playbackState)];\n",[gObj getVarName],@(sel_name_c)];
    }

    NSMutableString *code2 = [[NSMutableString alloc] initWithCapacity:50];
    
    act = ((NSValue*)((NSDictionary*)actionArray[1])[@"selector"]).pointerValue;
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[1])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        
        [code2 appendFormat:@"        [%@ %@[currentItem valueForProperty:MPMediaItemPropertyTitle]];\n",[gObj getVarName],@(sel_name_c)];
    }

    act = ((NSValue*)((NSDictionary*)actionArray[2])[@"selector"]).pointerValue;
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[2])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        
        [code2 appendFormat:@"        [%@ %@[currentItem MPMediaItemPropertyArtist]];\n",[gObj getVarName],@(sel_name_c)];
    }

    act = ((NSValue*)((NSDictionary*)actionArray[3])[@"selector"]).pointerValue;
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[3])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        
        [code2 appendFormat:@"        [%@ %@[currentItem MPMediaItemPropertyAlbumTitle]];\n",[gObj getVarName],@(sel_name_c)];
    }

    act = ((NSValue*)((NSDictionary*)actionArray[4])[@"selector"]).pointerValue;
    if( act )
    {
        nsMagicNum = ((NSDictionary*)actionArray[4])[@"mNum"];
        CSGearObject *gObj = [USERCONTEXT getGearWithMagicNum:nsMagicNum.integerValue];
        const char *sel_name_c = sel_getName(act);
        
        [code2 appendFormat:@"        [%@ %@[currentItem MPMediaItemPropertyArtwork]];\n",[gObj getVarName],@(sel_name_c)];
    }

    return @[@"- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection\n{\n",
    [NSString stringWithFormat:@"    if (mediaItemCollection)\n    {\n\
        [%@ setQueueWithItemCollection: mediaItemCollection];\n\
        [%@ play];\n    }\n\n\
        [mediaPicker dismissViewControllerAnimated:YES completion:NULL];\n",varName,varName],@"    }\n\n",
@"- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker\n{\n",
    [NSString stringWithFormat:@"    [%@ dismissViewControllerAnimated:YES completion:NULL];\n",varName],@"}\n",
         @"- (void) handle_PlaybackStateChanged: (id) notification\n{\n",code1,@"}\n\n",
         @"- (void) handle_NowPlayingItemChanged: (id) notification\n{\n    MPMediaItem *currentItem = [musicPlayer nowPlayingItem];\n",code2,@"}\n\n"];
}

-(NSString*) actionPropertyCode:(NSString*)apName valStr:(NSString *)val
{
    if( [apName isEqualToString:@"setShowListAction:"] ){
        
        return @"MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];\n\n\
    mediaPicker.delegate = self;\n\
    mediaPicker.allowsPickingMultipleItems = YES;\n\
    mediaPicker.prompt = @\"Select songs to play\";\n\
    [self presentViewController:mediaPicker animated:YES completion:NULL];\n";
    }

    if( [apName isEqualToString:@"setPlayNStopAction:"] ) {
        return [NSString stringWithFormat:@"if ([%@ playbackState] == MPMusicPlaybackStatePlaying)\n        [%@ pause];\n    else\n        [%@ stop];\n", varName, varName, varName];
    }

    if( [apName isEqualToString:@"setSkipToNextAction:"] ) {
        return [NSString stringWithFormat:@"[%@ skipToNextItem];", varName];
    }

    if( [apName isEqualToString:@"setSkipToPreAction:"] ) {
        return [NSString stringWithFormat:@"[%@ skipToPreviousItem];", varName];
    }

    return nil;
}

@end
