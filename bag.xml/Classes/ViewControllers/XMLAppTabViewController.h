//
//  XMLAppTabViewController.h
//  bag.xml
//
//  Created by XML on 11/01/26.
//  Copyright (c) 2026 Daphne Coemen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMLUtility.h"
#import "XMLAppDelegate.h"

#import "XMLAPPCELL.h"

@interface XMLAppTabViewController : UITableViewController

@property NSMutableArray *apps;

@property (nonatomic, strong) NSArray *sortedCategoryIDs;
@property (nonatomic, strong) NSDictionary *appsByCategory;
@property (nonatomic, strong) NSDictionary *categoryNames;

@end
