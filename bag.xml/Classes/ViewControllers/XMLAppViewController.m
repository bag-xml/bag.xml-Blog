//
//  XMLAppViewController.m
//  bag.xml
//
//  Created by XML on 10/01/26.
//  Copyright (c) 2026 Daphne Coemen. All rights reserved.
//

#import "XMLAppViewController.h"

@interface XMLAppViewController ()

@end

@implementation XMLAppViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(IS_IPHONE_5) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"A-TableViewBG@R4"]];
    } else if(IS_IPHONE_4) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"A-TableViewBG@2x"]];
    } else if(IS_IPHONE_3GS) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"A-TableViewBG"]];
    }
}

- (void)setSelectedApp:(XMLApp *)app {
    self.selectedapp = app;
    self.navigationItem.title = self.selectedapp.appName;
}

/*
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
*/
@end
