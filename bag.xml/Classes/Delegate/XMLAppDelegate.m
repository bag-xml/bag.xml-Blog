//
//  XMLAppDelegate.m
//  bag.xml
//
//  Created by bag.xml on 19/06/24.
//  Copyright (c) 2024 Daphne Coemen. All rights reserved.
//

#import "XMLAppDelegate.h"

@interface XMLAppDelegate ()

@end

@implementation XMLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([XMLKeychainUtility checkStringForKey:@"uniqueAppID"] == nil) {
        [XMLUtility FLSetSID];
        [XMLUtility alert:@"Test" withMessage:[NSString stringWithFormat:@"%@\n\n%@", [XMLKeychainUtility loadStringForKey:@"uniqueAppID"], [XMLKeychainUtility loadStringForKey:@"devUUID"]]];
    } else if([XMLKeychainUtility checkStringForKey:@"uniqueAppID"] != nil) {
        //Update check
        [XMLUtility alert:@"Test ! Success" withMessage:[NSString stringWithFormat:@"%@\n\n%@", [XMLKeychainUtility loadStringForKey:@"uniqueAppID"], [XMLKeychainUtility loadStringForKey:@"devUUID"]]];
        NSLog(@"App is authenticated");
        //leave this here temporarily
        [XMLUtility checkForAppUpdate];
        [XMLObjectRetriever initObjRetrieval];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//whenever app resumes make it send STATUS_RESURRECT updates which are pushed via nsnotification, app will request server with one peculiar request and then update all its data, then update the table view(s) and dictionaries, objects, etc. all that, in a fraction of a secomd. we are smart!!!!111
@end
