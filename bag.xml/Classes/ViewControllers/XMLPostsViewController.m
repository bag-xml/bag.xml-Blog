//
//  XMLPostsViewController.m
//  bag.xml
//
//  Created by XML on 14/05/25.
//  Copyright (c) 2025 Daphne Coemen. All rights reserved.
//

#import "XMLPostsViewController.h"

@interface XMLPostsViewController ()

@end

@implementation XMLPostsViewController

- (void)viewWillAppear:(BOOL)animated {
    NSDictionary *titleTextAttributes = @{
                                          UITextAttributeTextColor: [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0],
                                          UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                          UITextAttributeTextShadowColor: [UIColor blackColor]
                                          };
    [self.navigationController.navigationBar setTitleTextAttributes:titleTextAttributes];
    
    [self loadPosts];
}

- (void)viewDidLoad {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(loadPosts) name:@"REFRESH" object:nil];
    //Initiate Post Load Sequence
    [self loadPosts];
    //Visual
    if(IS_IPHONE_5) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"A-TableViewBG@R4"]];
    } else if(IS_IPHONE_4) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"A-TableViewBG@2x"]];
    } else if(IS_IPHONE_3GS) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"A-TableViewBG"]];
    }
    [self.tableView reloadData];
}

- (void)loadPosts {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        XMLAppDelegate *appDelegate = (XMLAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = appDelegate.managedObjectContext;
        
        self.posts = [NSMutableArray array];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        NSArray *fetchedPosts = [context executeFetchRequest:fetchRequest error:nil];
        for(XMLPost *post in fetchedPosts) {
            XMLPost *newPost = XMLPost.new;
            
            if ([[post valueForKey:@"isFeatured"] boolValue] == YES) {
                continue;
            }
            
            newPost.title = [post valueForKey:@"title"];
            newPost.date = [post valueForKey:@"date"];
            newPost.text = [post valueForKey:@"text"];
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
            
            //lets say we also want to create an XMLUser property. we do have newPost.authorID, and in the keychain under the User entity you can fetch the user with the id. Well, go ahead and implement that.
            
            [self.posts addObject:newPost];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XMLPost *currentPost = self.posts[indexPath.row];
    if(currentPost.justShowOff == NO) {
        //prepare for segue to post view.
        [self performSegueWithIdentifier:@"to postview" sender:self];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    XMLPostCell *godahCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (indexPath.row < self.posts.count) {
        XMLPost *currentPost = self.posts[indexPath.row];
        godahCell.heading.text = currentPost.title;
        godahCell.spoiler.text = [NSString stringWithFormat:@"by %@ :: %@", currentPost.authorName, currentPost.date];
        godahCell.count.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    } else {
        godahCell.textLabel.text = @"Loading...";
        godahCell.detailTextLabel.text = @"Please wait";
        godahCell.count.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    }
    
    return godahCell;//by bag.xml - - 2014-01-26
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"to postview"]){

        //need index path as XMLPost property in setSelectedPost
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        XMLPost *selectedPost = self.posts[selectedIndexPath.row];
        [((XMLDetailController*)segue.destinationViewController) setSelectedPost:selectedPost];
    }
}
@end
