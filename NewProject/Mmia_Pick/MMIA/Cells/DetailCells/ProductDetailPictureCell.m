//
//  ProductDetailPictureCell.m
//  MMIA
//
//  Created by MMIA-Mac on 15-6-4.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "ProductDetailPictureCell.h"

@implementation ProductDetailPictureCell

- (void)awakeFromNib
{
    [_pictureImageView sd_setImageWithURL:[NSURL URLWithString:self.productPictureListModel.picUrl]];
    //    _describe.text = self.ProductPictureListModel.describe;
    
    
    //描述
    _describeLabel.font = [UIFont systemFontOfSize:10];
    _describeLabel.textColor = ColorWithHexRGB(0x666666);
    _describeLabel.text = self.productPictureListModel.describe;
    [_describeLabel setNumberOfLines:0];
    CGSize describeSize = [GlobalFunction getTextSizeWithSystemFont:_describeLabel.font ConstrainedToSize:CGSizeMake(Main_Screen_Width-20, 1000) string:self.productPictureListModel.describe];
    [_describeLabel setFrame:CGRectMake(10, 1, Main_Screen_Width-20, describeSize.height)];
}

-(MmiaProductPictureListModel *)productPictureListModel{
    if (_productPictureListModel == nil) {
        _productPictureListModel = [[MmiaProductPictureListModel alloc]init];
    }
    return _productPictureListModel;
}

@end
