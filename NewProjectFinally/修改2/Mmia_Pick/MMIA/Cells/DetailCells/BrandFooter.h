//
//  BrandFooter.h
//  MMIA
//
//  Created by yhx on 15/5/28.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MmiaPublicResponseModel.h"

@interface BrandFooter : UICollectionReusableView

@property (copy, nonatomic) void (^ClickGoodOrShareButton)(UIButton *button);

- (void)reloadBrandFooterWithModel:(MmiaPaperProductListModel *)model;

@end
