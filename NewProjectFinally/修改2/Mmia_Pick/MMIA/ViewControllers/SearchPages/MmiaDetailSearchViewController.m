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

@interface MmiaDetailSearchViewController ()
{
    NSString *_keyWord;
    UILabel  *_searchLabel;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
               //错误处理
               [self netWorkError:nil];
           }
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
        
        [self netWorkError:error];
    }];
}

#pragma mark - buttonClick

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

- (void)reloadButtonClick:(id)sender
{
    [super reloadButtonClick:sender];
    
    [self getSearchByKeyWordWithStart:self.itemsArray.count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
