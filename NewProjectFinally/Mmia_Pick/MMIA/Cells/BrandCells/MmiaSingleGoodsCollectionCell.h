//
//  MmiaBrandCollectionCell.h
//  MMIA
//
//  Created by lixiao on 15/5/22.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

/*
 **单品cell
 */

#import <UIKit/UIKit.h>
#import "MmiaPublicResponseModel.h"

@interface MmiaSingleGoodsCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *doubleImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;

- (void)reloadCellWithModel:(MmiaPaperProductListModel *)model;

@end
