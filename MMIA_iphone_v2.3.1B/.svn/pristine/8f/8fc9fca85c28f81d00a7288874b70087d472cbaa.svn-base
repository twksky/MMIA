//
//  MMIADetailSpecialViewWaterfallHeader.h
//  MMIA
//
//  Created by Jack on 15/1/30.
//  Copyright (c) 2015年 com.zixun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMIADetailSpecialViewWaterfallHeader;

@protocol MMIADetailSpecialViewWaterfallHeaderDelegate<NSObject>
    -(void)attentionButClinck;
@end

@interface MMIADetailSpecialViewWaterfallHeader : UICollectionReusableView
@property (nonatomic, strong)UIImageView* bgImgView;
@property (nonatomic, strong)UILabel* createTimeView;
@property (nonatomic, strong)UIButton* attentionBut;
@property (nonatomic, weak) id <MMIADetailSpecialViewWaterfallHeaderDelegate> delegate;
-(void) isAttention:(NSInteger) attention;

@end
