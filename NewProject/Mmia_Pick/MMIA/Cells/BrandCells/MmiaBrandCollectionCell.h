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
#import "MmiaPaperResponseModel.h"

@interface MmiaBrandCollectionCell : UICollectionViewCell{
}
@property (strong, nonatomic) IBOutlet UILabel *brandLabel;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *lineLabel1;
@property (strong, nonatomic) IBOutlet UILabel *webLabel;
@property (strong, nonatomic) IBOutlet UILabel *webContentLabel;
@property (strong, nonatomic) IBOutlet UILabel *lineLabel2;
@property (strong, nonatomic) IBOutlet UIImageView *doubleImageView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentLabelHeight;

- (void)reloadCellWithModel:(MmiaPaperBrandModel *)model;

@end
