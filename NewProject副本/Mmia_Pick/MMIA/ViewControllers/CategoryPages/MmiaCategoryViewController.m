//
//  MmiaCategoryViewController.m
//  MMIA
//
//  Created by MMIA-Mac on 15-5-25.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaCategoryViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "AdditionHeader.h"
#import "CategoryWaterfallCell.h"
#import "MmiaDetailCategoryViewController.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "AppDelegate.h"
#import "MmiaMainViewController.h"


@interface MmiaCategoryViewController () <CHTCollectionViewDelegateWaterfallLayout>

- (void)configCategoryViewBackground;

@end

@implementation MmiaCategoryViewController

#pragma mark - init

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if( self = [super initWithCollectionViewLayout:layout] )
    {
        CHTCollectionViewWaterfallLayout* waterLayout = (CHTCollectionViewWaterfallLayout *)layout;
        waterLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        waterLayout.columnCount = 3;
        waterLayout.minimumColumnSpacing = 30;
        waterLayout.minimumInteritemSpacing = 20;
        
        [self.collectionView registerNib:UINibWithName(@"CategoryWaterfallCell") forCellWithReuseIdentifier:CategoryWaterCellIdentifier];
        
        self.collectionView.alwaysBounceVertical = YES;
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configCategoryViewBackground];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(VIEW_OFFSET + kNavigationBarHeight);
        make.bottom.equalTo(self.view).offset(-kNavigationBarHeight);
    }];
}

#pragma mark - Private

- (void)configCategoryViewBackground
{
    // init navigationView
    self.navigationView.backgroundColor = [UIColor clearColor];
    self.rightLabel.text = @"分类";
    [self addBackBtnWithTarget:self selector:@selector(backButtonClick:)];
    
    // init self.view background
    self.view.backgroundColor = [UIColor colorWithPatternImage:UIImageNamed(@"category_bg_icon.png")];
    UIView* backgroundAlphaView = UIView.new;
    backgroundAlphaView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    [self.view insertSubview:backgroundAlphaView belowSubview:self.collectionView];
    
    [backgroundAlphaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(VIEW_OFFSET + kNavigationBarHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)backButtonClick:(UIButton *)sender
{
    // 返回到主页面
    UIWindow* mainWindow = [AppDelegate sharedAppDelegate].window;
    MmiaMainViewController* mainVC = [(MmiaNavigationController *)mainWindow.rootViewController viewControllers].firstObject;
    
    CGRect frame = mainWindow.frame;
    frame.origin.y = CGPointZero.y;
    
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         mainWindow.transform = CGAffineTransformIdentity;
                         mainWindow.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                         [mainVC.navigationView viewWithTag:110].hidden = NO;
                     }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryWaterfallCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryWaterCellIdentifier forIndexPath:indexPath];
    cell.imageView.backgroundColor = [UIColor blueColor];
    cell.displayLabel.backgroundColor = [UIColor blackColor];
    cell.displayLabel.text = @"点我";
    
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(80, 80);
    
    return size;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
    MmiaDetailCategoryViewController *detailVC = [[MmiaDetailCategoryViewController alloc]initWithCollectionViewLayout:smallLayout];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
