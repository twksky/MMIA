//
//  GlobalKey.h
//  MMIA
//
//  Created by lixiao on 15/5/13.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalKey : NSObject

//首页
extern NSString *const HomeCollectionViewCellIdentifier;
extern NSString *const HomeCollectionViewBigCellIdentifier;
//分类
extern NSString *const CategoryWaterCellIdentifier;

extern NSString *const MmiaFileKey ;

extern NSString *const MmiaSearchCellIdentifier;
//单品
extern NSString *const MmiaSingleGoodsCellIdentifier;
//关于品牌
extern NSString *const MmiaBrandCellIdentifier;
//加载
extern NSString *const MmiaPaperLoadCellIdentifier;
//品牌
extern NSString *const MmiaDescriptionBrandCellIdentifier;
//详情页
extern NSString *const CollectionElementKindSectionHeader;
extern NSString *const CollectionElementKindSectionFooter;
extern NSString *const ProductHeaderIdentifier;
extern NSString *const ProductFooterIdentifier;
extern NSString *const BrandHeaderIdentifier;
extern NSString *const BrandFooterIdentifier;

extern NSString *const ProductDetailPictureCellIdentifier;
extern NSString *const BrandIntroduceDetailCellIdentifier;
extern NSString *const BrandEntryDetailCellIdentifier;
extern NSString *const ProductInfoDetailCellIdentifier;
extern NSString *const BrandEntrySingleCellIdentifier;

@end
