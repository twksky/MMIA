//
//  MmiaBrandCollectionCell.h
//  MMIA
//
//  Created by lixiao on 15/5/22.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

/*
 **品牌cell
 */

#import <UIKit/UIKit.h>
#import "MmiaPaperResponseModel.h"

@interface MmiaSingleGoodsCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *doubleImageView;

- (void)reloadCellWithModel:(MmiaPaperProductListModel *)model;

@end
