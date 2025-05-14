//
//  XMLPost.h
//  bag.xml
//
//  Created by XML on 14/05/25.
//  Copyright (c) 2025 Daphne Coemen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLPost : NSObject

@property bool isFeatured;
@property bool isNew;
@property bool justShowOff;

@property NSString *date;
@property NSString *image; //b64
@property NSString *summary;
@property NSString *text;
@property NSString *title;

@property int type;
@property int postID;
@property int authorID;
@end
