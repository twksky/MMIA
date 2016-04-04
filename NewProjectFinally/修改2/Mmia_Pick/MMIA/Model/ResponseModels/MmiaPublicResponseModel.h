//
//  MmiaPublicResponseModel.h
//  MMIA
//
//  Created by lixiao on 15/6/4.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <Foundation/Foundation.h>

//推荐model
@interface MmiaPaperRecommendModel : NSObject

@property (nonatomic, strong) NSString  *pictureUrl;
@property (nonatomic, strong) NSString  *describe;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) NSInteger sourceId;
@property (nonatomic, assign) NSInteger type; // type=0为单品，type=1为品牌列表

@end

//商品详情model
@interface MmiaPaperProductListModel : NSObject

// type = 0
@property (nonatomic, assign) NSInteger spId;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *describe;
@property (nonatomic, strong) NSString  *label;
@property (nonatomic, strong) NSString  *sourceUrl;
@property (nonatomic, assign) NSInteger brandId;
@property (nonatomic, assign) NSInteger categoryId;
@property (nonatomic, strong) NSString  *focusImg;
@property (nonatomic, strong) NSString  *brandLogo;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString  *shareUrl;
@property (nonatomic, strong) NSArray   *address;
@property (nonatomic, strong) NSArray   *productPictureList;

// type =1
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *slogan;
@property (nonatomic, strong) NSString  *officalWebsite;
@property (nonatomic, strong) NSString  *logo;
@property (nonatomic, strong) NSArray   *brandPictureList;

//联想词搜索
@property (nonatomic, assign) NSInteger sourceId;
@property (nonatomic, strong) NSString  *pictureUrl;

//所属类别
@property (nonatomic, strong) NSString  *sign;

@end

//品牌地址&联系方式
@interface MmiaBrandAddressModel : NSObject

@property (nonatomic, assign) NSInteger addressId;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *storeLocation;
@property (nonatomic, assign) NSInteger spId;
@property (nonatomic, assign) NSInteger brandId;
@property (nonatomic, strong) NSString  *phone;

@end
