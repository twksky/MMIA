//
//  MMiaFunsTableViewCell.h
//  MMIA
//
//  Created by lixiao on 14-9-17.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//粉丝

#import <UIKit/UIKit.h>

@interface MMiaFunsTableViewCell : UITableViewCell
@property(nonatomic,retain)UIImageView *headImageView;
@property(nonatomic,retain)UILabel     *titleLable;
@property(nonatomic,retain)UILabel    *subTitleLabel;
@property(nonatomic,retain)UIButton   *concernButton;
@property(nonatomic,retain)UIView    *lineView;
@end
//商品详情
@interface MMiaMagezineListCell : UITableViewCell
@property(nonatomic,retain)UIImageView *isPublicImageView;
@property(nonatomic,retain)UIImageView *magezineImageView;
@property(nonatomic,retain)UILabel     *titleLabel;
@property(nonatomic,retain)UIImageView *selectImageView;
@end
