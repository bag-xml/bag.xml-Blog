//
//  XMLAppViewController.h
//  bag.xml
//
//  Created by XML on 10/01/26.
//  Copyright (c) 2026 Daphne Coemen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMLPost.h"
#import "XMLUser.h"
#import "XMLApp.h"

#import "XMLUserTableViewCell.h"
#import "XMLPostContent.h"
#import "XMLAppViewController.h"

#import "XMLAppDelegate.h"
#import "XMLUtility.h"

#import "XMLUserContentViewController.h"

@interface XMLAppViewController : UITableViewController

- (void)setSelectedApp:(XMLApp *)app;

@property XMLApp *selectedapp;
@property XMLUser *selecteduser;

@end
