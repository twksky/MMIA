//
//  MmiaBrandViewController.m
//  MMIA
//
//  Created by lixiao on 15/5/21.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaBrandViewController.h"
#import "NSObject+MJKeyValue.h"
#import "MmiaBrandRequestModel.h"
#import "MmiaSingleGoodsCollectionCell.h"
#import "MmiaBrandCollectionCell.h"

@interface MmiaBrandViewController (){
    MmiaPaperResponseModel  *_dataModel;
    MmiaPaperBrandModel     *_brandModel;
}

@property (nonatomic, retain) NSArray *recommendArry;

@end

@implementation MmiaBrandViewController

#pragma mark - Setter

- (UILabel *)brandTitleLabel
{
    if (!_brandTitleLabel)
    {
        _brandTitleLabel = [[UILabel alloc]init];
        _brandTitleLabel.backgroundColor = [UIColor clearColor];
        _brandTitleLabel.textColor = ColorWithHexRGB(0xffffff);
        _brandTitleLabel.textAlignment = MMIATextAlignmentRight;
        _brandTitleLabel.font = UIFontSystem(20);
        [self.naviBarView addSubview:_brandTitleLabel];
        
        [_brandTitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(self.naviBarView);
            make.right.equalTo(self.naviBarView).offset(-10);
            make.left.equalTo(self.naviBarView).offset(100);
            make.height.equalTo(self.naviBarView);
        }];
    }
    return _brandTitleLabel;
}

- (UIImageView *)logoImageView
{
    if (!_logoImageView)
    {
        _logoImageView = [[UIImageView alloc]init];
        _logoImageView.backgroundColor = [UIColor clearColor];
        [self.topImageView addSubview:_logoImageView];
        
        [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make){
           
            make.top.equalTo(self.naviBarView.mas_bottom).offset(18);
            make.right.equalTo(self.naviBarView).offset(-10);
            make.width.height.equalTo(@50);
        }];
    }
    return _logoImageView;
}

#pragma mark - lifeStyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view bringSubviewToFront:self.navigationView];
    [self addBackBtnWithTarget:self selector:@selector(buttonClick:)];
    self.navigationView.backgroundColor = UIColorClear;
    self.topDataArray = @[@"photo1.jpg", @"photo2.jpg", @"photo3.jpg"];
    self.brandTitleLabel.text = @"GT500R";
    self.logoImageView.image = [UIImage imageNamed:@"photo2.jpg"];
    [self getProductListWithStart:0];
}

#pragma mark - Request

- (void)getProductListWithStart:(NSInteger)start
{
    MmiaBrandRequestModel *model = [[MmiaBrandRequestModel alloc]init];
    model.start = start;
    model.size = Request_Size;
    model.brandId = 0;
    NSDictionary *infoDict = [model keyValues];
    
    [[MMiaNetworkEngine sharedInstance]startPostAsyncRequestWithUrl:Mmia_ProductListByBrandId param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
        
        if ([responseDic[@"result"]integerValue] == 0)
        {
            _dataModel = [MmiaPaperResponseModel objectWithKeyValues:responseDic];
            //推荐
            NSArray *recommendArr = [MmiaPaperRecommendModel objectArrayWithKeyValuesArray: _dataModel.recommendList];
            
            _brandModel = [MmiaPaperBrandModel objectWithKeyValues:_dataModel.brand];
            NSArray *productListArr = [MmiaPaperProductListModel objectArrayWithKeyValuesArray:_dataModel.productList];
            
            [self.itemsArray addObjectsFromArray:productListArr];
            [self.collectionView reloadData];
            
        }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
        
    }];
    
}

#pragma mark - ButtonClick

- (void)buttonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemsArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if (indexPath.row == 0)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaBrandCellIdentifier forIndexPath:indexPath];
        [(MmiaBrandCollectionCell *)cell reloadCellWithModel:_brandModel];
        cell.backgroundColor = [UIColor whiteColor];
    }else
    {
        MmiaPaperProductListModel *model = [self.itemsArray objectAtIndex:(indexPath.row - 1)];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaSingleGoodsCellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [(MmiaSingleGoodsCollectionCell *)cell reloadCellWithModel:model];
    }
    return cell;
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
