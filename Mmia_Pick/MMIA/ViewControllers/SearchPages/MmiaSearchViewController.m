//
//  MmiaSearchViewController.m
//  MMIA
//
//  Created by lixiao on 15/5/18.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaSearchViewController.h"
#import "JTSlideShadowAnimation.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MmiaSearchCollectionViewCell.h"
#import "MmiaDataModel.h"
#import "MmiaSearchModel.h"
#import "MJExtension.h"
#import "MmiaDetailSearchViewController.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "MmiaBrandViewController.h"

@interface MmiaSearchViewController ()< CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDelegate>{
    MmiaDataModel *_dataModel;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // self.navigationView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor cyanColor];
    self.dataArr = [[NSMutableArray alloc]init];
    
    UITextField *searchTextFiled = [[UITextField alloc]init];
    searchTextFiled.backgroundColor = [UIColor clearColor];
    searchTextFiled.returnKeyType = UIReturnKeySearch;
    searchTextFiled.delegate = self;
    UIColor *placeHoderColor = ColorWithHexRGB(0x969696);
    searchTextFiled.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"搜索你喜欢得商品/商家" attributes:@{NSForegroundColorAttributeName:placeHoderColor}];
    searchTextFiled.layer.cornerRadius = 0.5f;
    searchTextFiled.layer.masksToBounds = YES;
    searchTextFiled.layer.borderWidth = 1.0;
    searchTextFiled.layer.borderColor = UIColorWhite.CGColor;
    [self.naviBarView addSubview:searchTextFiled];
    [searchTextFiled mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(self.naviBarView);
        make.height.equalTo(@30);
        make.left.equalTo(@30);
        make.right.equalTo(@-30);
    }];
    
    UILabel *lineLabel = [[UILabel alloc]init];
    lineLabel.backgroundColor = [UIColor whiteColor];
    [self.navigationView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(searchTextFiled);
        make.right.equalTo(searchTextFiled);
        make.height.equalTo(@1);
        make.bottom.equalTo(@0);
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
    layout.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30);
    layout.minimumInteritemSpacing = 0;
    layout.columnCount = 1;
    self.collectionView.collectionViewLayout = layout;
    [self getShopDataWithStart:0];
}

#pragma mark - Private
/**
 request
 **/
- (void)getShopDataWithStart:(NSInteger)start
{
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"userid",[NSNumber numberWithLong:start],@"start",[NSNumber numberWithInt:20],@"size",[NSNumber numberWithInt:1],@"type",@"手机",@"keyword",nil];
     NSString *searchUrl = @"ados/search/searchWord";
    [[MMiaNetworkEngine sharedInstance]startPostAsyncRequestWithUrl:searchUrl param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
        if ([responseDic[@"result"]integerValue] == 0)
        {
            _dataModel = [MmiaDataModel objectWithKeyValues:responseDic];
            NSArray *arr = [MmiaSearchModel objectArrayWithKeyValuesArray:_dataModel.data];
            [self.dataArr addObjectsFromArray:arr];
            [self.collectionView reloadData];
        }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
        
    }];
}


#pragma mark - UICollectionViewDelegate & dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(App_Frame_Width - 60, 70);
    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MmiaSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaSearchCellIdentifier forIndexPath:indexPath];
    [cell resetCellWithModel:[self.dataArr objectAtIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
    //smallLayout.footerReferenceSize = CGSizeMake(200, 400);
    MmiaDetailSearchViewController *detailVC = [[MmiaDetailSearchViewController alloc]initWithCollectionViewLayout:smallLayout];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - textFiledDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
     MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
    MmiaBrandViewController *brandVC = [[MmiaBrandViewController alloc]initWithCollectionViewLayout:smallLayout];
    [self.navigationController pushViewController:brandVC animated:YES];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
