//
//  MmiaBrandDetailsViewController.m
//  MMIA
//
//  Created by lixiao on 15/6/10.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaBrandDetailsViewController.h"
#import "MmiaBrandViewController.h"
#import "MmiaWebSiteViewController.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "BrandIntroduceDetailCell.h"
#import "ProductInfoDetailCell.h"
#import "MmiaShareView.h"

@interface MmiaBrandDetailsViewController ()

@end

@implementation MmiaBrandDetailsViewController

#pragma mark - lifeStyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[BrandIntroduceDetailCell class] forCellWithReuseIdentifier:BrandIntroduceDetailCellIdentifier];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UICollectionViewCell *cell;
   
    if (indexPath.row == self.dataArray.count)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaPaperLoadCellIdentifier forIndexPath:indexPath];
        
        if (self.PaperDetailLoadMoreDataBlock)
        {
            self.PaperDetailLoadMoreDataBlock(cell);
        }
    }
    else
    {
        //除loading 外cell布局
         MmiaPaperProductListModel *model = [self.dataArray objectAtIndex:indexPath.row];
        
        if (model.type == 1)
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:BrandIntroduceDetailCellIdentifier forIndexPath:indexPath];
            [[cell.contentView viewWithTag:111] removeFromSuperview];
            [cell.contentView addSubview:[self addViewToCellWithRightTitle:@"关于品牌"]];
            ((BrandIntroduceDetailCell *)cell).brandIntroduceModel = model;
            
            ((BrandIntroduceDetailCell *)cell).TapFootGoodOrShareBtnBlock = ^(UIButton *button)
            {
                [self tapShareViewWithButton:button];
            };
            
            ((BrandIntroduceDetailCell *)cell).TapBrandWebsiteBlock = ^(NSString* webUrl){
                [self tapWebsiteLabelWithWebUrl:webUrl];
            };
        }
        else if (model.type == 0)
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

    return cell;
}


@end
