//
//  MmiaSearchCollectionViewCell.h
//  MMIA
//
//  Created by lixiao on 15/5/20.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MmiaPublicResponseModel.h"

@interface MmiaSearchCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

- (void)resetCellWithModel:(MmiaPaperProductListModel *)productModel;

@end
