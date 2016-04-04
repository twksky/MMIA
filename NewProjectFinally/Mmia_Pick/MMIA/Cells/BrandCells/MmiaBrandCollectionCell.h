//
//  MmiaBrandCollectionCell.h
//  MMIA
//
//  Created by lixiao on 15/5/25.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//
/*
 品牌介绍
 */

#import <UIKit/UIKit.h>
#import "MmiaPublicResponseModel.h"

@interface MmiaBrandCollectionCell : UICollectionViewCell{
}
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel1;
@property (weak, nonatomic) IBOutlet UILabel *webLabel;
@property (weak, nonatomic) IBOutlet UILabel *webContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *doubleImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;

- (void)reloadCellWithModel:(MmiaPaperProductListModel *)model;

@end