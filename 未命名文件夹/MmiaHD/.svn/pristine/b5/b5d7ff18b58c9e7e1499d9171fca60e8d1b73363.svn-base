//
//  CollectionViewWaterfallCell.h
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^concernButtonBlock)(UIButton *button);

@interface CollectionViewWaterfallCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView*  imageView;    // 图片
@property (nonatomic, strong) UILabel*      displayLabel; // 文字
@property (nonatomic, strong) UIImageView*  displaybgView;// 文字背景图
@property (nonatomic, strong) UIImageView*  likeView;     // 喜欢图标
@property (nonatomic, strong) UILabel*      likeLabel;    // 喜欢数量
@property (nonatomic, strong) UILabel*      priceLabel;   // 价格
@property (nonatomic, strong) UIButton*     cellButton;   // 类目展开按钮
@property (nonatomic, strong) NSIndexPath*  indexPath;    // cell path

//lx add
@property (nonatomic, strong) UIImageView   *headImageView; //个人头像
@property (nonatomic, strong) UIButton      *concernButton;
@property (nonatomic, copy)   concernButtonBlock   concernBlock;

@end
