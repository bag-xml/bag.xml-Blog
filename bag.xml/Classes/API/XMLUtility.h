//
//  XMLUtility.h
//  bag.xml
//
//  Created by XML on 12/04/25.
//  Copyright (c) 2025 Daphne Coemen. All rights reserved.
//

#import "XMLAppDelegate.h"
#import "XMLKeychainUtility.h"
#import "XMLObjectRetriever.h"
#import "Base64.h"

@interface XMLUtility : NSObject

+ (void)FLSetSID;
+ (void)checkForAppUpdate;

+ (void)alert:(NSString*)title withMessage:(NSString*)message;

@property bool outdated;

@end
