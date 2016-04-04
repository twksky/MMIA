//
//  MmiaBrandViewController.h
//  MMIA
//
//  Created by lixiao on 15/5/21.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaPaperViewController.h"

@interface MmiaBrandViewController : MmiaPaperViewController

@property (strong, nonatomic) UILabel     *brandTitleLabel;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UIImageView *backImageView;
@property (strong, nonatomic) UIImageView *reBackImageView;
@property (assign, nonatomic) NSInteger  brandId;

@end
