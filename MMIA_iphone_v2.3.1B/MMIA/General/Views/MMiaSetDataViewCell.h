//
//  MMiaSetDataViewCell.h
//  MMIA
//
//  Created by lixiao on 14-6-19.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMiaSetDataViewCellDelegate;
@protocol MMiaSetDataViewCellDelegate <NSObject>

-(void)changeImgIn:(UIImageView *)image;


@end

@interface MMiaSetDataViewCell : UITableViewCell<UITextFieldDelegate>

@property(nonatomic,retain)UIImageView *headImageView;
@property(nonatomic,retain)UILabel *typeLabel;
@property(nonatomic,retain)UITextField *detailTextFiled;
@property(nonatomic,retain)UIView *sexView;
@property(nonatomic,retain)UIButton *manBtn;
@property(nonatomic,retain)UIButton *womanBtn;
@property(nonatomic,assign)id<MMiaSetDataViewCellDelegate> cellDelegate;


@end
