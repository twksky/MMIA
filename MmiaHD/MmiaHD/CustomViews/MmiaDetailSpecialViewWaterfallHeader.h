//
//  MmiaDetailSpecialViewWaterfallHeader.h
//  MmiaHD
//
//  Created by lixiao on 15/3/10.
//  Copyright (c) 2015年 yhx. All rights reserved.
//
/*专题详情页Header*/

#import <UIKit/UIKit.h>

@protocol MmiaDetailSpecialViewWaterfallHeaderDelegate <NSObject>

- (void)tapUserImageViewUserId:(NSInteger)userId;
- (void)doClickConcernButton:(UIButton *)concernButton;

@end

@interface MmiaDetailSpecialViewWaterfallHeader : UICollectionReusableView

@property (nonatomic, retain) UILabel       *titleLabel;
@property (nonatomic, retain) UILabel       *creatLabel;
@property (nonatomic, retain) UIImageView   *bgImageView;
@property (nonatomic, retain) UIButton      *concernButton;
@property (nonatomic, retain) NSArray       *userArr;
@property (nonatomic, assign) id<MmiaDetailSpecialViewWaterfallHeaderDelegate> specialDelegate;

- (void)resetInfoAtHeaderUserDict:(NSDictionary *)userDict MagezineFans:(NSArray *)magezineFans;

@end
