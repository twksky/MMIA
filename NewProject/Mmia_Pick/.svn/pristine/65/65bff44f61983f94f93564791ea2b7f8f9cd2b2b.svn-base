//
//  MmiaProductDetailViewController.m
//  MMIA
//
//  Created by MMIA-Mac on 15-6-4.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaProductDetailViewController.h"
#import "ProductDetailRequestModel.h"
#import "NSObject+MJKeyValue.h"
#import "MmiaProductDetailModel.h"
#import "ProductDetailPictureCell.h"
#import "ShareView.h"
#import "ProductHeader.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "MmiaBrandViewController.h"


@interface MmiaProductDetailViewController ()

@property (nonatomic, strong) MmiaProductModel* productModel;
@property ( nonatomic , strong ) ProductHeader* productHeader;

- (void)getProductDetailDataForRequest;

@end

@implementation MmiaProductDetailViewController

#pragma mark - init

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor clearColor];    
    [self.collectionView registerNib:UINibWithName(@"ProductHeader") forSupplementaryViewOfKind:CollectionElementKindSectionHeader withReuseIdentifier:@"cell2_CellHeader"];
    [self.collectionView registerClass:[ShareView class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" withReuseIdentifier:@"Share"];
    [self.collectionView registerNib:UINibWithName(@"ProductDetailPictureCell") forCellWithReuseIdentifier:ProductDetailPictureCellIdentifier ];
    self.collectionView.frame = CGRectMake(0, VIEW_OFFSET+kNavigationBarHeight, Main_Screen_Width, Main_Screen_Height-VIEW_OFFSET-kNavigationBarHeight-20);
    [self getProductDetailDataForRequest];
    [self addBackBtnWithTarget:self selector:@selector(back:)];
//    self.navigationController.navigationBarHidden = YES;
}

-(void)back:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark - Private

- (void)getProductDetailDataForRequest
{
    ProductDetailRequestModel *requestModel = [[ProductDetailRequestModel alloc] init];
    requestModel.spId = _spId;
    NSDictionary *infoDict = [requestModel keyValues];
    
    [[MMiaNetworkEngine sharedInstance]startPostAsyncRequestWithUrl:MmiaProductDetailURL param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
        
        if( ![responseDic[@"status"] intValue] )
        {
            NSLog( @"pDetail = %@", responseDic );
            MmiaProductDetailModel* dataModel = [MmiaProductDetailModel objectWithKeyValues:responseDic];
            self.productModel = [MmiaProductModel objectWithKeyValues:dataModel.product];
            
            [self.collectionView reloadData];
            [self addRightLabelWithText:self.productModel.title];
        }
        else
        {
            // 错误处理
        }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
        NSLog( @"%@", operation );
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.productModel == nil) {
        return 0;
    }
    else
        return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.productModel.productPictureList.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind  isEqual: @"UICollectionElementKindSectionHeader"]) {
       self.productHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cell2_CellHeader" forIndexPath:indexPath];
        [self.productHeader initWithTarget:self];
        self.productHeader.productModel = self.productModel;
        [self.productHeader.brandLogo sd_setImageWithURL:[NSURL URLWithString:self.productModel.brandLogo]];
        self.productHeader.singelName.text = self.productModel.title;
        self.productHeader.singelDescription.text = self.productModel.describe;
        return self.productHeader;
    }
    else if ([kind  isEqual: @"UICollectionElementKindSectionFooter"]){
        ShareView* shareView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Share" forIndexPath:indexPath];
        return shareView;
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailPictureCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProductDetailPictureCellIdentifier forIndexPath:indexPath];
    
    MmiaProductPictureListModel* item = self.productModel.productPictureList[indexPath.row];
    cell.productPictureListModel = item;
    [cell.pictureImageView sd_setImageWithURL:[NSURL URLWithString:item.picUrl] placeholderImage:nil];
    cell.describeLabel.text = item.describe;
    
    NSString *describe = ((MmiaProductPictureListModel*)self.productModel.productPictureList[indexPath.row]).describe;
    CGFloat H1 = [GlobalFunction getTextSizeWithSystemFont:[UIFont systemFontOfSize:10] ConstrainedToSize:CGSizeMake(Main_Screen_Width-20, Main_Screen_Height) string:describe].height;
    CGFloat H2 = 150;
    [cell setHeight:H1+H2+10+30];
    NSLog(@"%lf",cell.height);
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat H1 = [GlobalFunction getTextSizeWithSystemFont:[UIFont systemFontOfSize:15] ConstrainedToSize:CGSizeMake(Main_Screen_Width-20, 1000) string:self.productModel.title].height;
    CGFloat H2 = [GlobalFunction getTextSizeWithSystemFont:[UIFont systemFontOfSize:10] ConstrainedToSize:CGSizeMake(Main_Screen_Width-20, 1000) string:self.productModel.describe].height;
    
    CGSize size = CGSizeMake(self.view.width, 15+50+10+H1+5+H2);
    
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(self.view.width, 40);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MmiaProductPictureListModel* item = self.productModel.productPictureList[indexPath.row];
    CGFloat H1 = [GlobalFunction getTextSizeWithSystemFont:[UIFont systemFontOfSize:10] ConstrainedToSize:CGSizeMake(Main_Screen_Width-20, 1000) string:item.describe].height;

    CGSize size = CGSizeMake(self.view.width, 150+10+H1);
    
    return size;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}


-(void)pushBrand:(UIButton *)btn{
    NSLog(@"跳到品牌列表页");
    MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
    MmiaBrandViewController* brandViewController = [[MmiaBrandViewController alloc] initWithCollectionViewLayout:smallLayout];
    brandViewController.brandId = self.productModel.brandId;
    [self.navigationController pushViewController:brandViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
