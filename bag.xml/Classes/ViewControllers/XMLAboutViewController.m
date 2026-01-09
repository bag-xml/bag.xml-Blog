//
//  XMLAboutViewController.m
//  bag.xml
//
//  Created by XML on 17/05/25.
//  Copyright (c) 2025 D, Mali Coemen. All rights reserved.
//

#import "XMLAboutViewController.h"

@interface XMLAboutViewController ()

@end

@implementation XMLAboutViewController

- (void)viewWillAppear:(BOOL)animated {
    NSDictionary *titleTextAttributes = @{
                                          UITextAttributeTextColor: [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0],
                                          UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                          UITextAttributeTextShadowColor: [UIColor blackColor]
                                          };
    [self.navigationController.navigationBar setTitleTextAttributes:titleTextAttributes];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if(IS_IPHONE_5) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"A-TableViewBG@R4"]];
    } else if(IS_IPHONE_4) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"A-TableViewBG@2x"]];
    } else if(IS_IPHONE_3GS) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"A-TableViewBG"]];
    }
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@", appVersion];
}


@end
