//
//  XMLDetailController.m
//  bag.xml
//
//  Created by XML on 18/05/25.
//  Copyright (c) 2025 Daphne Coemen. All rights reserved.
//

#import "XMLDetailController.h"

@interface XMLDetailController ()

@end

@implementation XMLDetailController


- (void)viewDidLoad
{
    [super viewDidLoad];
    //ssp is called earlier than viewdidload so we inherit those
    self.navigationItem.title = self.selectedpost.title;
    self.postTitle.text = self.selectedpost.title;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]}
                                                forState:UIControlStateNormal];
    //aaaaaaaaaa
    if(IS_IPHONE_5) {
        self.bg.image = [UIImage imageNamed:@"AboutTableBG@R4"];
    } else if(IS_IPHONE_4) {
        self.bg.image = [UIImage imageNamed:@"AboutTableBG@2x"];
    } else if(IS_IPHONE_3GS) {
        self.bg.image = [UIImage imageNamed:@"AboutTableBG"];
    }
    [self.tableView reloadData];
}

- (void)setSelectedPost:(XMLPost *)post {
    self.selectedpost = post;
    
    XMLAppDelegate *appDelegate = (XMLAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    // Assuming userID is an NSNumber or integer attribute
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %d", self.selectedpost.authorID];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];
    
    if (results.count > 0) {
        NSManagedObject *user = results[0];
        
        XMLUser *authorIndeed = [XMLUser new];
        authorIndeed.userID = [user valueForKey:@"userID"];
        authorIndeed.username = [user valueForKey:@"username"];
        authorIndeed.displayName = [user valueForKey:@"displayName"];
        authorIndeed.verified = [user valueForKey:@"verified"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *base64String = [[user valueForKey:@"avatar"] stringByReplacingOccurrencesOfString:@"data:image/png;base64," withString:@""];
            NSData *imageData = [NSData dataWithBase64EncodedString:base64String];
            dispatch_async(dispatch_get_main_queue(), ^{
                authorIndeed.avatar = [UIImage imageWithData:imageData];
            });
        });
        self.selecteduser = authorIndeed;
        
        
    } else {
        NSLog(@"UFetchError");
    }
    
    NSLog(@"se %i %@", self.selectedpost.authorID, self.selectedpost.authorName);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.selectedpost.tCH; // thc weed 
    } else if (indexPath.row == 1) {
        return 71.0;
    }
    return 71.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [tableView registerNib:[UINib nibWithNibName:@"XMLTextContentCell" bundle:nil] forCellReuseIdentifier:@"Content"];
        XMLPostContent* cell = [tableView dequeueReusableCellWithIdentifier:@"Content"];
        [cell.textContent setText:self.selectedpost.text];
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *cellIdentifier = @"Userinfo";
        XMLUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        cell.thicklabel.text = self.selecteduser.displayName;
        cell.a.image = self.selecteduser.avatar;
        cell.t.text = [NSString stringWithFormat:@"by %@ :: %@", self.selecteduser.username, self.selectedpost.date];
        //xthinlabel thicklabel und avatar
        return cell;
        
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 1) {
        [self performSegueWithIdentifier:@"to user" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"to user"]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        XMLUserContentViewController *userVC = (XMLUserContentViewController *)navController.topViewController;
        [userVC setSelectedUser:self.selecteduser];
    }
}



@end
