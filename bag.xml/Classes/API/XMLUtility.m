//
//  XMLUtility.m
//  bag.xml
//
//  Created by XML on 12/04/25.
//  Copyright (c) 2025 Daphne Coemen. All rights reserved.
//

#import "XMLUtility.h"

@implementation XMLUtility

+ (void)FLSetSID {
    //this is just via the "XML Server"
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        
        NSURL *randomEndpoint = [NSURL URLWithString:[NSString stringWithFormat:@"%@/setUID?uuid=%@", kAPIURL, (__bridge_transfer NSString *)uuidStringRef]];
        CFRelease(uuidRef);
        NSURLResponse *response;
        NSError *error;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:randomEndpoint];
        [request setHTTPMethod:@"GET"];

        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if(data) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            bool successNum = [response[@"success"] boolValue];
            
            if(successNum == YES) {
                NSDictionary *dataDict = response[@"data"];
                [XMLKeychainUtility saveString:dataDict[@"ursprung"] forKey:@"devUUID"];
                [XMLKeychainUtility saveString:dataDict[@"apUID"] forKey:@"uniqueAppID"];
                NSLog(@"Correct!");
            } else {
                [self alert:@"Error" withMessage:@"A fatal error occured. Please re-install the application and wipe it's keychain."];
            }
        } else {
            [self alert:@"Error" withMessage:[NSString stringWithFormat:@"Please check your internet connection."]];
            return;
        }
        
    });
}

+ (void)checkForAppUpdate {
    //this is just via the "XML Update Server"
    //disable this if you'd like (check the header)
    if(updateChecks == YES) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *randomEndpoint = [NSURL URLWithString:[NSString stringWithFormat:@"%@/update?v=%@&a=%@&id=%@", kAPIURL, appVersion, CurrentVersionAmalgumHash, [XMLKeychainUtility loadStringForKey:@"uniqueAppID"]]];
            NSURLResponse *response;
            NSError *error;
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:randomEndpoint];
            [request setHTTPMethod:@"GET"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if(data) {
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                BOOL kill = [response[@"kill"] boolValue];
                BOOL update = [response[@"update"] boolValue];
                if(kill)
                    exit(0);
                
                if(update) {
                    [self alert:response[@"outdateHead"] withMessage:response[@"text"]];
                }
            } else {
                return;
            }
            
        });
    }
    return;
}


+ (void)alert:(NSString*)title withMessage:(NSString*)message{
	dispatch_async(dispatch_get_main_queue(), ^{
		UIAlertView *alert = [UIAlertView.alloc
                              initWithTitle: title
                              message: message
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
		[alert show];
	});
}

@end
