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
    [self.dismissal setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0], UITextAttributeTextShadowColor: [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1.0],
                                             UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)]} forState:UIControlStateNormal];
    
}
- (IBAction)dismiss:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setSelectedUser:(XMLUser*)author {
    NSLog(@"user selected");
    self.user = author;
    
    XMLAppDelegate *appDelegate = (XMLAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSLog(@"Username %@, UserID %@", self.user.username, self.user.userID);
    
    // Convert userID from NSString to NSNumber
    NSNumber *userIDNumber = [NSNumber numberWithInt:[author.userID intValue]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"author == %@", userIDNumber];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
   
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];

    
    if (error) {
        NSLog(@"Error fetching posts: %@", error);
        return;
    }
    
    self.posts = [[NSMutableArray alloc] init];
    
    for (NSManagedObject *post in results) {
        XMLPost *newPost = XMLPost.new;

        
        newPost.title = [post valueForKey:@"title"];
        newPost.date = [post valueForKey:@"date"];
        newPost.text = [post valueForKey:@"text"];
        //newPost.image = [post valueForKey:@"image"];
        newPost.summary = [post valueForKey:@"summary"];
        
        newPost.authorName = [post valueForKey:@"authorName"];
        newPost.isFeatured = [[post valueForKey:@"isFeatured"] boolValue];
        newPost.isNew = [[post valueForKey:@"isNew"] boolValue];
        newPost.justShowOff = [[post valueForKey:@"justShowOff"] boolValue];
        
        newPost.type = [[post valueForKey:@"type"] intValue];
        newPost.postID = [[post valueForKey:@"postID"] intValue];
        newPost.authorID = [[post valueForKey:@"author"] intValue];
        
        float contentWidth = UIScreen.mainScreen.bounds.size.width - 30;
        CGSize textSize = [newPost.text sizeWithFont:[UIFont systemFontOfSize:16]
                                   constrainedToSize:CGSizeMake(contentWidth, MAXFLOAT)
                                       lineBreakMode:NSLineBreakByWordWrapping];
        newPost.tCH = textSize.height + 75;
        
        [self.posts addObject:newPost];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    NSLog(@"Fetched %d posts", [self.posts count]);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        NSInteger count = 0;
        for(XMLPost *post in self.posts) {
            if(post.type == 2) {
                count++;
            }
        }
        return count;
    } else if (section == 1) {
        NSInteger count = 0;
        for(XMLPost *post in self.posts) {
            if(post.type == 3) {
                count++;
            }
        }
        return count;
    } else if(section == 2) {
        //apps arent implemented
        return 0;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:headerView.bounds];
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width - 20, 18)];
    label.textColor = [UIColor colorWithRed:158.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0];
    
    label.layer.shadowColor = [UIColor blackColor].CGColor;
    label.layer.shadowOffset = CGSizeMake(0, 1);
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    
    [headerView addSubview:backgroundImageView];
    if (section == 0) {
        label.text = @"Posts";
    } else if (section == 1) {
        label.text = @"Releases";
    } else if (section == 2) {
        label.text = @"Apps";
    }
    
    [headerView addSubview:label];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMLPost *currentPost = self.posts[indexPath.row];
    if (indexPath.section == 0) { //type 2
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"POST"];
        cell.textLabel.text = currentPost.title;
        cell.detailTextLabel.text = currentPost.summary;
        
        return cell;
    } else if (indexPath.section == 1) { //type 3
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RELEASE"];
        cell.textLabel.text = currentPost.title;
        cell.detailTextLabel.text = currentPost.summary;
        
        return cell;
    } else if (indexPath.section == 2) { //app
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"APP"];
        cell.textLabel.text = @"s31";
        cell.detailTextLabel.text = @"samsung galax y s13";
        
        return cell;
    }
    return nil;
}

@end
