//
//  XMLAppDelegate.h
//  bag.xml
//
//  Created by bag.xml on 19/06/24.
//  Copyright (c) 2024 Daphne Coemen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLUtility.h"
#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import <CoreData/CoreData.h>

#import "SVProgressHUD.h"

#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double) 568) < DBL_EPSILON)
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double) 480) < DBL_EPSILON)
#define IS_IPHONE_3GS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double) 240) < DBL_EPSILON)

#define VERSION_MIN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define updateChecks YES
#define kAPIURL @"http://5.230.249.85:5001"

#define appVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define CurrentVersionAmalgumHash @"XMLDEBUG"

@interface XMLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
