//
//  MmiaDetailSearchViewController.m
//  MMIA
//
//  Created by lixiao on 15/5/20.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaDetailSearchViewController.h"
#import "MmiaSingleGoodsCollectionCell.h"
#import "MmiaDescripBrandCollectionCell.h"
#import "MmiaDetailSearchRequestModel.h"
#import "NSObject+MJKeyValue.h"

@interface MmiaDetailSearchViewController (){
    UILabel *_searchLabel;
    MmiaPaperResponseModel *_dataModel;
}

@end

@implementation MmiaDetailSearchViewController


#pragma mark - LifeStyle

- (void)viewDidLoad {
    [super viewDidLoad];
     // Do any additional setup after loading the view.
     [self.view bringSubviewToFront:self.navigationView];
    [self addBackBtnWithTarget:self selector:@selector(tapBackClick:)];
    self.topDataArray = @[@"photo1.jpg", @"photo2.jpg", @"photo3.jpg"];
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.layer.borderColor = ColorWithHexRGBA(0xffffff, 0.3).CGColor;
    bgView.layer.borderWidth = 1.0f;
    bgView.layer.cornerRadius = 0.5f;
    bgView.layer.masksToBounds = YES;
    [self.naviBarView addSubview:bgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackClick:)];
    [bgView addGestureRecognizer:tap];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.naviBarView);
        make.height.equalTo(@34);
        make.left.equalTo(@50);
        make.right.equalTo(@-10);
    }];
    
   self.searchLabel = [[UILabel alloc]init];
   self.searchLabel.backgroundColor = [UIColor clearColor];
    self.searchLabel.font = [UIFont systemFontOfSize:15];
   self.searchLabel.textColor = ColorWithHexRGB(0xffffff);
    [self.navigationView addSubview:self.searchLabel];
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.bottom.equalTo(bgView);
        make.left.equalTo(bgView).offset(10);
    }];

    UIImageView *searchImageView = [[UIImageView alloc]init];
    searchImageView.contentMode = UIViewContentModeCenter;
     searchImageView.image = [UIImage imageNamed:@"searchBtn.png"];
    [self.naviBarView addSubview:searchImageView];
    [searchImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.right.equalTo(bgView);
        make.width.height.equalTo(bgView.mas_height);
    }];
    [_searchLabel mas_updateConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(searchImageView.mas_left);
    }];
    
    [self getSearchByKeyWordWithStart:0];
}


#pragma mark - Request

- (void)getSearchByKeyWordWithStart:(NSInteger)start
{
    MmiaDetailSearchRequestModel *model = [[MmiaDetailSearchRequestModel alloc]init];
    model.keyword = @"手机";
    model.start = start;
    model.size = Request_Size;
    NSDictionary *infoDict = [model keyValues];
       [[MMiaNetworkEngine sharedInstance]startPostAsyncRequestWithUrl:Mmia_SearchByKeyWord param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
           
           if ([responseDic[@"result"]integerValue] == 0)
           {
               _dataModel = [MmiaPaperResponseModel objectWithKeyValues:responseDic];
                NSArray *arr = [MmiaPaperProductListModel objectArrayWithKeyValuesArray:_dataModel.searchList];
                [self.itemsArray addObjectsFromArray:arr];
                [self.collectionView reloadData];
           }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
        
    }];
}

- (void)tapBackClick:(id *)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromRight;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
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


@end
