//
//  XMLUser.h
//  bag.xml
//
//  Created by XML on 11/05/25.
//  Copyright (c) 2025 D, Mali Coemen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface XMLUser : NSObject

@property NSString *userID;
@property NSString *username;
@property NSString *displayName;
@property UIImage *avatar;
@property bool verified;

@end