//
//  MmiaDetailCategoryRequestModel.h
//  MMIA
//
//  Created by lixiao on 15/6/1.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaBaseModel.h"

@interface MmiaDetailCategoryRequestModel : MmiaBaseModel

@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger size;

@end
