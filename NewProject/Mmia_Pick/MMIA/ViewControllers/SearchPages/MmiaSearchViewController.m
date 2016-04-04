//
//  MmiaSearchViewController.m
//  MMIA
//
//  Created by lixiao on 15/5/18.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaSearchViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MmiaSearchCollectionViewCell.h"
#import "MJExtension.h"
#import "MmiaDetailSearchViewController.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "MmiaBrandViewController.h"
#import "MmiaBaseModel.h"
#import "UIImage+ImageEffects.h"

@interface MmiaSearchViewController ()< CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDelegate>
{
    UITextField *_searchTextFiled;
}

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation MmiaSearchViewController

#pragma mark - Init
- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if( self = [super initWithCollectionViewLayout:layout] )
    {
        //self.collectionView.backgroundColor = [UIColor redColor];
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.screenshotImage = [self.screenshotImage applyLightEffect];
    self.view.layer.contents = (id)self.screenshotImage.CGImage;
    self.collectionView.backgroundColor = [UIColor redColor];
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
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.top.equalTo(self.navigationView.mas_bottom);
    }];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UINib *nib2 = [UINib nibWithNibName:@"MmiaSearchCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib2 forCellWithReuseIdentifier:MmiaSearchCellIdentifier];
    self.collectionView.backgroundColor = [UIColor clearColor];
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    layout.columnCount = 1;
    self.collectionView.collectionViewLayout = layout;
    [self getShopDataWithStart:0];
}

#pragma mark - ButtonClick

- (void)buttonClick:(UIButton *)button
{
//    [self willMoveToParentViewController:nil];
//    [self.view removeFromSuperview];
    [self pushOrPopIntoViewControllerAnimator];
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - Request

- (void)getShopDataWithStart:(NSInteger)start
{
   MmiaBaseModel *base = [[MmiaBaseModel alloc]init];
    NSDictionary *dict = [base keyValues];
     NSString *searchUrl = @"/category/getFirstLevelCategory";

    [[MMiaNetworkEngine sharedInstance]startPostAsyncRequestWithUrl:searchUrl param:dict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){

        if( ![responseDic[@"status"] intValue] )
        {
//            NSArray *arr = [MmiaSearchModel objectArrayWithKeyValuesArray:_dataModel.data];
//            [self.dataArr addObjectsFromArray:arr];
//            [self.collectionView reloadData];
        }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
        
    }];
}

#pragma mark - Private

/**
 *** vc 跳转动画
 **/
- (void)pushOrPopIntoViewControllerAnimator
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromRight;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
}


#pragma mark - UICollectionViewDelegate & dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return self.dataArr.count;
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(App_Frame_Width, 60);
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MmiaSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaSearchCellIdentifier forIndexPath:indexPath];
    //[cell resetCellWithModel:[self.dataArr objectAtIndex:indexPath.row]];
    [cell reloadCell];
    
//    if (self.dataArr.count - indexPath.row == 2 && _dataModel.num >= 15)
//    {
//        [self getShopDataWithStart:self.dataArr.count];
//    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
    MmiaBrandViewController *brandVC = [[MmiaBrandViewController alloc]initWithCollectionViewLayout:smallLayout];
    brandVC.brandId = 153;
    
    [self pushOrPopIntoViewControllerAnimator];
    [self.navigationController pushViewController:brandVC animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchTextFiled resignFirstResponder];
}

#pragma mark - textFiledDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

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