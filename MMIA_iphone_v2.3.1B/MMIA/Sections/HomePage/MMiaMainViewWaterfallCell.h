//
//  MMiaMainViewWaterfallCell.h
//  MMIA
//
//  Created by MMIA-Mac on 14-7-3.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagezineItem.h"

// 首页照片墙中Item

@interface MMiaMainViewWaterfallCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView*  imageView;    // 大图
@property (nonatomic, strong) UIImageView*  logoImageView;// 大图下logo
@property (nonatomic, strong) UILabel*      displayLabel; // 大图下文字
@property (nonatomic, strong) UIImageView*  likeView;     // 喜欢图标
@property (nonatomic, strong) UILabel*      likeLabel;    // 喜欢数量
@property (nonatomic, strong) UILabel*      priceLabel;   // 价格
@property (nonatomic, strong) UIButton*     openButton;   // 类目展开按钮
@property (nonatomic, strong) NSIndexPath*  indexPath;    // cell path

@property (nonatomic, strong) UIButton*    button;          //(取消关注/关注)
@property (nonatomic, strong) UILabel*     supportNumLabel; //支持(个人中心,无图片）

@end
