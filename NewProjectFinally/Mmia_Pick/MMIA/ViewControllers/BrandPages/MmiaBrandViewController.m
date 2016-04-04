//
//  MmiaBrandViewController.m
//  MMIA
//
//  Created by lixiao on 15/5/21.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaBrandViewController.h"
#import "MmiaBrandRequestModel.h"
#import "MmiaSingleGoodsCollectionCell.h"
#import "MmiaBrandCollectionCell.h"
#import "MmiaLoadingCollectionCell.h"
#import "MmiaBrandDetailsViewController.h"

@interface MmiaBrandViewController (){
   MmiaPaperProductListModel   *_brandModel;
              NSInteger         _slide;
               BOOL             _addMoreData;
}

@property (nonatomic, retain) NSArray *recommendArry;
@property (nonatomic, strong) MmiaBrandDetailsViewController *brandDeViewController;

@end

@implementation MmiaBrandViewController

#pragma mark - Setter & Getter

- (void)setBrandId:(NSInteger)brandId
{
    if (_brandId != brandId)
    {
        _brandId = brandId;
        [self getProductListWithStart:0];
    }
}

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
        _logoImageView.clipsToBounds = YES;
        _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
        //_logoImageView.backgroundColor = [UIColor clearColor];
        [self.topImageView addSubview:_logoImageView];
        
        [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make){
           
            make.top.equalTo(self.naviBarView.mas_bottom).offset(18);
            make.right.equalTo(self.naviBarView).offset(-10);
            make.width.height.equalTo(@50);
        }];
    }
    return _logoImageView;
}

- (MmiaBrandDetailsViewController *)brandDeViewController
{
    if (!_brandDeViewController)
    {
        MmiaCollectionViewLargeLayout* largeLayout = [[MmiaCollectionViewLargeLayout alloc] init];
        _brandDeViewController = [[MmiaBrandDetailsViewController alloc]initWithCollectionViewLayout:largeLayout];
    }
    return _brandDeViewController;
}

#pragma mark - lifeStyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lineLabel.hidden = YES;
    [self addBackBtnWithTarget:self selector:@selector(buttonClick:)];
}

#pragma mark - Private

//请求
- (void)getProductListWithStart:(NSInteger)start
{
    MmiaBrandRequestModel *model = [[MmiaBrandRequestModel alloc]init];
    model.start = start;
    model.size = Request_Size;
    model.brandId = _brandId;
    NSDictionary *infoDict = [model keyValues];
    
    [[MMiaNetworkEngine sharedInstance]startPostAsyncRequestWithUrl:Mmia_ProductListByBrandId param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
      
        if( ![responseDic[@"status"] intValue] )
        {
           MmiaPaperResponseModel *dataModel = [MmiaPaperResponseModel objectWithKeyValues:responseDic];
            //推荐
            self.topDataArray = dataModel.recommendList;
            
            _brandModel = [MmiaPaperProductListModel objectWithKeyValues:dataModel.brand];
            [self.logoImageView sd_setImageWithURL:NSURLWithString(_brandModel.logo)];
            self.rightLabel.text = _brandModel.name;
            
             self.everyNum = dataModel.productList.count;
            self.itemsArray = [self.itemsArray arrayByAddingObjectsFromArray:dataModel.productList];
            // 刷新详情页数据
            self.brandDeViewController.everyNum = dataModel.productList.count;
            NSMutableArray *mutableArr = [[NSMutableArray alloc]initWithArray:self.itemsArray];
            [mutableArr insertObject:_brandModel atIndex:0];
            self.brandDeViewController.dataArray = mutableArr;
            if (_addMoreData)
            {
                [self.brandDeViewController.collectionView reloadData];
                _addMoreData = NO;
            }
    
        }else
        {
            self.everyNum = 0;
            [self.collectionView reloadData];
            _addMoreData = NO;
        }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
        
    }];
}

#pragma mark - ButtonClick

/*返回跳转*/
- (void)buttonClick:(UIButton *)button
{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.5f;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionFromRight;
//    transition.subtype = kCATransitionFromTop;
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_brandModel == nil)
    {
        return 0;
    }
    return (self.everyNum >= Request_Size)? (self.itemsArray.count + 2):(self.itemsArray.count + 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    if (indexPath.row == 0)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaBrandCellIdentifier forIndexPath:indexPath];
        [(MmiaBrandCollectionCell *)cell reloadCellWithModel:_brandModel];
        cell.backgroundColor = [UIColor whiteColor];
    }else if (indexPath.row == (self.itemsArray.count + 1)){
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaLoadCellIdentifier forIndexPath:indexPath];
        [(MmiaLoadingCollectionCell *)cell startAnimation];
        
    }else
    {
        MmiaPaperProductListModel *model = [self.itemsArray objectAtIndex:(indexPath.row - 1)];
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaSingleGoodsCellIdentifier forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [(MmiaSingleGoodsCollectionCell *)cell reloadCellWithModel:model];
    }
    
    if (self.itemsArray.count - indexPath.row == 3 && self.everyNum >= Request_Size)
    {
        [self getProductListWithStart:self.itemsArray.count];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.brandDeViewController.useLayoutToLayoutNavigationTransitions = YES;
    
    __block  MmiaBrandViewController *brandVC = self;
    self.brandDeViewController.AddMoreDataBlock = ^(MmiaBrandDetailsViewController *detailVC){
        _addMoreData = YES;
        [brandVC getProductListWithStart:brandVC.itemsArray.count];
    };
    
    [self.navigationController pushViewController:self.brandDeViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
