//
//  XMLApp.h
//  bag.xml
//
//  Created by XML on 01/06/25.
//  Copyright (c) 2025 D, Mali Coemen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLApp : NSObject

@property int appID;
@property int authorID;
@property int *categoryID;

@property NSString *appName;
@property NSString *authorName;
@property NSString *categoryName;
@property NSString *date;
@property NSString *desc;
@property NSString *icon;
@property UIImage *appIcon;
@property NSString *itmlLink;
@property NSString *publisher;
@property NSString *version;

@end
