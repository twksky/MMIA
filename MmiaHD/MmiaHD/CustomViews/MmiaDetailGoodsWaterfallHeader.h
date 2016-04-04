//
//  MmiaDetailGoodsWaterfallHeader.h
//  MmiaHD
//
//  Created by lixiao on 15/3/16.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagazineItem.h"

typedef void (^likeButtonBlock)(UIButton *button);
typedef void (^collectionButtonBlock)(UIButton *button);
typedef void (^searchLabelButtonBlock)(UIButton *button);
typedef void (^tapHeadImageViewBlock)(NSInteger userId);

@interface MmiaDetailGoodsWaterfallHeader : UIView{
    UIView          *_topBgView;
    UIView          *_middleView;
    UILabel         *_lineLabel;
    UIView          *_lastView;
    NSMutableArray  *_buttonArr;
    NSInteger       _userId;
}

@property (nonatomic, retain) UIImageView  *topImageView;
@property (nonatomic, retain) UIButton     *likeButton;
@property (nonatomic, retain) UILabel      *titleLabel;
@property (nonatomic, retain) UIImageView  *headImageView;
@property (nonatomic, retain) UILabel      *nikeNameLabel;
@property (nonatomic, retain) UILabel      *infoLabel;
@property (nonatomic, retain) UIButton     *collectionButton;
@property (nonatomic, copy)   likeButtonBlock likeButtonBlock;
@property (nonatomic, copy)   collectionButtonBlock collectionButtonBlock;
@property (nonatomic, copy)   searchLabelButtonBlock searchLabelButtonBlock;
@property (nonatomic, copy)   tapHeadImageViewBlock  tapHeadImageViewBlock;

- (void)resetMagezineItem:(MagazineItem *)item infoDict:(NSDictionary *)infoDict;
+ (CGFloat)getHeightMagezineItem:(MagazineItem *)item infoDict:(NSDictionary *)infoDict;

@end
