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

// 单品信息
@interface MmiaProductModel : NSObject

@property (nonatomic, assign) NSInteger spId;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, assign) NSInteger brandId;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* describe;
@property (nonatomic, strong) NSString* label;
@property (nonatomic, strong) NSString* sourceUrl;
@property (nonatomic, strong) NSString* phone;
@property (nonatomic, strong) NSString* focusImg;
@property (nonatomic, strong) NSString* brandLogo;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString* shareUrl;
@property (nonatomic, strong) NSArray * productPictureList;

@end

// 大图列表,品牌，单品详情页
@interface MmiaProductPictureListModel : NSObject

@property (nonatomic, assign) NSInteger picId;
@property (nonatomic, strong) NSString* describe;
@property (nonatomic, strong) NSString* picUrl;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;

@end