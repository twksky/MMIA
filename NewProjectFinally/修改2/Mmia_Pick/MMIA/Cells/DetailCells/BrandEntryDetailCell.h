//
//  BrandEntryDetailCell.h
//  MMIA
//
//  Created by MMIA-Mac on 15-6-10.
//  Copyright (c) 2015年 yhx. All rights reserved.
//
/*
 ** 品牌入口页cell
 */

#import <UIKit/UIKit.h>
#import "MmiaPublicResponseModel.h"

@interface BrandEntryDetailCell : UICollectionViewCell

@property (nonatomic, strong) MmiaPaperProductListModel* brandEntryModel;
@property (nonatomic, copy) void (^TapProductBrandLogoBlock)(NSInteger brandId);

@end
