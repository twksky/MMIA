//
//  BrandHeader.h
//  MMIA
//
//  Created by yhx on 15/5/27.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MmiaPublicResponseModel.h"

@interface BrandHeader : UICollectionReusableView

@property (copy, nonatomic) void (^TapWebsiteBlock)();

- (void)reloadBrandHeaderWithModel:(MmiaPaperProductListModel *)model;

@end
