//
//  ProductHeader.h
//  MMIA
//
//  Created by yhx on 15/6/8.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MmiaPublicResponseModel.h"

/**
 * 单品详情页的头，包含三个部分，品牌logo，单品名字，单品介绍
 */

typedef NS_ENUM(NSInteger, ProductHeaderState)
{
    ProductInfoDetailHeaderType = 1,
    BrandEntryDetailHeaderType
};

@interface ProductHeader : UICollectionReusableView

@property (copy, nonatomic) void (^TapBrandLogoBlock)();

- (void)reloadProductHeaderWithModel:(MmiaPaperProductListModel *)model productHeaderState:(ProductHeaderState)state;

@end

