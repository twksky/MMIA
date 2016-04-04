//
//  MagazineItem.h
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-2.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MagazineItem : NSObject

@property (nonatomic, assign) NSInteger aId;             // 条目Id
@property (nonatomic, assign) NSInteger userId;          // 用户Id
@property (nonatomic, assign) NSInteger magazineId;      // 专题Id
@property (nonatomic, retain) NSString* titleText;       // 专题文字
@property (nonatomic, retain) NSString* pictureImageUrl; // 图片URL
@property (nonatomic, assign) CGFloat   imageWidth;      // 图片宽度
@property (nonatomic, assign) CGFloat   imageHeight;     // 图片高度
@property (nonatomic, assign) NSInteger likeNum;         // 点赞数量
@property (nonatomic, retain) NSArray*  subMagezineArray;

//lx add
@property (nonatomic, assign) NSInteger isAttention;     //是否关注
@property (nonatomic, retain) NSString  *subTitle;       //介绍
@property (nonatomic, assign) NSTimeInterval  creatTime;      //创建时间
@property (nonatomic, retain) NSString  *headImageUrl;  //个人头像URL或toUrl

@end
