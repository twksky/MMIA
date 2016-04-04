//
//  MmiaSearchViewController.m
//  MMIA
//
//  Created by lixiao on 15/5/18.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaSearchViewController.h"
#import "MmiaSearchCollectionViewCell.h"
#import "MmiaDetailSearchViewController.h"
#import "MmiaProductDetailViewController.h"
#import "MmiaBrandViewController.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "UIImage+ImageEffects.h"
#import "MmiaDetailSearchRequestModel.h"
#import "MmiaPublicResponseModel.h"


@interface MmiaSearchViewController ()<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
{
    UITextField *_searchTextFiled;
    NSInteger    _num;
}

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation MmiaSearchViewController

#pragma mark - Init
- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if( self = [super initWithCollectionViewLayout:layout] )
    {
    
    }
    return self;
}

#pragma mark - LifeStyle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.collectionView.backgroundColor = ColorWithHexRGBA(0x000000, 0.4);
    self.naviBarView.backgroundColor = ColorWithHexRGBA(0x000000, 0.4);
    self.statusView.backgroundColor = ColorWithHexRGBA(0x000000, 0.4);
    [_searchTextFiled performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.collectionView.alwaysBounceVertical = YES;
     self.collectionView.delegate = self;
     self.collectionView.dataSource = self;

    UINib *nib2 = [UINib nibWithNibName:@"MmiaSearchCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib2 forCellWithReuseIdentifier:MmiaSearchCellIdentifier];

    self.screenshotImage = [self.screenshotImage applyTintEffectWithColor:nil];
    self.view.layer.contents = (id)self.screenshotImage.CGImage;
    self.dataArr = [[NSMutableArray alloc]init];
    [self addBackBtnWithTarget:self selector:@selector(buttonClick:)];

   _searchTextFiled = [[UITextField alloc]init];
    _searchTextFiled.backgroundColor = [UIColor clearColor];
    _searchTextFiled.returnKeyType = UIReturnKeySearch;
    _searchTextFiled.delegate = self;
    _searchTextFiled.font = [UIFont systemFontOfSize:15];
    _searchTextFiled.layer.cornerRadius = 0.5f;
    _searchTextFiled.layer.masksToBounds = YES;
    _searchTextFiled.layer.borderWidth = 1.0;
    _searchTextFiled.layer.borderColor = ColorWithHexRGBA(0xffffff, 0.3).CGColor;
    _searchTextFiled.rightViewMode = UITextFieldViewModeAlways;
    _searchTextFiled.leftViewMode = UITextFieldViewModeAlways;
    _searchTextFiled.textColor = ColorWithHexRGB(0xffffff);
    [_searchTextFiled addTarget:self action:@selector(textFiledChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIImageView *rightImageView = [[UIImageView alloc]init];
    rightImageView.bounds = CGRectMake(0, 0, 34, 34);
    rightImageView.image = [UIImage imageNamed:@"searchBtn.png"];
    rightImageView.contentMode = UIViewContentModeCenter;
    _searchTextFiled.rightView = rightImageView;
    
    UIView *leftView = [[UIView alloc]init];
    leftView.bounds = CGRectMake(0, 0, 10, 34);
    leftView.backgroundColor = UIColorClear;
    _searchTextFiled.leftView = leftView;
    [self.naviBarView addSubview:_searchTextFiled];
    
    [_searchTextFiled mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.naviBarView);
        make.height.equalTo(@34);
        make.left.equalTo(@50);
        make.right.equalTo(@-10);
    }];
   
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    
}

#pragma mark - ClickEvent

- (void)buttonClick:(UIButton *)button
{
//    [self willMoveToParentViewController:nil];
//    [self.view removeFromSuperview];
    [self pushOrPopIntoViewControllerAnimator];
    [self.navigationController popViewControllerAnimated:NO];
}

//textFiled.text改变时随时更新数据
- (void)textFiledChange:(UITextField *)textFlied
{
    [self getgetSearchBrandByKeywordWithStart:0];
}

#pragma mark - Request

- (void)getgetSearchBrandByKeywordWithStart:(NSInteger)start
{
    MmiaDetailSearchRequestModel *model = [[MmiaDetailSearchRequestModel alloc]init];
    model.keyword = _searchTextFiled.text;
    model.start = start;
    model.size = 10;
    NSDictionary *infoDict = [model keyValues];
    
    [[MMiaNetworkEngine sharedInstance]startPostAsyncRequestWithUrl:Mmia_SearchBrandByKeyWord param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic)
    {
        
        if( ![responseDic[@"status"] intValue] )
        {
            [self.dataArr removeAllObjects];
            MmiaPaperResponseModel *dataModel = [MmiaPaperResponseModel objectWithKeyValues:responseDic];
            [self.dataArr addObjectsFromArray:dataModel.searchList];
            [self.collectionView reloadData];
        }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error)
    {
        
    }];
}

#pragma mark - Private

/**
 *** vc 跳转动画
 **/
- (void)pushOrPopIntoViewControllerAnimator
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromRight;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
}

#pragma mark - UICollectionViewDelegate & dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(App_Frame_Width, 60);
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MmiaSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaSearchCellIdentifier forIndexPath:indexPath];
    
    MmiaPaperProductListModel *model = (MmiaPaperProductListModel *)[self.dataArr objectAtIndex:indexPath.row];
     [cell resetCellWithModel:model];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MmiaPaperProductListModel *model = (MmiaPaperProductListModel *)[self.dataArr objectAtIndex:indexPath.row];
    
    // 根据type类型选择跳转的页面
    if( model.type == 0 )
    {
        // 进入单品详情页
        CHTCollectionViewWaterfallLayout* detailLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
        MmiaProductDetailViewController* detailViewController = [[MmiaProductDetailViewController alloc] initWithCollectionViewLayout:detailLayout];
        detailViewController.spId = model.sourceId;
        [self pushOrPopIntoViewControllerAnimator];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if( model.type == 1 )
    {
        // 进入品牌列表页
        MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
        MmiaBrandViewController* brandViewController = [[MmiaBrandViewController alloc] initWithCollectionViewLayout:smallLayout];
        brandViewController.brandId = model.sourceId;
            [self pushOrPopIntoViewControllerAnimator];
        [self.navigationController pushViewController:brandViewController animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchTextFiled resignFirstResponder];
}

#pragma mark - textFiledDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *searchStr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (searchStr.length == 0)
    {
        return NO;
    }
    
     MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
    MmiaDetailSearchViewController *detailVC = [[MmiaDetailSearchViewController alloc]initWithCollectionViewLayout:smallLayout];
    detailVC.keyWord = textField.text;
    
    [self pushOrPopIntoViewControllerAnimator];
    [self.navigationController pushViewController:detailVC animated:NO];
     [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end