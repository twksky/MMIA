//
//  MmiaSearchViewController.m
//  MMIA
//
//  Created by lixiao on 15/5/18.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaSearchViewController.h"
#import "MmiaSearchListViewController.h"
#import "MmiaBrandViewController.h"
#import "MmiaProductDetailViewController.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "MmiaSearchCollectionViewCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MmiaDetailSearchRequestModel.h"
#import "MmiaPublicResponseModel.h"
#import "MmiaPaperResponseModel.h"

@interface MmiaSearchViewController ()<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
{
    UITextField *_searchTextFiled;
}

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation MmiaSearchViewController

#pragma mark - LifeStyle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *delegate = [AppDelegate sharedAppDelegate];
    [delegate.tabBarViewController hideOrNotTabBar:NO];
    
    self.collectionView.frame = CGRectMake(0, VIEW_OFFSET + kNavigationBarHeight, App_Frame_Width,self.view.height - VIEW_OFFSET - kNavigationBarHeight - 45);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"search_bg_icon.png"]];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = ColorWithHexRGBA(0x000000, 0.3);
    self.dataArr = [[NSMutableArray alloc]init];

    UINib *nib2 = [UINib nibWithNibName:@"MmiaSearchCollectionViewCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib2 forCellWithReuseIdentifier:MmiaSearchCellIdentifier];
    [self creatNavigationBar];
}

#pragma mark - Private
#pragma mark -LoadUI

- (void)creatNavigationBar
{
    self.navigationView.backgroundColor = [ColorWithHexRGB(0x000000) colorWithAlphaComponent:0.2];
    
    UIView *searchView = [[UIView alloc]init];
    searchView.backgroundColor = [UIColor clearColor];
    [self.naviBarView addSubview:searchView];
    
    UITextField *textFiled = [[UITextField alloc]init];
    textFiled.backgroundColor = [UIColor clearColor];
    textFiled.returnKeyType = UIReturnKeySearch;
    textFiled.delegate = self;
    UIColor *placeHolerColcor = ColorWithHexRGB(0xeeeeee);
    textFiled.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"搜索" attributes:@{NSForegroundColorAttributeName: placeHolerColcor}];
    textFiled.font = [UIFont systemFontOfSize:20];
    textFiled.rightViewMode = UITextFieldViewModeAlways;
    textFiled.textColor = ColorWithHexRGB(0xffffff);
    [textFiled addTarget:self action:@selector(textFiledChange:) forControlEvents:UIControlEventEditingChanged];
    [searchView addSubview:textFiled];
    _searchTextFiled = textFiled;
    
    UIImage *rightImage = [UIImage imageNamed:@"search.png"];
    UIImageView *rightImageView = [[UIImageView alloc]init];
    rightImageView.image = rightImage;
    rightImageView.bounds = CGRectMake(0, 0, rightImage.size.width + 12, kNavigationBarHeight - 13.5f);
    rightImageView.contentMode = UIViewContentModeCenter;
    textFiled.rightView = rightImageView;
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = ColorWithHexRGB(0xffffff);
    [searchView addSubview:lineLabel];
    
    [searchView mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.naviBarView).offset(10);
        make.right.equalTo(self.naviBarView).offset(-10);
        make.top.equalTo(self.naviBarView).offset(6.5f);
        make.bottom.equalTo(self.naviBarView).offset(-6.5f);
    }];
    
    [textFiled mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.right.equalTo(searchView);
        make.left.equalTo(searchView).offset(10);
        make.bottom.equalTo(lineLabel.mas_top);
    }];
    
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.bottom.left.right.equalTo(searchView);
        make.height.equalTo(@0.5f);
    }];
}

#pragma mark -ClickEvent

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
     [_searchTextFiled resignFirstResponder];
    
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
    
    CHTCollectionViewWaterfallLayout* layout = [[CHTCollectionViewWaterfallLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(KHomeCollectionViewMargin, KHomeCollectionViewMargin, KHomeCollectionViewMargin, KHomeCollectionViewMargin);
    layout.columnCount = 2;
    layout.minimumColumnSpacing = KHomeCollectionViewCell_Spacing;
    layout.minimumInteritemSpacing = KHomeCollectionViewCell_Spacing;
    
    MmiaSearchListViewController *listVC = [[MmiaSearchListViewController alloc]initWithCollectionViewLayout:layout KeyWord:searchStr];
    [self pushOrPopIntoViewControllerAnimator];
    [self.navigationController pushViewController:listVC animated:NO];
     [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
