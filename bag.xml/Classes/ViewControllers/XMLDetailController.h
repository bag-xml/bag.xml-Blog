//
//  XMLDetailController.h
//  bag.xml
//
//  Created by XML on 18/05/25.
//  Copyright (c) 2025 D, Mali Coemen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLPost.h"
#import "XMLUser.h"

#import "XMLUserTableViewCell.h"
#import "XMLPostContent.h"

#import "XMLAppDelegate.h"


#import "XMLUserContentViewController.h"

@interface XMLDetailController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bg;
@property (weak, nonatomic) IBOutlet UILabel *postTitle;

- (void)setSelectedPost:(XMLPost *)post;

@property XMLPost *selectedpost;
@property XMLUser *selecteduser;
@end
