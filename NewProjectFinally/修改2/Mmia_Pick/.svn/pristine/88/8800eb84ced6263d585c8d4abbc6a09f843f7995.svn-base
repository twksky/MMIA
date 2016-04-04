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
#import "UIImage+ImageEffects.h"

@interface MmiaDetailCategoryViewController ()

@end

@implementation MmiaDetailCategoryViewController

- (void)setCategoryListModel:(MmiaCategoryListModel *)categoryListModel
{
    if( _categoryListModel != categoryListModel )
    {
        _categoryListModel = categoryListModel;
        
        self.rightLabel.text = categoryListModel.name;
        [self.topImageView sd_setImageWithURL:NSURLWithString(categoryListModel.logo)];
        
//        [self.reflectedImageView sd_setImageWithURL:NSURLWithString(categoryListModel.logo) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
//            
//            if (image)
//            {
//                image = [image applyTintEffectWithColor:nil];
//                self.reflectedImageView.image = image;
//            }
//        }];

    
        [self getProductListByCatrgoryIdWithStart:0];
    }
}

#pragma mark - lifeStyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    requestModel.categoryId = self.categoryListModel.categoryId;
     NSDictionary *infoDict = [requestModel keyValues];
    
    [[MMiaNetworkEngine sharedInstance]startPostAsyncRequestWithUrl:Mmia_ProductListByCategoryId param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
        
        if( ![responseDic[@"status"] intValue] )
        {
            MmiaPaperResponseModel* dataModel = [MmiaPaperResponseModel objectWithKeyValues:responseDic];
            
            self.topDataArray = dataModel.recommendList;
            
            self.everyNum = dataModel.productList.count;
            self.itemsArray = [self.itemsArray arrayByAddingObjectsFromArray:dataModel.productList];
            // 加载更多
            if( _loadMore )
            {
                _loadMore = NO;
                [self.loadingCell stopAnimation];
                
                if( _detailVC )
                {
                    _detailVC.everyNum = self.everyNum;
                    _detailVC.dataArray = self.itemsArray;
                    [_detailVC.collectionView reloadData];
                }
            }
        }
        else
        {
            // 错误处理
            [self netWorkError:nil];
        }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
        
        [self netWorkError:error];
    }];
    
}

#pragma mark - buttonClick

- (void)buttonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadButtonClick:(id)sender
{
    [super reloadButtonClick:sender];
    
    [self getProductListByCatrgoryIdWithStart:self.itemsArray.count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
