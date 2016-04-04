//
//  HomeCollectionViewCell.m
//  MMIA
//
//  Created by MMIA-Mac on 15-6-29.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "MmiaHomePageModel.h"
#import "MmiaPublicResponseModel.h"

@interface HomeCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *bigImageView;
@property (strong, nonatomic) IBOutlet UILabel *bigImageViewLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HomeCollectionViewCell

- (void)awakeFromNib
{
}

- (void)reloadCellWithModel:(NSObject *)model
{
    if ([model isKindOfClass:[MmiaHomeProductListModelModel class]])
    {
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:((MmiaHomeProductListModelModel *)model).pictureUrl] placeholderImage:UIImageNamed(@"默认底图_icon.png")];
        self.titleLabel.text = ((MmiaHomeProductListModelModel *)model).title;
        self.bigImageViewLabel.text = ((MmiaHomeProductListModelModel *)model).sign;
    }
    else if ([model isKindOfClass:[MmiaPaperProductListModel class]])
    {
        [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:((MmiaPaperProductListModel *)model).focusImg] placeholderImage:UIImageNamed(@"默认底图_icon.png")];
        [self.titleLabel setText:((MmiaPaperProductListModel *)model).title];
        if (((MmiaPaperProductListModel *)model).sign.length != 0)
        {
            self.bigImageViewLabel.text = ((MmiaPaperProductListModel *)model).sign;
        }
    }
}

@end
