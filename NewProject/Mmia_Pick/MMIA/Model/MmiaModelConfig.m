//
//  MmiaModelConfig.m
//  MMIA
//
//  Created by MMIA-Mac on 15-6-4.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaModelConfig.h"
#import "MmiaCategoryModel.h"
#import "MmiaHomePageModel.h"
#import "MmiaProductDetailModel.h"
#import "MmiaPublicResponseModel.h"
#import "MmiaPaperResponseModel.h"

@implementation MmiaModelConfig

/**
 *  这个方法会在MmiaModelConfig加载进内存时调用一次
 */
+ (void)load
{
    // 分类页
    [MmiaCategoryModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"categoryList" : @"MmiaCategoryListModel"
                 };
    }];
    
    // 首页
    [MmiaHomePageModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"bannerList" : @"MmiaPaperRecommendModel",
                 @"selectionList" : @"MmiaPaperRecommendModel",
                 @"goodRecommendList" : @"MmiaPaperRecommendModel",
                 @"recommendList" : @"MmiaPaperProductListModel"
                 };
    }];
    
    // 单品详情页
    [MmiaProductModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"productPictureList" : @"MmiaProductPictureListModel"
                 };
    }];
    
    //paper页面
    [MmiaPaperResponseModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"recommendList" : @"MmiaPaperRecommendModel",
                 @"productList" : @"MmiaPaperProductListModel",
                 @"searchList" : @"MmiaPaperProductListModel",
                 };
    }];
    
    //到详情页的model
    /* productPictureList进入单品详情页
       brandPictureList 进入品牌列表
     */
    [MmiaPaperProductListModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"productPictureList" : @"MmiaProductPictureListModel",
                 @"brandPictureList" : @"MmiaProductPictureListModel",
                 };
    }];
    
    //品牌详情页的model
    [MmiaPaperBrandModel setupObjectClassInArray:^NSDictionary *{
        return @{
                  @"brandPictureList" : @"MmiaProductPictureListModel",
                 };
    }];
}

@end
