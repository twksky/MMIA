//
//  BrandIntroduceDetailCell.h
//  MMIA
//
//  Created by MMIA-Mac on 15-6-10.
//  Copyright (c) 2015年 yhx. All rights reserved.
//
/*
 ** 关于品牌页cell
 */

#import <UIKit/UIKit.h>
#import "MmiaPublicResponseModel.h"

@interface BrandIntroduceDetailCell : UICollectionViewCell

@property (nonatomic, strong) MmiaPaperProductListModel* brandIntroduceModel;
@property (copy, nonatomic) void (^TapBrandWebsiteBlock)(NSString* webUrl);
//点击点赞或分享按钮
@property (nonatomic, copy) void (^TapFootGoodOrShareBtnBlock)(UIButton *button);

@end
