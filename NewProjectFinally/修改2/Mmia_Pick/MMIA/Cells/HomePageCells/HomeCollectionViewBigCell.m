//
//  HomeCollectionViewBigCell.m
//  MMIA
//
//  Created by MMIA-Mac on 15-6-29.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "HomeCollectionViewBigCell.h"

@interface HomeCollectionViewBigCell ()

@property (strong, nonatomic) IBOutlet UIImageView *bigImageView;
@property (strong, nonatomic) IBOutlet UILabel *bigImageViewLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HomeCollectionViewBigCell

- (void)awakeFromNib
{
}

- (void)reloadCellWithModel:(MmiaHomeProductListModelModel *)model
{
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:model.pictureUrl] placeholderImage:UIImageNamed(@"默认底图_icon.png")];
    self.titleLabel.text = model.title;
    self.bigImageViewLabel.text = model.sign;
}

@end
