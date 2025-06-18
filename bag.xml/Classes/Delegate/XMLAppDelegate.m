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

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [UINavigationBar.appearance setBackgroundImage:[UIImage imageNamed:@"DarkUITitleBarBG"] forBarMetrics:UIBarMetricsDefault];
    //[[UIBarButtonItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]} forState:UIControlStateNormal];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"D-UITabBarBG"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"D-ControlState"]];
    
    if ([XMLKeychainUtility checkStringForKey:@"uniqueAppID"] == nil) {
        [XMLUtility FLSetSID];
        [XMLUtility alert:@"Test (X)" withMessage:[NSString stringWithFormat:@"%@\n\n%@", [XMLKeychainUtility loadStringForKey:@"uniqueAppID"], [XMLKeychainUtility loadStringForKey:@"devUUID"]]];
    } else if([XMLKeychainUtility checkStringForKey:@"uniqueAppID"] != nil) {
        //Update check
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

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    // Create managed object model if it's not already created
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"XMLCoreDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"xgold.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort(); // Handle error appropriately
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory where the app's documents are stored (this is the directory Core Data will use to store the SQLite file)
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    return [NSURL fileURLWithPath:documentsDirectory];
}

//whenever app resumes make it send STATUS_RESURRECT updates which are pushed via nsnotification, app will request server with one peculiar request and then update all its data, then update the table view(s) and dictionaries, objects, etc. all that, in a fraction of a secomd. we are smart!!!!111
@end
