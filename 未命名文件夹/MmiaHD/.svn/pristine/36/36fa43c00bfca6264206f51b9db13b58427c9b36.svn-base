//
//  MmiaPersonHomeCell.h
//  MmiaHD
//
//  Created by lixiao on 15/3/13.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MmiaPersonPortraitCell : UITableViewCell

@property (nonatomic, retain) UIImageView *headImageView;

@end


typedef void(^concernButtonBlock)(UIButton *concernButton);

@interface MmiaPersonLanscapeCell : UITableViewCell{
    @private
    UIView    *_bgView;
}

@property (nonatomic, retain) UILabel      *timeLabel;
@property (nonatomic, retain) UIImageView  *headImageView;
@property (nonatomic, retain) UILabel      *nikeNameLabel;
@property (nonatomic, retain) UIButton     *concernButton;
@property (nonatomic, retain) UILabel      *introduceLabel;
@property (nonatomic, copy)   concernButtonBlock  concernBlock;
@end