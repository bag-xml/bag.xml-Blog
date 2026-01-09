//
//  XMLObjectRetriever.h
//  bag.xml
//
//  Created by XML on 24/04/25.
//  Copyright (c) 2025 D, Mali Coemen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLUtility.h"
#import "XMLAppDelegate.h"

@interface XMLObjectRetriever : NSObject

@property bool successfullyAuthenticated;
@property bool hasUIDAuthBehindItself;
+ (BOOL)checkForAuth;
+ (void)initObjRetrieval;
@end
