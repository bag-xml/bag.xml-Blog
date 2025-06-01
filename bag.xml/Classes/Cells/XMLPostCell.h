//
//  XMLPostCell.h
//  bag.xml
//
//  Created by XML on 25/05/25.
//  Copyright (c) 2025 Daphne Coemen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMLPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *heading;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *spoiler;
@end
