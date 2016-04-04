//
//  BrandEntrySingleCell.m
//  MMIA
//
//  Created by lixiao on 15/6/23.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "BrandEntrySingleCell.h"

@interface BrandEntrySingleCell ()

@property (strong, nonatomic) IBOutlet UIImageView *bigImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *describeLabel;

@end

@implementation BrandEntrySingleCell

- (void)awakeFromNib
{
}

- (void)reloadSingleCellWithModel:(MmiaPaperProductListModel *)model
{
    [self.bigImageView sd_setImageWithURL:NSURLWithString(model.focusImg) placeholderImage:nil];
    //self.titleLabel.text = model.title;
    //self.describeLabel.text = model.describe;
    [self.titleLabel setLineSpace:KProductLabel_LineSpace Text:model.title];
    [self.describeLabel setLineSpace:KProductLabel_LineSpace Text:model.describe];
}




@end
