//
//  XMLObjectTestView.m
//  bag.xml
//
//  Created by XML on 11/05/25.
//  Copyright (c) 2025 Daphne Coemen. All rights reserved.
//

#import "XMLObjectTestView.h"

@interface XMLObjectTestView ()

@end

@implementation XMLObjectTestView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(changeDetected) name:@"RESFRESH" object:nil];
    
    XMLAppDelegate *appDelegate = (XMLAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    self.users = [NSMutableArray array];

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES]];
    NSArray *fetchedUsers = [context executeFetchRequest:fetchRequest error:nil];
    for(XMLUser *user in fetchedUsers) {
        XMLUser *newUser = XMLUser.new;
        
        newUser.userID = [user valueForKey:@"userID"];
        newUser.displayName = [user valueForKey:@"displayName"];
        newUser.username = [user valueForKey:@"username"];
        
        NSString *base64String = [user valueForKey:@"avatar"];
        NSData *imageData = [NSData dataWithBase64EncodedString:base64String];
        newUser.avatar = [UIImage imageWithData:imageData];
        
        [self.users addObject:newUser];
    }
    [self.tableView reloadData];
    
}

- (void)changeDetected {
    NSLog(@"Change detected, updating user data)");
    self.users = nil;
    self.users = [NSMutableArray array];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    XMLAppDelegate *appDelegate = (XMLAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"username" ascending:YES]];
    NSArray *fetchedUsers = [context executeFetchRequest:fetchRequest error:nil];
    for(XMLUser *user in fetchedUsers) {
        XMLUser *newUser = XMLUser.new;
        
        newUser.userID = [user valueForKey:@"userID"];
        newUser.displayName = [user valueForKey:@"displayName"];
        newUser.username = [user valueForKey:@"username"];
        
        NSString *base64String = [user valueForKey:@"avatar"];
        NSData *imageData = [NSData dataWithBase64EncodedString:base64String];
        newUser.avatar = [UIImage imageWithData:imageData];
        
        [self.users addObject:newUser];
    }
    [self.tableView reloadData];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XLD" forIndexPath:indexPath];
    XMLUser *user = self.users[indexPath.row];
    cell.detailTextLabel.text = user.username;
    cell.textLabel.text = user.displayName;
    
    return cell;
}


@end
