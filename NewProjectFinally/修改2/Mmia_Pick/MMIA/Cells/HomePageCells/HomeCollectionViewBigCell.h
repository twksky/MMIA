//
//  HomeCollectionViewBigCell.h
//  MMIA
//
//  Created by MMIA-Mac on 15-6-29.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MmiaHomePageModel.h"

@interface HomeCollectionViewBigCell : UICollectionViewCell

- (void)reloadCellWithModel:(MmiaHomeProductListModelModel *)model;

@end
