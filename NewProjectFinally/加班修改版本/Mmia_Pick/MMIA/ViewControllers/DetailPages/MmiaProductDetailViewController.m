//
//  MmiaProductDetailViewController.m
//  MMIA
//
//  Created by MMIA-Mac on 15-6-4.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaProductDetailViewController.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MmiaBrandViewController.h"
#import "ProductHeader.h"
#import "ShareViewFooter.h"
#import "ProductDetailPictureCell.h"
#import "MmiaShareView.h"


@interface MmiaProductDetailViewController () <CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, strong) MmiaPaperProductListModel* productInfoModel;

- (void)getProductDetailDataForRequest;

@end

@implementation MmiaProductDetailViewController

#pragma mark - init

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if( self = [super initWithCollectionViewLayout:layout] )
    {
        CHTCollectionViewWaterfallLayout* flowLayout = (CHTCollectionViewWaterfallLayout *)layout;
        flowLayout.sectionInset = UIEdgeInsetsMake(KProductDetailPicture_LeftMargin, KProductDetailPicture_LeftMargin, KProductDetailPicture_LeftMargin, KProductDetailPicture_LeftMargin);
        flowLayout.minimumColumnSpacing = 0;
        flowLayout.minimumInteritemSpacing = KProductDetailPicture_LeftMargin;
        flowLayout.columnCount = 1;
        
        // Header
        [self.collectionView registerNib:UINibWithName(@"ProductHeader") forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:ProductHeaderIdentifier];
        // Cell
        [self.collectionView registerNib:UINibWithName(@"ProductDetailPictureCell") forCellWithReuseIdentifier:ProductDetailPictureCellIdentifier ];
        // Footer
        [self.collectionView registerClass:[ShareViewFooter class]
                forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                       withReuseIdentifier:ProductFooterIdentifier];
        
        self.collectionView.alwaysBounceVertical = YES;
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.collectionView.frame = CGRectMake(0, VIEW_OFFSET + kNavigationBarHeight, self.view.width, self.view.height - VIEW_OFFSET - kNavigationBarHeight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    self.view.backgroundColor = [UIColor whiteColor];
    self.lineLabel.backgroundColor = ColorWithHexRGB(0x999999);
    [self addBackBtnWithTarget:self selector:@selector(back:)];
    [self.rightLabel setShadowColor:[UIColor blackColor]];
    [self.rightLabel setShadowOffset:CGSizeMake(0.0f, 0.5f)];
    self.rightLabel.textColor = ColorWithHexRGB(0x333333);
}

#pragma mark - ** 重写详情页返回按钮

- (void)addBackBtnWithTarget:(id)target selector:(SEL)selector
{
    UIButton *backButton = [[UIButton alloc]init];
    backButton.tag = 1001;
    UIImage *backImage = [UIImage imageNamed:@"detail_back.png"];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.naviBarView addSubview:backButton];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.top.equalTo(self.naviBarView);
        make.size.mas_equalTo(CGSizeMake(50, kNavigationBarHeight));
    }];
}

#pragma mark - Private

- (void)getProductDetailDataForRequest
{
    ProductDetailRequestModel *requestModel = [[ProductDetailRequestModel alloc] init];
    requestModel.spId = self.spId;
    NSDictionary *infoDict = [requestModel keyValues];
    
    [[MMiaNetworkEngine sharedInstance] startPostAsyncRequestWithUrl:MmiaProductDetailURL param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
        
        if( ![responseDic[@"status"] intValue] )
        {
            MmiaProductDetailModel* dataModel = [MmiaProductDetailModel objectWithKeyValues:responseDic];
            self.productInfoModel = [MmiaPaperProductListModel objectWithKeyValues:dataModel.product];
            
            [self.collectionView reloadData];
            self.rightLabel.text = self.productInfoModel.title;
        }
        else
        {
            // 错误处理
        }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
        NSLog( @"error = %@", operation );
    }];
}

- (void)setSpId:(NSInteger)spId
{
    _spId = spId;
    
    [self getProductDetailDataForRequest];
}

#pragma mark - 响应事件
#pragma mark **返回按钮

-(void)back:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark **点击logoImage

- (void)tapProductBrandLogoWithBrandId
{
    // 进入品牌列表页
    MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
    MmiaBrandViewController* brandViewController = [[MmiaBrandViewController alloc] initWithCollectionViewLayout:smallLayout];
    brandViewController.brandId = self.productInfoModel.brandId;
    
    [self.navigationController pushViewController:brandViewController animated:YES];
}

#pragma mark **点击分享按钮

- (void)tapFootGoodOrShareButtonClick:(UIButton *)sender
{
    // TODO:点击分享
    if (sender.tag == 200)
    {
        //点赞
        [self doClickGoodButtonWithButton:sender];
        
    }else if (sender.tag == 201)
    {
        //分享
        [self showShareWithButton:sender];
    }

}

//点赞
- (void)doClickGoodButtonWithButton:(UIButton *)button
{
    UIImage *alreadyImage = [UIImage imageNamed:@"已赞.png"];
    UIImage *notImage = [UIImage imageNamed:@"点赞.png"];
    
    [button.imageView.image isEqual: alreadyImage] ?
    ([button setImage:notImage forState:UIControlStateNormal]) :
    ([button setImage:alreadyImage forState:UIControlStateNormal]);
}

//分享
- (void)showShareWithButton:(UIButton *)button
{
    UIImage *image = [UIImage imageNamed:@"微信分享.png"];
    CGFloat height = 15 + image.size.height + 20 + 1 + 50;
    
    MmiaShareView *shareView = [[MmiaShareView alloc]initWithShareViewHeight:height];
    [shareView showAnimation];
    
    __block MmiaShareView *cancelView = shareView;
    shareView.shareViewButtonClick = ^(UIButton *button){
        
        switch (button.tag)
        {
            case 300:
                //微信
                NSLog(@"微信");
                break;
                
            case 301:
                //朋友圈
                NSLog(@"朋友圈");
                break;
                
            case 302:
                //微博
                NSLog(@"微博");
                break;
                
            case 303:
                //QQ
                NSLog(@"QQ");
                break;
                
            case 400:
                //取消
                [cancelView dismissAnimation];
                break;
                
            default:
                break;
        }
    };
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.productInfoModel.productPictureList.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* reusableView;
    if( [kind isEqualToString:CHTCollectionElementKindSectionHeader] )
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ProductHeaderIdentifier forIndexPath:indexPath];
        
        ProductHeader* headerView = (ProductHeader *)reusableView;
        [headerView reloadProductHeaderWithModel:self.productInfoModel productHeaderState:ProductInfoDetailHeaderType];
        headerView.TapBrandLogoBlock = ^{
            
            [self tapProductBrandLogoWithBrandId];
        };
    }
    else if( [kind isEqualToString:CHTCollectionElementKindSectionFooter] )
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ProductFooterIdentifier forIndexPath:indexPath];
        
        ShareViewFooter* footerView = (ShareViewFooter *)reusableView;
        footerView.ClickGoodOrShareButton = ^(UIButton *button){
            
            [self tapFootGoodOrShareButtonClick:button];
        };
    }
    
    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailPictureCell* cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:ProductDetailPictureCellIdentifier forIndexPath:indexPath];
    
    MmiaProductPictureListModel* model = [self.productInfoModel.productPictureList objectAtIndex:indexPath.row];
    [cell reloadCellWithModel:model];
    
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MmiaProductPictureListModel *model = [self.productInfoModel.productPictureList objectAtIndex:indexPath.row];
    
    CGFloat rate;
    if (model.width != 0)
    {
        rate = (self.collectionView.width - KProductDetailPicture_LeftMargin * 2)/model.width;
    }
    CGFloat textH = [GlobalFunction getTextSizeWithSystemFont:UIFontSystem(KProductDetailPicture_FontOfSize) ConstrainedToSize:CGSizeMake(self.collectionView.width - KProductDetailPicture_LeftMargin * 2, MAXFLOAT) string:model.describe].height;
    
    CGSize size = CGSizeMake( self.collectionView.width, model.height * rate + textH + KProductDetailPicture_LeftMargin);
    
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    if( !self.productInfoModel )
        return 0;
    
    CGFloat headerH = KProductDetailPicture_LeftMargin;
    if (self.productInfoModel.logo.length > 0)
    {
        headerH = (KProductHeader_LogoImageHeight + KProductDetailPicture_LeftMargin);
    }
    
    if( self.productInfoModel.title.length > 0 )
    {
        CGFloat titleH = [GlobalFunction getTextSizeWithSystemFont:UIFontSystem(KProductHeaderTitle_FontOfSize) ConstrainedToSize:CGSizeMake(self.collectionView.width - KProductDetailPicture_LeftMargin * 2, MAXFLOAT) string:self.productInfoModel.title].height;
        
        headerH += (KProductDetailPicture_LeftMargin + titleH);
    }
    if( self.productInfoModel.describe.length > 0 )
    {
        CGFloat describeH = [GlobalFunction getTextSizeWithSystemFont:UIFontSystem(KProductHeaderDescrib_FontOfSize) ConstrainedToSize:CGSizeMake(self.collectionView.width - KProductDetailPicture_LeftMargin * 2, MAXFLOAT) string:self.productInfoModel.describe].height;
        
        headerH += (KProductHeader_TextMargin + describeH);
    }
    
    return headerH;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section
{
    if( !self.productInfoModel )
        return 0;
    
    UIImage *goodImage = [UIImage imageNamed:@"点赞.png"];
    
    return goodImage.size.height + 20;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
