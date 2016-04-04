//
//  BaseViewController.h
//  MMIA
//
//  Created by zixun on 6/10/14.
//  Copyright (c) 2014 com.zixun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface MMiaBaseViewController : UIViewController

@property (nonatomic,retain) UIButton *leftBarButton;
@property (nonatomic,retain) UIButton *rightBarButton;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UIImageView *navigationImageView;
@property (nonatomic,retain) UIView *navigationView;

@end
