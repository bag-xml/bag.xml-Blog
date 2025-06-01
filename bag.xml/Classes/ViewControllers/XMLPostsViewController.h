//
//  XMLPostsViewController.h
//  bag.xml
//
//  Created by XML on 14/05/25.
//  Copyright (c) 2025 Daphne Coemen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMLPost.h"
#import "XMLPostCell.h"
#import "XMLAppDelegate.h"
#import "XMLUtility.h"

#import "XMLDetailController.h"

@interface XMLPostsViewController : UITableViewController

@property NSMutableArray *posts;

@end
