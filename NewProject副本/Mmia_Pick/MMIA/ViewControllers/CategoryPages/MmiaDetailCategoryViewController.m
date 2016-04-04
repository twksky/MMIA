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
#import "NSObject+MJKeyValue.h"
#import "MmiaSingleGoodsCollectionCell.h"
#import "MmiaDescripBrandCollectionCell.h"

@interface MmiaDetailCategoryViewController (){
    MmiaPaperResponseModel  *_dataModel;
}

@end

@implementation MmiaDetailCategoryViewController


#pragma mark - lifeStyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.topDataArray = @[@"photo1.jpg", @"photo2.jpg", @"photo3.jpg"];
    [self.view bringSubviewToFront:self.navigationView];
    [self addBackBtnWithTarget:self selector:@selector(buttonClick:)];
    [self getProductListByCatrgoryIdWithStart:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [AppDelegate sharedAppDelegate].window.hidden = YES;
}

#pragma mark - Request

- (void)getProductListByCatrgoryIdWithStart:(NSInteger)start
{
    MmiaDetailCategoryRequestModel *requestModel = [[MmiaDetailCategoryRequestModel alloc]init];
    requestModel.start = start;
    requestModel.size = Request_Size;
    requestModel.categoryId = 0;
     NSDictionary *infoDict = [requestModel keyValues];
    
    [[MMiaNetworkEngine sharedInstance]startPostAsyncRequestWithUrl:Mmia_ProductListByCategoryId param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
        
        if ([responseDic[@"result"]integerValue] == 0)
        {
            _dataModel = [MmiaPaperResponseModel objectWithKeyValues:responseDic];
            NSArray *arr = [MmiaPaperProductListModel objectArrayWithKeyValuesArray:_dataModel.productList];
            [self.itemsArray addObjectsFromArray:arr];
            [self.collectionView reloadData];
        }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
        
    }];
    
}

#pragma mark - Click

- (void)buttonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - collectionViewDelegate

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
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
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemsArray.count;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
