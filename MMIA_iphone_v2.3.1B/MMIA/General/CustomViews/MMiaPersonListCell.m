//
//  MMiaPersonListCell.m
//  MMIA
//
//  Created by Free on 14-6-18.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaPersonListCell.h"

@implementation MMiaPersonListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30 ,80)];
        [self.contentView addSubview:self.titleLabel];
        
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
