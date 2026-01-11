//
//  XMLAPPCELL.h
//  bag.xml
//
//  Created by XML on 09/01/26.
//  Copyright (c) 2026 Daphne Coemen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMLAPPCELL : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *spoiler;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIImageView *separator;
@property (weak, nonatomic) IBOutlet UIImageView *appIcon;
@end
