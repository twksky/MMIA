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
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *detailImageView;
@property (strong, nonatomic) IBOutlet UILabel *subLabel;
@property (strong, nonatomic) IBOutlet UILabel *subContentLabel;

- (void)reloadCellWithModel:(MmiaPaperProductListModel *)model;

@end
