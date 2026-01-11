//
//  XMLAppTabViewController.m
//  bag.xml
//
//  Created by XML on 11/01/26.
//  Copyright (c) 2026 Daphne Coemen. All rights reserved.
//

#import "XMLAppTabViewController.h"

@interface XMLAppTabViewController ()

@end

@implementation XMLAppTabViewController


- (void)viewWillAppear:(BOOL)animated {
    NSDictionary *titleTextAttributes = @{
                                          UITextAttributeTextColor: [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0],
                                          UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                                          UITextAttributeTextShadowColor: [UIColor blackColor]
                                          };
    [self.navigationController.navigationBar setTitleTextAttributes:titleTextAttributes];
    [self loadApps];
}

- (void)viewDidLoad {
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(loadApps) name:@"REFRESH" object:nil];
    NSLog(@"load post");
    //Visual
    [self loadApps];
    if(IS_IPHONE_5) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"A-TableViewBG@R4"]];
    } else if(IS_IPHONE_4) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"A-TableViewBG@2x"]];
    } else if(IS_IPHONE_3GS) {
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"A-TableViewBG"]];
    }
    [self.tableView reloadData];
}

- (void)loadApps {
    //responder
    NSLog(@"Responder???");
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        XMLAppDelegate *appDelegate = (XMLAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = appDelegate.managedObjectContext;
        
        self.apps = [NSMutableArray array];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"App"];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
        NSArray *fetchedApps = [context executeFetchRequest:fetchRequest error:nil];
        for(XMLApp *app in fetchedApps) {
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
            
            newApp.categoryID = [[app valueForKey:@"categoryID"] intValue];
            newApp.categoryName = [app valueForKey:@"categoryName"];
            NSLog(@"how many times?");
            [self.apps addObject:newApp];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            NSLog(@"Apps count: %lu", (unsigned long)self.apps.count);
            [self buildCategoriesFromApps];
            NSLog(@"Categories count: %lu", (unsigned long)self.sortedCategoryIDs.count);

        });
    //});
    
}

- (void)buildCategoriesFromApps {
    
    NSMutableDictionary *groups = [NSMutableDictionary dictionary];
    NSMutableDictionary *names  = [NSMutableDictionary dictionary];
    
    for (XMLApp *app in self.apps) {
        
        NSNumber *catID = [NSNumber numberWithInt:app.categoryID];
        
        if (![groups objectForKey:catID]) {
            [groups setObject:[NSMutableArray array] forKey:catID];
            [names setObject:app.categoryName forKey:catID];
        }
        
        [[groups objectForKey:catID] addObject:app];
    }
    
    // sort category IDs ascending
    self.sortedCategoryIDs = [[groups allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    self.appsByCategory = groups;
    self.categoryNames  = names;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:headerView.bounds];
    backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    backgroundImageView.image = [UIImage imageNamed:@"Felt-Separator"];
    [headerView addSubview:backgroundImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width - 20, 44)];
    label.textColor = [UIColor colorWithRed:67.0/255.0 green:67.0/255.0 blue:67.0/255.0 alpha:1.0];
    
    label.layer.shadowColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
    label.layer.shadowOffset = CGSizeMake(0, 1);
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    
    
    [headerView addSubview:backgroundImageView];
    NSNumber *catID = [self.sortedCategoryIDs objectAtIndex:section];
    label.text = [self.categoryNames objectForKey:catID];
    [headerView addSubview:label];
    return headerView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.sortedCategoryIDs count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSNumber *catID = [self.sortedCategoryIDs objectAtIndex:section];
    NSArray *appsInCategory = (NSArray *)[self.appsByCategory objectForKey:catID];
    return [appsInCategory count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSNumber *catID = [self.sortedCategoryIDs objectAtIndex:indexPath.section];
    NSArray *appsInCategory = (NSArray *)[self.appsByCategory objectForKey:catID];
    XMLApp *currentApp = [appsInCategory objectAtIndex:indexPath.row];
    
    XMLAPPCELL *cell = [tableView dequeueReusableCellWithIdentifier:@"APP"];
    
    cell.appIcon.image = currentApp.appIcon;
    cell.title.text = currentApp.appName;
    cell.count.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    cell.spoiler.text =
    [NSString stringWithFormat:@"%@ :: by %@",
     currentApp.version,
     currentApp.authorName];
    
    BOOL isLastRow =
    indexPath.row == [appsInCategory count] - 1;
    cell.separator.hidden = isLastRow;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 81.0;
}


@end
