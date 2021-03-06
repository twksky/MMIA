//
//  MmiaDetailCategoryViewController.m
//  MMIA
//
//  Created by lixiao on 15/6/1.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaDetailCategoryViewController.h"
#import "AppDelegate.h"
#import "MmiaDetailCategoryRequestModel.h"
#import "MmiaSingleGoodsCollectionCell.h"
#import "MmiaDescripBrandCollectionCell.h"
#import "MmiaLoadingCollectionCell.h"


@interface MmiaDetailCategoryViewController ()
{
    BOOL  _addMoreData;
}

@end

@implementation MmiaDetailCategoryViewController


- (void)setCategoryListModel:(MmiaCategoryListModel *)categoryListModel
{
    if( _categoryListModel != categoryListModel )
    {
        _categoryListModel = categoryListModel;
        
        [self.topImageView sd_setImageWithURL:NSURLWithString(categoryListModel.logo)];
        [self getProductListByCatrgoryIdWithStart:0];
    }
}

#pragma mark - lifeStyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rightLabel.text = @"分类";
    [self addBackBtnWithTarget:self selector:@selector(buttonClick:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegate sharedAppDelegate].window.hidden = YES;
    self.collectionView.alwaysBounceHorizontal = YES;
}

#pragma mark - Request

- (void)getProductListByCatrgoryIdWithStart:(NSInteger)start
{
    MmiaDetailCategoryRequestModel *requestModel = [[MmiaDetailCategoryRequestModel alloc]init];
    requestModel.start = start;
    requestModel.size = Request_Size;
    requestModel.categoryId = self.categoryListModel.categoryId;
     NSDictionary *infoDict = [requestModel keyValues];
    
    [[MMiaNetworkEngine sharedInstance]startPostAsyncRequestWithUrl:Mmia_ProductListByCategoryId param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
        
        if( ![responseDic[@"status"] intValue] )
        {
            MmiaPaperResponseModel* dataModel = [MmiaPaperResponseModel objectWithKeyValues:responseDic];
            
            self.topDataArray = dataModel.recommendList;
            
            self.everyNum = dataModel.productList.count;
            self.itemsArray = [self.itemsArray arrayByAddingObjectsFromArray:dataModel.productList];
            //详情页数据
            if (_detailVC)
            {
                _detailVC.everyNum = dataModel.productList.count;
                _detailVC.dataArray = self.itemsArray;
                if (_addMoreData)
                {
                    [_detailVC.collectionView reloadData];
                    _addMoreData = NO;
                }
            }
        }
        else
        {
            // 错误处理
            self.everyNum = 0;
            [self.collectionView reloadData];
             _addMoreData = NO;
        }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
        
    }];
    
}

#pragma mark - ** 重写详情页加载更多

- (void)doAddMoreDetailData
{
    _addMoreData = YES;
    [self getProductListByCatrgoryIdWithStart:self.itemsArray.count];
}

#pragma mark - Click

/*返回*/
- (void)buttonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - collectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if (indexPath.row == self.itemsArray.count)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaLoadCellIdentifier forIndexPath:indexPath];
        [(MmiaLoadingCollectionCell *)cell startAnimation];
        
    }else {
        
        MmiaPaperProductListModel *model = [self.itemsArray objectAtIndex:indexPath.row];
        
        if (model.type == 0)
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaSingleGoodsCellIdentifier forIndexPath:indexPath];
            [(MmiaSingleGoodsCollectionCell *)cell reloadCellWithModel:model];
            
        }else if (model.type == 1)
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaDescriptionBrandCellIdentifier forIndexPath:indexPath];
            [(MmiaDescripBrandCollectionCell *)cell reloadCellWithModel:model];
        }
    }
    
    if (self.itemsArray.count - indexPath.row == 2 && self.everyNum >= Request_Size)
    {
        [self getProductListByCatrgoryIdWithStart:self.itemsArray.count];
    }
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (self.everyNum >= Request_Size) ? (self.itemsArray.count + 1):self.itemsArray.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
