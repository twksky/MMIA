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
    NSInteger _num;
}

@end

@implementation MmiaDetailCategoryViewController


- (void)setCategoryListModel:(MmiaCategoryListModel *)categoryListModel
{
    if( _categoryListModel != categoryListModel )
    {
        _categoryListModel = categoryListModel;
        
        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:categoryListModel.logo]];
        [self getProductListByCatrgoryIdWithStart:0];
    }
}

#pragma mark - lifeStyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // [self.view bringSubviewToFront:self.navigationView];
    self.lineLabel.hidden = YES;
    [self addBackBtnWithTarget:self selector:@selector(buttonClick:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [AppDelegate sharedAppDelegate].window.hidden = YES;
}

#pragma mark - Request

- (void)getProductListByCatrgoryIdWithStart:(NSInteger)start
{
    MmiaDetailCategoryRequestModel *requestModel = [[MmiaDetailCategoryRequestModel alloc]init];
    requestModel.start = start;
    requestModel.size = Request_Size;
    requestModel.categoryId = 94;
//    requestModel.categoryId = self.categoryListModel.categoryId;
     NSDictionary *infoDict = [requestModel keyValues];
    
    [[MMiaNetworkEngine sharedInstance]startPostAsyncRequestWithUrl:Mmia_ProductListByCategoryId param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
        
        if( ![responseDic[@"status"] intValue] )
        {
            MmiaPaperResponseModel* dataModel = [MmiaPaperResponseModel objectWithKeyValues:responseDic];
            
            self.topDataArray = dataModel.recommendList;
            
            _num = dataModel.searchList.count;
            self.itemsArray = [self.itemsArray arrayByAddingObjectsFromArray:dataModel.productList];
            // 刷新详情页数据
            self.detailViewController.dataArry = self.itemsArray;
        }
        else
        {
            // 错误处理
        }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
        
    }];
    
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
    
    if (indexPath.row == self.itemsArray.count  && _num >= Request_Size)
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
    
    if (self.itemsArray.count - indexPath.row == 2 && _num >= Request_Size)
    {
        [self getProductListByCatrgoryIdWithStart:self.itemsArray.count];
    }
    return cell;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (_num >= Request_Size) ? (self.itemsArray.count + 1):self.itemsArray.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
