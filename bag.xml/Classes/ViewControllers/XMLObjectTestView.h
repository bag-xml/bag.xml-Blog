//
//  XMLObjectTestView.h
//  bag.xml
//
//  Created by XML on 11/05/25.
//  Copyright (c) 2025 Daphne Coemen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLUtility.h"
#import "XMLUser.h"

@interface XMLObjectTestView : UITableViewController

@property NSMutableArray* users;
@property (weak, nonatomic) IBOutlet UIImageView *test;

@end
