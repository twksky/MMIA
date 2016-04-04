//
//  BrandEntrySingleCell.h
//  MMIA
//
//  Created by MMIA-Mac on 15-6-12.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MmiaPublicResponseModel.h"

@interface BrandEntrySingleCell : UICollectionViewCell

- (void)reloadSingleCellWithModel:(MmiaPaperProductListModel *)model;

@end
