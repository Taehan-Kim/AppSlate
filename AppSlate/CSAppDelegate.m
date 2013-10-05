//
//  CSAppDelegate.m
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 Chocolate Soft. All rights reserved.
//

#import "CSAppDelegate.h"
#import <Parse/Parse.h>
#import "CSMainViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation CSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainViewController = [[CSMainViewController alloc] init];

    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [self loadCachedAppFile];

    USERCONTEXT.inviteCheckEnabled = [defaults boolForKey:@"AppUsageCheck"];

    [Parse setApplicationId:@"your_id"
                  clientKey:@"your_key"];

////[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [self.mainViewController saveAppFile:YES];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    // cache save
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */

    [FBAppEvents activateApp];

    // Check the flag for enabling any prompts. If that flag is on
    // check the app active counter
//    if( !USERCONTEXT.inviteCheckEnabled && [USERCONTEXT.facebook isSessionValid] &&
//       [self checkAppUsageTrigger] )
//    {
//        // If the user should be prompter to invite friends, show
//        // an alert with the choices.
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"Invite Friends"
//                              message:@"If you enjoy using this app, would you mind taking a moment to invite a few friends that you think will also like it?"
//                              delegate:self
//                              cancelButtonTitle:@"No Thanks"
//                              otherButtonTitles:@"Tell Friends!", @"Remind Me Later", nil];
//        [alert show];
//    }
}

/*
 * When the alert is dismissed check which button was clicked so
 * you can take appropriate action, such as displaying the request
 * dialog, or setting a flag not to prompt the user again.
 */
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        // User has clicked on the No Thanks button, do not ask again
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setBool:YES forKey:@"AppUsageCheck"];
//        [defaults synchronize];
//        USERCONTEXT.inviteCheckEnabled = YES;
//    } else if (buttonIndex == 1) {
//        // User has clicked on the Tell Friends button
//        [self performSelector:@selector(fbookFeed) withObject:nil afterDelay:1.0];
//    }
//}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (BOOL) checkAppUsageTrigger {
    // Initialize the app active count
    NSInteger appActiveCount = 0;
    // Read the stored value of the counter, if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"AppUsedCounter"]) {
        appActiveCount = [defaults integerForKey:@"AppUsedCounter"];
    }
    
    // Increment the counter
    appActiveCount++;
    BOOL trigger = NO;
    // Only trigger the prompt if the facebook session is valid and
    // the counter is greater than a certain value, 3 in this sample
    if( 5 == appActiveCount ) {
        trigger = YES;
        appActiveCount = 0;
    }
    // Save the updated counter
    [defaults setInteger:appActiveCount forKey:@"AppUsedCounter"];
    [defaults synchronize];
    return trigger;
}

#pragma mark -

-(void) loadCachedAppFile
{
    NSString *cachePath, *tmp;

#ifdef TARGET_IPHONE_SIMULATOR
    tmp = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
#else
    tmp = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#endif
    cachePath = [tmp stringByAppendingString:@"/AppSlate"];

    if( [[NSFileManager defaultManager] isReadableFileAtPath:cachePath] )
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_FILELOAD
                                                            object:cachePath];
}

@end
