//
//  MmiaBaseViewController.m
//  MMIA
//
//  Created by lixiao on 15/5/18.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaBaseViewController.h"

@interface MmiaBaseViewController ()
@end

@implementation MmiaBaseViewController

#pragma mark - getter

- (UILabel *)rightLabel
{
    if (!_rightLabel)
    {
        _rightLabel = [[UILabel alloc]init];
        _rightLabel.backgroundColor = [UIColor clearColor];
        [_rightLabel setShadowColor:[UIColor blackColor]];
        [_rightLabel setShadowOffset:CGSizeMake(0.0f, 0.5f)];
        _rightLabel.textColor = ColorWithHexRGB(0xffffff);
        _rightLabel.textAlignment = MMIATextAlignmentRight;
        _rightLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.naviBarView addSubview:_rightLabel];
        
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.naviBarView);
            make.right.equalTo(self.naviBarView).offset(-10);
            make.left.equalTo(self.naviBarView).offset(100);
            make.height.equalTo(self.naviBarView);
        }];
    }
    return _rightLabel;
}

#pragma mark - lifeStyle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (iOS7Later)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.view.backgroundColor = ColorWithHexRGB(0xcccccc);
    
    self.navigationView = [[UIView alloc]init];
    self.navigationView.backgroundColor = ColorWithHexRGBA(0xefefef, 1);
    [self.view insertSubview:self.navigationView aboveSubview:self.collectionView];

    self.statusView = [[UIView alloc]init];
    self.statusView.backgroundColor = [UIColor clearColor];
    [self.navigationView addSubview:self.statusView];
    
    self.naviBarView = [[UIView alloc]init];
    self.naviBarView.backgroundColor = [UIColor clearColor];
    [self.navigationView addSubview:self.naviBarView];
    
    self.lineLabel = [[UILabel alloc]init];
    self.lineLabel.backgroundColor = ColorWithHexRGBA(0xdfdfdf, 1);
    [self.naviBarView addSubview:self.lineLabel];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = MMIATextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = UIFontSystem(20);
    self.titleLabel.backgroundColor = [UIColor clearColor];
    [self.naviBarView addSubview:self.titleLabel];
    
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(VIEW_OFFSET + kNavigationBarHeight));
    }];
    
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make){
       make.top.left.right.equalTo(self.navigationView);
        make.height.equalTo(@(VIEW_OFFSET));
    }];
    
    [self.naviBarView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.statusView.mas_bottom);
        make.left.right.equalTo(self.navigationView);
        make.height.equalTo(@(kNavigationBarHeight));
    }];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.navigationView);
        make.height.equalTo(@0.5f);
    }];
   
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.height.equalTo(self.naviBarView);
        make.width.equalTo(@(100));
    }];
}

#pragma mark - public
#pragma mark -loadUI

- (void)addBackBtnWithTarget:(id)target selector:(SEL)selector
{
    UIButton *backButton = [[UIButton alloc]init];
    backButton.tag = 1001;
    UIImage *backImage = [UIImage imageNamed:@"backBtn.png"];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
     [self.naviBarView addSubview:backButton];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.equalTo(self.naviBarView);
        make.size.mas_equalTo(CGSizeMake(50, kNavigationBarHeight));
    }];
}

- (void)addRightBtnWithImage:(UIImage *)rightImage Target:(id)target selector:(SEL)selector
{
    UIButton *rightButton = [[UIButton alloc]init];
    rightButton.tag = 1002;
    [rightButton setImage:rightImage forState:UIControlStateNormal];
    [rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.naviBarView addSubview:rightButton];
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(@-10);
        make.top.equalTo(@0);
         make.size.mas_equalTo(CGSizeMake(50, kNavigationBarHeight));
    }];
}

//增加刷新header及footer
- (void)addHeaderAndFooter
{
    [self addRefreshHeader];
    [self addRefreshFooter];
}

//增加下拉刷新
- (void)addRefreshHeader
{
    __weak __typeof(self) weakSelf = self;
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ( _isLoadding )
        {
            return ;
        }
        _isLoadding = YES;
        _isRefresh  = YES;
        [weakSelf addHeaderRequestRefreshData];
    }];
}

//增加上拉加载
- (void)addRefreshFooter
{
    __weak __typeof(self) weakSelf = self;
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if ( _isLoadding )
        {
            return ;
        }
        _isLoadding = YES;
        _isRefresh = NO;
        [weakSelf addFooterRequestMoreData];
    }];
    self.collectionView.footer.hidden = YES;
}

#pragma mark -上拉及下拉加载数据

//下拉时刷新数据
- (void)addHeaderRequestRefreshData
{
    
}

//上拉加载更多
- (void)addFooterRequestMoreData
{
    
}

#pragma mark -网络请求完处理

//请求完刷新数据
- (void)refreshPageData
{
    if ( _isLoadding )
    {
        _isLoadding = NO;
    }
    
    if ( _isRefresh )
    {
       [self.collectionView.header endRefreshing];
          _isRefresh = NO;
        
    }else
    {
       [self.collectionView.footer endRefreshing];
    }
    
    if ( _everyDownNum < Request_Size )
    {
       [self.collectionView.footer noticeNoMoreData];
        
    }else
    {
       [self.collectionView.footer resetNoMoreData];
       self.collectionView.footer.hidden = NO;
    }
    
    [self.collectionView reloadData];
}

//网络出错
- (void)netWorkError:(NSError *)error
{
    if ( _isLoadding )
    {
        _isLoadding = NO;
    }
    
    if ( _isRefresh )
    {
        [self.collectionView.header endRefreshing];
         _isRefresh = NO;
        
    }else
    {
        [self.collectionView.footer endRefreshing];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
