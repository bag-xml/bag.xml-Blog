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
               NSLog(@"%@", response);
           }
       });
        
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
