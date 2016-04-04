//
//  MmiaDescripBrandCollectionCell.h
//  MMIA
//
//  Created by lixiao on 15/5/29.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//
/*
 进入品牌的cell
 */

#import <UIKit/UIKit.h>
#import "MmiaPublicResponseModel.h"

@interface MmiaDescripBrandCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UILabel *subContentLabel;

- (void)reloadCellWithModel:(MmiaPaperProductListModel *)model;

@end
