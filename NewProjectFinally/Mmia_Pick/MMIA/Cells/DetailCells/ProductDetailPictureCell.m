//
//  ProductDetailPictureCell.m
//  MMIA
//
//  Created by MMIA-Mac on 15-6-4.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "ProductDetailPictureCell.h"
#import "UIImageView+WebCache.h"


@interface ProductDetailPictureCell ()

@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (strong, nonatomic) NSMutableAttributedString *attributedString;
@property (strong, nonatomic) NSMutableParagraphStyle   *paragraphStyle;

@end

@implementation ProductDetailPictureCell

- (void)awakeFromNib
{

}

//设置数据
- (void)reloadCellWithModel:(MmiaProductPictureListModel *)model
{
    [self.pictureImageView sd_setImageWithURL:NSURLWithString(model.picUrl) placeholderImage:nil];
    //self.describeLabel.text = model.describe;
    [self.describeLabel setLineSpace:KProductLabel_LineSpace Text:model.describe];
}

@end
