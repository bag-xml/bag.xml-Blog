//
//  XMLObjectRetriever.m
//  bag.xml
//
//  Created by XML on 24/04/25.
//  Copyright (c) 2025 Daphne Coemen. All rights reserved.
//

#import "XMLObjectRetriever.h"

@implementation XMLObjectRetriever


+ (void)initObjRetrieval {
    //getALL getPosts, getUsers, getValidVersions, anything, all separate.
    if([XMLObjectRetriever checkForAuth] == YES) {
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           NSURL *randomEndpoint = [NSURL URLWithString:[NSString stringWithFormat:@"%@/total?a=%@&id=%@", kAPIURL, CurrentVersionAmalgumHash, [XMLKeychainUtility loadStringForKey:@"uniqueAppID"]]];
           NSURLResponse *response;
           NSError *error;
           
           NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
           [request setURL:randomEndpoint];
           [request setHTTPMethod:@"GET"];
           [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
           
           NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
           if(data) {
               NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
               if([response[@"success"] boolValue] == NO) {
                   [XMLUtility alert:@"An error occured" withMessage:@"Please try again later"];
                   return;
               } else {
                   bool overlap = false;
                   NSArray *usersArray = response[@"data"][@"users"];
                   NSArray *postsArray = response[@"data"][@"posts"];
                   
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
                       
                       [post setValue:postDict[@"author"] forKey:@"author"];
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
                           NSLog(@"psss");[NSNotificationCenter.defaultCenter postNotificationName:@"REFRESH" object:nil];
                       }
                       
                   }

                   
                   /*
                   for (NSDictionary *postDict in postsArray) {
                       //NSLog(@"%@", postDict);
                       NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
                       fetchRequest.predicate = [NSPredicate predicateWithFormat:@"postID == %@", postDict[@"postID"]];
                       
                       NSArray *existingPost = [context executeFetchRequest:fetchRequest error:&error];
                       NSManagedObject *post = nil;
                       
                       if (existingPost.count > 0) {
                           // udpate
                           post = existingPost.firstObject;
                       } else {
                           post = [NSEntityDescription insertNewObjectForEntityForName:@"Post" inManagedObjectContext:context];
                       }
                       
                       
                       //[post setValue:postDict[@"displayName"] forKey:@"displayName"];*/
                       
                   //}

               }
           }
       });
        
    } else {
        [XMLUtility alert:@"return 0" withMessage:@"return 0"];
        return;
    }
}


+ (BOOL)checkForAuth {
    //no real auth yet, just presence checks
    if ([XMLKeychainUtility checkStringForKey:@"uniqueAppID"] == nil) {
        [XMLUtility alert:@"Alert" withMessage:@"uid op code died"];
        return NO;
    } else if([XMLKeychainUtility checkStringForKey:@"uniqueAppID"] != nil) {
        NSLog(@"aöove");
        return YES;
    } else {
        return NO;
    }
    return nil;
}

@end
