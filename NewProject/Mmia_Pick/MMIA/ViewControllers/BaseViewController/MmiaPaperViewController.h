//
//  MmiaPaperViewController.h
//  MMIA
//
//  Created by MMIA-Mac on 15-5-19.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MmiaBaseViewController.h"
#import "MmiaPaperResponseModel.h"
#import "NSObject+MJKeyValue.h"
#import "MmiaDetailsCollectionViewController.h"

@class MmiaPaperViewController;
@protocol MmiaPaperViewControllerDelegate <NSObject>

- (void)showViewController:(UIViewController *)viewController didSelectInPaperView:(MmiaPaperViewController *)paperView;

@end

@interface MmiaPaperViewController : MmiaBaseViewController

@property (strong, nonatomic) UIImageView* topImageView;
@property (strong, nonatomic) UIImageView* reflectedImageView;
@property (strong, nonatomic) UILabel     *sloganLabel;
@property (strong, nonatomic) UILabel     *descriptionLabel;

@property (strong, nonatomic) NSArray     *topDataArray;
@property (strong, nonatomic) NSArray     *itemsArray;
//每次数据请求的num
@property (assign, nonatomic) NSInteger   everyNum;

@property (nonatomic, strong) MmiaDetailsCollectionViewController* detailViewController;

@property (weak, nonatomic) id<MmiaPaperViewControllerDelegate> delegate;
@property (copy,   nonatomic) void (^TopViewTapActionBlock)(NSInteger pageIndex);

- (void)changeTopImageView;

@end
