//
//  XMLUserContentViewController.h
//  bag.xml
//
//  Created by XML on 29/05/25.
//  Copyright (c) 2025 Daphne Coemen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMLUtility.h"
#import "XMLUser.h"
#import "XMLPost.h"

#import "XMLAppDelegate.h"

@interface XMLUserContentViewController : UITableViewController

- (void)setSelectedUser:(XMLUser*)author;
@property XMLUser *user;
@property NSInteger userID;
@property NSMutableArray *posts;



@property (weak, nonatomic) IBOutlet UILabel *acc;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *dismissal;
@property (weak, nonatomic) IBOutlet UILabel *un2;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *uname;
@end
