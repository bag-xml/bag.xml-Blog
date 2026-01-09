//
//  XMLHomeTableViewCell.h
//  bag.xml
//
//  Created by Defne on 7.10.2025.
//  Copyright (c) 2025 D, Mali Coemen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMLHomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *footer;
@property (weak, nonatomic) IBOutlet UILabel *dateandName;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@end
