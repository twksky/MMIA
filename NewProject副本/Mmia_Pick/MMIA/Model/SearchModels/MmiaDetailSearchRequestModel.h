//
//  MmiaSearchRequestModel.h
//  MMIA
//
//  Created by lixiao on 15/5/29.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//请求model

#import "MmiaBaseModel.h"

@interface MmiaDetailSearchRequestModel : MmiaBaseModel

@property (nonatomic, strong) NSString *keyword;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger size;

@end
