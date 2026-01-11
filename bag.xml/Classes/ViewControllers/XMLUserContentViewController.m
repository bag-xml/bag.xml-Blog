//
//  XMLUserContentViewController.m
//  bag.xml
//
//  Created by XML on 29/05/25.
//  Copyright (c) 2025 D, Mali Coemen. All rights reserved.
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
    
    NSFetchRequest *appRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *appEntity =
    [NSEntityDescription entityForName:@"App"
                inManagedObjectContext:context];
    
    [appRequest setEntity:appEntity];
    NSArray *appResults =
    [context executeFetchRequest:appRequest error:&error];
    
    if (appResults == nil) {
        NSLog(@"App fetch error: %@", error);
    }

    
    self.posts = [[NSMutableArray alloc] init];
    self.apps = [[NSMutableArray alloc] init];
    
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
        
        if ([[post valueForKey:@"justShowOff"] boolValue]) {
            continue; // skip this post
        }
        
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
    
    for (NSManagedObject *app in appResults) {
        NSLog(@"%@", app);
        XMLApp *newApp = XMLApp.new;
        
        newApp.appID = [[app valueForKey:@"appID"] intValue];
        newApp.authorID = [[app valueForKey:@"authorID"] intValue];
        
        newApp.appName = [app valueForKey:@"appName"];
        newApp.authorName = [app valueForKey:@"authorName"];
        newApp.date = [app valueForKey:@"date"];
        newApp.desc = [app valueForKey:@"desc"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *base64String = [[app valueForKey:@"icon"] stringByReplacingOccurrencesOfString:@"data:image/png;base64," withString:@""];
            NSData *imageData = [NSData dataWithBase64EncodedString:base64String];
            dispatch_async(dispatch_get_main_queue(), ^{
                newApp.appIcon = [UIImage imageWithData:imageData];
            });
        });
        
        newApp.itmlLink = [app valueForKey:@"itmlLink"];
        newApp.publisher = [app valueForKey:@"publisher"];
        newApp.version = [app valueForKey:@"version"];
        
        [self.apps addObject:newApp];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    NSLog(@"Fetched %d posts and %d apps", [self.posts count], [self.apps count]);
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
        NSInteger count = 0;
        for(XMLApp *app in self.apps) {
            count++;
        }
        return count;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 43.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 43.5)];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:headerView.bounds];
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    backgroundImageView.image = [UIImage imageNamed:@"uplainSeparator"];
    [headerView addSubview:backgroundImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width - 20, 43.5)];
    label.textColor = [UIColor colorWithRed:67.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
    
    label.layer.shadowColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
    label.layer.shadowOffset = CGSizeMake(0, 1);
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];

    
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
        XMLPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"POST"];
        cell.heading.text = currentPost.title;
        cell.spoiler.text = [NSString stringWithFormat:@"by %@ :: %@", currentPost.authorName, currentPost.date];
        cell.count.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
        BOOL isLastRow = indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1;
        cell.separato.hidden = isLastRow;

        
        return cell;
    } else if (indexPath.section == 1) { //type 3
        XMLPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RELEASE"];
        cell.heading.text = currentPost.title;
        cell.spoiler.text = [NSString stringWithFormat:@"by %@ :: %@", currentPost.authorName, currentPost.date];
        cell.count.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
        BOOL isLastRow = indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1;
        cell.separato.hidden = isLastRow;

        
        return cell;
    } else if (indexPath.section == 2) { //app
        XMLApp *currentApp = self.apps[indexPath.row];
        XMLAPPCELL *cell = [tableView dequeueReusableCellWithIdentifier:@"APP"];
        cell.appIcon.image = [UIImage imageNamed:@"Display-App-Icon"];
        cell.title.text = currentApp.appName;
        cell.count.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
        cell.spoiler.text = [NSString stringWithFormat:@"%@ :: by %@",currentApp.version, currentApp.authorName];
        BOOL isLastRow = indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1;
        cell.separator.hidden = isLastRow;
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 || indexPath.section == 1) {
        XMLPost *currentPost = self.posts[indexPath.row];
        if(currentPost.justShowOff == NO) {
            //prepare for segue to post view.
            [self performSegueWithIdentifier:@"to Post" sender:self];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    } else if(indexPath.section == 2) {
        [self performSegueWithIdentifier:@"to App" sender:self];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"to Post"]){
        
        //need index path as XMLPost property in setSelectedPost
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        XMLPost *selectedPost = self.posts[selectedIndexPath.row];
        [((XMLDetailController*)segue.destinationViewController) setSelectedPost:selectedPost];
    } else if([segue.identifier isEqualToString:@"to App"]){
        //need index path as XMLPost property in setSelectedPost
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"ERROR");
        XMLApp *selectedApp = self.apps[selectedIndexPath.row];
        [((XMLAppViewController*)segue.destinationViewController) setSelectedApp:selectedApp];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 81;
}

@end
