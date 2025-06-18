//
//  XMLObjectRetriever.m
//  bag.xml
//
//  Created by XML on 24/04/25.
//  Copyright (c) 2025 Daphne Coemen. All rights reserved.
//  hell class fuck this shit fuck this shit
//

#import "XMLObjectRetriever.h"

@implementation XMLObjectRetriever


+ (void)initObjRetrieval {
    //getALL getPosts, getUsers, getValidVersions, anything, all separate.
    if([XMLObjectRetriever checkForAuth] == YES) {
        NSLog(@"Auth Check Success");
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
           NSURL *randomEndpoint = [NSURL URLWithString:[NSString stringWithFormat:@"%@/total?a=%@&id=%@", kAPIURL, CurrentVersionAmalgumHash, [XMLKeychainUtility loadStringForKey:@"uniqueAppID"]]];
           NSURLResponse *response;
           NSError *error;
           
           NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
           [request setURL:randomEndpoint];
           [request setHTTPMethod:@"GET"];
           [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

           NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]; //wtf
           if(data) {
               NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
               if([response[@"success"] boolValue] == NO) {
                   [XMLUtility alert:@"An error occured" withMessage:@"Please try again later"];
                   return;
               } else {
                   bool overlap = false;
                   NSArray *usersArray = response[@"data"][@"users"];
                   NSArray *postsArray = response[@"data"][@"posts"];
                   NSArray *appsArray = response[@"data"][@"apps"];
                   
                   XMLAppDelegate *appDelegate = (XMLAppDelegate *)[[UIApplication sharedApplication] delegate];
                   NSManagedObjectContext *context = appDelegate.managedObjectContext;
                   
                   for (NSDictionary *userDict in usersArray) {
                       NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
                       fetchRequest.predicate = [NSPredicate predicateWithFormat:@"userID == %@", userDict[@"userID"]];
                       
                       NSError *error = nil;
                       NSArray *existingUsers = [context executeFetchRequest:fetchRequest error:&error];
                       NSManagedObject *user = nil;
                       
                       if (existingUsers.count > 0) {
                           user = existingUsers.firstObject;
                           overlap = YES;
                       } else {
                           user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
                           overlap = NO;
                       }
                       
                       [user setValue:userDict[@"avatar"] forKey:@"avatar"];
                       [user setValue:userDict[@"verified"] forKey:@"verified"];
                       [user setValue:userDict[@"userID"] forKey:@"userID"];
                       [user setValue:userDict[@"username"] forKey:@"username"];
                       [user setValue:userDict[@"displayName"] forKey:@"displayName"];
                   }
                   
                   for (NSDictionary *postDict in postsArray) {
                       NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
                       fetchRequest.predicate = [NSPredicate predicateWithFormat:@"postID == %@", postDict[@"postID"]];
                       
                       NSError *error = nil;
                       NSArray *existingPosts = [context executeFetchRequest:fetchRequest error:&error];
                       NSManagedObject *post = nil;
                       
                       if (existingPosts.count > 0) {
                           post = existingPosts.firstObject;
                           overlap = YES;
                       } else {
                           post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:context];
                           overlap = NO;
                       }
                       NSDictionary *authorContent = [postDict objectForKey:@"author"];
                       [post setValue:postDict[@"authorID"] forKey:@"author"];
                       [post setValue:authorContent[@"displayName"] forKey:@"authorName"];
                       [post setValue:postDict[@"date"] forKey:@"date"];
                       [post setValue:postDict[@"image"] forKey:@"image"]; //b64str
                       [post setValue:postDict[@"isFeatured"] forKey:@"isFeatured"]; //b
                       [post setValue:postDict[@"isNew"] forKey:@"isNew"]; //bool
                       [post setValue:postDict[@"justShowOff"] forKey:@"justShowOff"]; //b
                       [post setValue:postDict[@"postID"] forKey:@"postID"];
                       [post setValue:postDict[@"summary"] forKey:@"summary"];
                       [post setValue:postDict[@"text"] forKey:@"text"];
                       [post setValue:postDict[@"title"] forKey:@"title"];
                       [post setValue:postDict[@"type"] forKey:@"type"];
                       
                   }
                   
                   for (NSDictionary *appDict in appsArray) {
                       NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
                       fetchRequest.predicate = [NSPredicate predicateWithFormat:@"postID == %@", appDict[@"postID"]];
                       
                       NSError *error = nil;
                       NSArray *existingPosts = [context executeFetchRequest:fetchRequest error:&error];
                       NSManagedObject *post = nil;
                       
                       if (existingPosts.count > 0) {
                           post = existingPosts.firstObject;
                           overlap = YES;
                       } else {
                           post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:context];
                           overlap = NO;
                       }
                       NSDictionary *authorContent = [appDict objectForKey:@"author"];
                       [post setValue:postDict[@"authorID"] forKey:@"author"];
                       [post setValue:authorContent[@"displayName"] forKey:@"authorName"];
                       [post setValue:postDict[@"date"] forKey:@"date"];
                       [post setValue:postDict[@"image"] forKey:@"image"]; //b64str
                       [post setValue:postDict[@"isFeatured"] forKey:@"isFeatured"]; //b
                       [post setValue:postDict[@"isNew"] forKey:@"isNew"]; //bool
                       [post setValue:postDict[@"justShowOff"] forKey:@"justShowOff"]; //b
                       [post setValue:postDict[@"postID"] forKey:@"postID"];
                       [post setValue:postDict[@"summary"] forKey:@"summary"];
                       [post setValue:postDict[@"text"] forKey:@"text"];
                       [post setValue:postDict[@"title"] forKey:@"title"];
                       [post setValue:postDict[@"type"] forKey:@"type"];
                       
                   }
                   
                   NSError *saveError = nil;
                   if ([context hasChanges]) {
                       [context save:&saveError];
                       if(overlap == YES) {
                           
                           NSLog(@"New things :: Send Refresh");[NSNotificationCenter.defaultCenter postNotificationName:@"REFRESH" object:nil];
                       } else if(overlap == NO) {
                           NSLog(@"Send Refresh despite no overlap");
                           [NSNotificationCenter.defaultCenter postNotificationName:@"REFRESH" object:nil];
                           [XMLUtility alert:@"return YES" withMessage:@"return 0"];
                       }
                   }
                   //NSLog(@"r %@", response);
               }
           } else if(!data) {
               [XMLUtility alert:@"Error" withMessage:@"Please check your internet connection."];
           }
       });
        
    } else {
        [XMLUtility alert:@"Authentication error" withMessage:@"Wipe keychain and re-install app"];
        return;
    }
}


+ (BOOL)checkForAuth {
    //no real auth yet, just presence checks
    if ([XMLKeychainUtility checkStringForKey:@"uniqueAppID"] == nil) {
        [XMLUtility alert:@"Alert" withMessage:@"uid op code died"];
        return NO;
    } else if([XMLKeychainUtility checkStringForKey:@"uniqueAppID"] != nil) {
        return YES;
    } else {
        return NO;
    }
    //return nil;
}

@end
