//
//  XMLFeaturedController.m
//  bag.xml
//
//  Created by XML on 14/05/25.
//  Copyright (c) 2025 Daphne Coemen. All rights reserved.
//

#import "XMLFeaturedController.h"

@interface XMLFeaturedController ()

@end

@implementation XMLFeaturedController

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
    [self newData];
    //Technical
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(newData) name:@"REFRESH" object:nil];
    
    //Visual
    if(IS_IPHONE_5) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AboutTableBG@R4"]];
    } else if(IS_IPHONE_4) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AboutTableBG@2x"]];
    } else if(IS_IPHONE_3GS) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AboutTableBG"]];
    }
    [self.tableView reloadData];
}

- (void)newData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        XMLAppDelegate *appDelegate = (XMLAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = appDelegate.managedObjectContext;
        
        self.posts = [NSMutableArray array];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        NSArray *fetchedPosts = [context executeFetchRequest:fetchRequest error:nil];
        for(XMLPost *post in fetchedPosts) {
            XMLPost *newPost = XMLPost.new;
            
            if (![[post valueForKey:@"isFeatured"] boolValue]) {
                continue;
            }
            
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
    });

}


//T

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMLPost *currentPost = self.posts[indexPath.row];
    
    if(currentPost.type == 2) { //regular
        static NSString *cellIdentifier = @"aaaaaaaa";
        XMLHomeTableViewCell *godahCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        godahCell.footer.text = currentPost.title;
        godahCell.dateandName.text = [NSString stringWithFormat:@"by %@ :: %@", currentPost.authorName, currentPost.date];
        
        godahCell.contentText.text = currentPost.summary;
        return godahCell;
    } else if(currentPost.type == 3) { //new release
        static NSString *cellIdentifier = @"bbbbbbbb";
        XMLHomeTableViewCell *godahCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        
        
        godahCell.footer.text = currentPost.title;
        godahCell.dateandName.text = [NSString stringWithFormat:@"by %@ :: %@", currentPost.authorName, currentPost.date];
        
        //no summary
        return godahCell;
    } else if(currentPost.type == 1) { //blog
        
        static NSString *cellIdentifier = @"godahleaks";
        XMLHomeTableViewCell *godahCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        
        
        godahCell.footer.text = currentPost.title;
        godahCell.contentText.text = currentPost.summary;
        godahCell.dateandName.text = [NSString stringWithFormat:@"by %@ :: %@", currentPost.authorName, currentPost.date];
        return godahCell;
    }
    
    return nil;//by bag.xml - - 2014-01-26
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XMLPost *currentPost = self.posts[indexPath.row];
    if(currentPost.justShowOff == NO) {
        //prepare for segue to post view.
        [self performSegueWithIdentifier:@"to postview" sender:self];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"to postview"]){
        
        //need index path as XMLPost property in setSelectedPost
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        XMLPost *selectedPost = self.posts[selectedIndexPath.row];
        [((XMLDetailController*)segue.destinationViewController) setSelectedPost:selectedPost];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMLPost *curP = self.posts[indexPath.row];
    
    switch (curP.type) {
        case 1:
            return 301;
        case 2:
            return 244;
        case 3:
            return 334;
        default:
            return 0;
    }
}

@end
