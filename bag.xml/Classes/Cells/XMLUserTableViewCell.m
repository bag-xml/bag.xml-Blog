//
//  XMLUserTableViewCell.m
//  bag.xml
//
//  Created by XML on 27/05/25.
//  Copyright (c) 2025 Daphne Coemen. All rights reserved.
//

#import "XMLUserTableViewCell.h"

@implementation XMLUserTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
