//
//  CSAppDelegate.m
//  AppSlate
//
//  Created by 태한 김 on 11. 11. 9..
//  Copyright (c) 2011년 Chocolate Soft. All rights reserved.
//

#import "CSAppDelegate.h"

#import "CSMainViewController.h"

@implementation CSAppDelegate

@synthesize window = _window;
@synthesize mainViewController = _mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.mainViewController = [[CSMainViewController alloc] initWithNibName:@"CSMainViewController_iPhone" bundle:nil];
    } else {
        self.mainViewController = [[CSMainViewController alloc] initWithNibName:@"CSMainViewController_iPad" bundle:nil];
    }

    USERCONTEXT.facebook = [[Facebook alloc] initWithAppId:@"269841146424285" andDelegate:self];

    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];

    // facebook SSO
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        USERCONTEXT.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        USERCONTEXT.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }

    [self loadCachedAppFile];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [USERCONTEXT.facebook handleOpenURL:url]; 
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -

- (void)fbDidLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[USERCONTEXT.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[USERCONTEXT.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"facebook" message:@"Connected." delegate:nil cancelButtonTitle:@"Confirm" otherButtonTitles: nil];
    [alert show];
}

- (void) fbDidLogout {
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"facebook" message:@"Disconnected." delegate:nil cancelButtonTitle:@"Confirm" otherButtonTitles: nil];
    [alert show];
}

#pragma mark -

-(void) loadCachedAppFile
{
    NSString *cachePath, *tmp;

#ifdef TARGET_IPHONE_SIMULATOR
    tmp = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
#else
    tmp = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#endif
    cachePath = [tmp stringByAppendingString:@"/AppSlate"];

    if( [[NSFileManager defaultManager] isReadableFileAtPath:cachePath] )
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_FILELOAD
                                                            object:cachePath];
}

@end
