//
//  MmiaProductDetailModel.h
//  MMIA
//
//  Created by MMIA-Mac on 15-6-4.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MmiaProductDetailModel : NSObject

@property (nonatomic, assign) NSInteger     status;
@property (nonatomic, strong) NSString*     message;
@property (nonatomic, strong) NSDictionary* product;

@end

// 大图列表,品牌，单品详情页
@interface MmiaProductPictureListModel : NSObject

@property (nonatomic, assign) NSInteger picId;
@property (nonatomic, strong) NSString* describe;
@property (nonatomic, strong) NSString* picUrl;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end
