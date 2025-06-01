//
//  XMLUserContentViewController.m
//  bag.xml
//
//  Created by XML on 29/05/25.
//  Copyright (c) 2025 Daphne Coemen. All rights reserved.
//

#import "XMLUserContentViewController.h"

@interface XMLUserContentViewController ()

@end

@implementation XMLUserContentViewController

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
    
    [self.navigationItem setTitle:self.user.displayName];
    self.avatar.image = self.user.avatar;
    self.uname.text = self.user.username;
    self.un2.text = self.user.displayName;
    self.acc.text = @"::3 posts, 2 releases and 5 apps.";
    [self.dismissal setBackgroundImage:[UIImage imageNamed:@"UINavigationBarDoneButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.dismissal setBackgroundImage:[UIImage imageNamed:@"UINavigationBarDoneButtonPressed"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.dismissal setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0], UITextAttributeTextShadowColor: [UIColor whiteColor],
                                             UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)]} forState:UIControlStateNormal];
    
}
- (IBAction)dismiss:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setSelectedUser:(XMLUser*)author {
    NSLog(@"eeddd");
    self.user = author;
}




@end
