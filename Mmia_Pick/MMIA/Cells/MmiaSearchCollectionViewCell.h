//
//  MmiaSearchCollectionViewCell.h
//  MMIA
//
//  Created by lixiao on 15/5/20.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MmiaSearchModel.h"

@interface MmiaSearchCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

- (void)resetCellWithModel:(MmiaSearchModel *)searchModel;

@end
