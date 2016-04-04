//
//  MmiaPaperDetailsViewController.m
//  MMIA
//
//  Created by lixiao on 15/6/10.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaPaperDetailsViewController.h"
#import "MmiaBrandViewController.h"
#import "MmiaWebSiteViewController.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "ProductInfoDetailCell.h"
#import "BrandEntryDetailCell.h"
#import "MmiaLoadingCollectionCell.h"
#import "MmiaShareView.h"

@interface MmiaPaperDetailsViewController ()

@end

@implementation MmiaPaperDetailsViewController

#pragma mark - LifeStyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationView.hidden = YES;
    self.collectionView.backgroundColor = [UIColor clearColor];
     self.view.backgroundColor = ColorWithHexRGB(0xffffff);
    
    [self.collectionView registerClass:[BrandEntryDetailCell class] forCellWithReuseIdentifier:BrandEntryDetailCellIdentifier];
    [self.collectionView registerClass:[ProductInfoDetailCell class] forCellWithReuseIdentifier:ProductInfoDetailCellIdentifier];
    [self.collectionView registerClass:[MmiaLoadingCollectionCell class] forCellWithReuseIdentifier:MmiaLoadCellIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.frame = self.view.bounds;
    NSLog(@"AA %d %d", self.selectIndexPath.row, self.dataArray.count );
    if (self.selectIndexPath)
    {
        [self.collectionView scrollToItemAtIndexPath:self.selectIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
}

#pragma mark - Private

//添加cell 头部,右边title及返回按钮
- (UIView *)addViewToCellWithRightTitle:(NSString *)rightTitle
{
    UIView  *topTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width, kNavigationBarHeight + VIEW_OFFSET)];
    topTitleView.backgroundColor = [UIColor clearColor];
    topTitleView.tag = 111;
    
    UIButton *backButton = [[UIButton alloc]init];
    UIImage *backImage = [UIImage imageNamed:@"detail_back.png"];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [topTitleView addSubview:backButton];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(topTitleView);
        make.top.equalTo(topTitleView).offset(VIEW_OFFSET);
        make.size.mas_equalTo(CGSizeMake(50, kNavigationBarHeight));
    }];
    
    UILabel *rightTitleLabel = [[UILabel alloc]init];
    rightTitleLabel.backgroundColor = [UIColor clearColor];
    rightTitleLabel.text = rightTitle;
    [rightTitleLabel setShadowColor:[UIColor blackColor]];
    [rightTitleLabel setShadowOffset:CGSizeMake(0.0f, 0.5f)];
    rightTitleLabel.textColor = ColorWithHexRGB(0x333333);
    rightTitleLabel.textAlignment = MMIATextAlignmentRight;
    rightTitleLabel.font = [UIFont boldSystemFontOfSize:20];
    [topTitleView addSubview:rightTitleLabel];
    
    [rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(topTitleView).offset(VIEW_OFFSET);
        make.right.equalTo(topTitleView).offset(-10);
        make.left.equalTo(topTitleView).offset(100);
        make.height.equalTo(@(kNavigationBarHeight));
    }];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = ColorWithHexRGB(0x999999);
    [topTitleView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.equalTo(topTitleView);
        make.left.equalTo(topTitleView).offset(10);
        make.right.equalTo(topTitleView).offset(-10);
        make.height.equalTo(@0.5f);
    }];
    
    return topTitleView;
}

//****点击事件
- (void)backButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -***点赞&分享按钮点击，弹出分享界面

- (void)tapShareViewWithButton:(UIButton *)button
{
    if (button.tag == 200)
    {
        //点赞
        [self doClickGoodButtonWithButton:button];
        
    }else if (button.tag == 201)
    {
        //分享
        [self showShareWithButton:button];
    }
    
}

//点赞
- (void)doClickGoodButtonWithButton:(UIButton *)button
{
    UIImage *alreadyImage = [UIImage imageNamed:@"已赞.png"];
    UIImage *notImage = [UIImage imageNamed:@"点赞.png"];
    
    [button.imageView.image isEqual:alreadyImage] ?
    ([button setImage:notImage forState:UIControlStateNormal]) :
    ([button setImage:alreadyImage forState:UIControlStateNormal]);
}

//分享
- (void)showShareWithButton:(UIButton *)button
{
     UIImage *image = [UIImage imageNamed:@"微信分享.png"];
    CGFloat height = 15 + image.size.height + 20 + 1 + 50;
    
    MmiaShareView *shareView = [[MmiaShareView alloc]initWithShareViewHeight:height];
    [shareView showAnimation];
    
     __block MmiaShareView *cancelView = shareView;
    shareView.shareViewButtonClick = ^(UIButton *button){
        
        switch (button.tag)
        {
            case 300:
                //微信
                NSLog(@"微信");
                break;
                
            case 301:
                //朋友圈
                NSLog(@"朋友圈");
                break;
                
            case 302:
                //微博
                NSLog(@"微博");
                break;
                
            case 303:
                //QQ
                NSLog(@"QQ");
                break;
                
            case 400:
                //取消
                [cancelView dismissAnimation];
                break;
                
            default:
                break;
        }
    };
}

#pragma mark **点击logoImage

- (void)tapProductBrandLogoWithBrandId:(NSInteger)brandId
{
    // 进入品牌列表页
    MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
    MmiaBrandViewController* brandViewController = [[MmiaBrandViewController alloc] initWithCollectionViewLayout:smallLayout];
    brandViewController.brandId = brandId;
    
    [self.navigationController pushViewController:brandViewController animated:YES];
}

#pragma mark **点击websiteLabel

- (void)tapWebsiteLabelWithWebUrl:(NSString *)webStr
{
    MmiaWebSiteViewController *webVC = [[MmiaWebSiteViewController alloc]initWithWebStr:webStr];
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.everyNum >= Request_Size ? (self.dataArray.count + 1) : self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if (self.dataArray.count == indexPath.row )
    {
        //loadingCell的布局
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaLoadCellIdentifier forIndexPath:indexPath];
        [(MmiaLoadingCollectionCell *)cell startAnimation];
    }else
    {
        //除loadingcell外cell的布局
         MmiaPaperProductListModel *model = [self.dataArray objectAtIndex:indexPath.row];
        
        if (model.type == 1)
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:BrandEntryDetailCellIdentifier forIndexPath:indexPath];
            [[cell.contentView viewWithTag:111] removeFromSuperview];
            [cell.contentView addSubview:[self addViewToCellWithRightTitle:model.name]];
            ((BrandEntryDetailCell *)cell).brandEntryModel = model;
            
            ((BrandEntryDetailCell *)cell).TapProductBrandLogoBlock = ^(NSInteger brandId)
            {
                [self tapProductBrandLogoWithBrandId:brandId];
            };
            
        }else if (model.type == 0)
        {
            
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProductInfoDetailCellIdentifier forIndexPath:indexPath];
            [[cell.contentView viewWithTag:111] removeFromSuperview];
            [cell.contentView addSubview:[self addViewToCellWithRightTitle:model.title]];
            ((ProductInfoDetailCell *)cell).productInfoModel = model;
            
            ((ProductInfoDetailCell *)cell).TapFootGoodOrShareBtnBlock = ^(UIButton *button)
            {
                [self tapShareViewWithButton:button];
            };
            
            ((ProductInfoDetailCell *)cell).TapProductBrandLogoBlock = ^(NSInteger brandId)
            {
                [self tapProductBrandLogoWithBrandId:brandId];
            };
            
        }
    }
    
    //加载更多
    if (self.dataArray.count - indexPath.row == 2 && self.everyNum >= Request_Size )
    {
    
        if (self.AddMoreDataBlock)
        {
            self.AddMoreDataBlock(self);
        }
    }

    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
