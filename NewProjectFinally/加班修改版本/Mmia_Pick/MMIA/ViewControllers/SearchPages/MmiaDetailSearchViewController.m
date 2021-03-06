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
#import "MmiaLoadingCollectionCell.h"

@interface MmiaDetailSearchViewController (){
    NSString     *_keyWord;
    UILabel      *_searchLabel;
    BOOL         _addMoreData;
}

@end

@implementation MmiaDetailSearchViewController

- (void)setKeyWord:(NSString *)keyWord
{
    if ( ![_keyWord isEqualToString:keyWord] )
    {
        _keyWord = keyWord;
        _searchLabel.text = _keyWord;
        [self getSearchByKeyWordWithStart:0];
    }
}

#pragma mark - LifeStyle

- (void)viewDidLoad {
    [super viewDidLoad];
     // Do any additional setup after loading the view.
    
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.navigationView];
    [self addBackBtnWithTarget:self selector:@selector(tapBackClick:)];
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
    
    _searchLabel = [[UILabel alloc]init];
    _searchLabel.backgroundColor = [UIColor clearColor];
    _searchLabel.font = [UIFont systemFontOfSize:15];
    _searchLabel.textColor = ColorWithHexRGB(0xffffff);
    [self.navigationView addSubview:_searchLabel];

    UIImageView *searchImageView = [[UIImageView alloc]init];
    searchImageView.contentMode = UIViewContentModeCenter;
     searchImageView.image = [UIImage imageNamed:@"searchBtn.png"];
    [self.naviBarView addSubview:searchImageView];
    
    [searchImageView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.right.equalTo(bgView);
        make.width.height.equalTo(bgView.mas_height);
    }];
    
    [_searchLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.bottom.equalTo(bgView);
        make.left.equalTo(bgView).offset(10);
        make.right.equalTo(searchImageView.mas_left);
    }];

}

#pragma mark - Request

- (void)getSearchByKeyWordWithStart:(NSInteger)start
{
    MmiaDetailSearchRequestModel *model = [[MmiaDetailSearchRequestModel alloc]init];
    model.keyword = _keyWord;
    //model.keyword = @"手机";
    model.start = start;
    model.size = Request_Size;
    NSDictionary *infoDict = [model keyValues];
    
    [[MMiaNetworkEngine sharedInstance]startPostAsyncRequestWithUrl:Mmia_SearchByKeyWord param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
           
           if( ![responseDic[@"status"] intValue] )
           {
              MmiaPaperResponseModel *dataModel = [MmiaPaperResponseModel objectWithKeyValues:responseDic];
               self.topDataArray = dataModel.recommendList;
               self.itemsArray = [self.itemsArray arrayByAddingObjectsFromArray:dataModel.searchList];
               self.everyNum = dataModel.searchList.count;
                // 刷新详情页数据
               
               if (_detailVC)
               {
                   _detailVC.everyNum = dataModel.searchList.count;
                   _detailVC.dataArray = self.itemsArray;
                   if (_addMoreData)
                   {
                       [_detailVC.collectionView reloadData];
                       _addMoreData = NO;
                   }
               }
               
           }else
           {
               //错误处理
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
    [self getSearchByKeyWordWithStart:self.itemsArray.count];
}

#pragma mark - Click

/* 返回跳转 */
- (void)tapBackClick:(id *)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromRight;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - collectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (self.everyNum >= Request_Size) ? (self.itemsArray.count + 1):self.itemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if (indexPath.row == self.itemsArray.count)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaLoadCellIdentifier forIndexPath:indexPath];
        [(MmiaLoadingCollectionCell *)cell startAnimation];
        
    }else{
        
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
       [self getSearchByKeyWordWithStart:self.itemsArray.count];
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
