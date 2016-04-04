//
//  GlobalNetwork.h
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

extern NSString *const MmiaHostURL;
// 根据关键字搜索
extern NSString *const Mmia_SearchByKeyWord;
// 联想词搜索
extern NSString *const Mmia_SearchBrandByKeyWord;
// 根据品牌ID获取单品列表
extern NSString *const Mmia_ProductListByBrandId;
// 根据类目ID获取单品列表
extern NSString *const Mmia_ProductListByCategoryId;
// 获取首页内容
extern NSString *const MmiaHomePageURL;
// 首页推荐列表
extern NSString *const MmiaHomeRecommendListURL;
// 获取一级类目列表
extern NSString *const MmiaCategoryURL;
// 获取单品详情
extern NSString *const MmiaProductDetailURL;


@interface MMiaNetworkEngine : AFHTTPSessionManager

typedef void (^JsonObjectResponseBlock)(AFHTTPRequestOperation *operation, NSDictionary* responseDict);
typedef void (^ErrorBlock)(AFHTTPRequestOperation *operation, NSError* error);


// 初始化
+ (MMiaNetworkEngine *)sharedInstance;

// 发起post类型网络请求公共入口
- (void)startPostAsyncRequestWithUrl:(NSString*)url param:(id)param completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(ErrorBlock) errorBlock;

// 发起get类型网络请求公共入口
- (void)startGetAsyncRequestWithUrl:(NSString*)url param:(id)param completionHandler:(JsonObjectResponseBlock) handleDataBlock errorHandler:(ErrorBlock) errorBlock;

@end
