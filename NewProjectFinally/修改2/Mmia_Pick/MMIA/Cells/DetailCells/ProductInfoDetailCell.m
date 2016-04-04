//
//  ProductInfoDetailCell.m
//  MMIA
//
//  Created by MMIA-Mac on 15-6-10.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "ProductInfoDetailCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "ProductHeader.h"
#import "ShareViewFooter.h"
#import "ProductDetailPictureCell.h"


@interface ProductInfoDetailCell () <UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout>

@property (strong, nonatomic) UICollectionView* collectionView;

@end

@implementation ProductInfoDetailCell

- (UICollectionView *)collectionView
{
    if( !_collectionView )
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(KProductDetailPicture_LeftMargin, KProductDetailPicture_LeftMargin, KProductDetailPicture_LeftMargin, KProductDetailPicture_LeftMargin);
        layout.minimumColumnSpacing = 0;
        layout.minimumInteritemSpacing = KProductDetailPicture_LeftMargin;
        layout.columnCount = 1;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, VIEW_OFFSET + kNavigationBarHeight, self.width, self.height - VIEW_OFFSET - kNavigationBarHeight) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        // Header
        [_collectionView registerNib:UINibWithName(@"ProductHeader") forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:ProductHeaderIdentifier];
        // Cell
        [_collectionView registerNib:UINibWithName(@"ProductDetailPictureCell") forCellWithReuseIdentifier:ProductDetailPictureCellIdentifier ];
        // Footer
        [_collectionView registerClass:[ShareViewFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:ProductFooterIdentifier];
    }
    return _collectionView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self.contentView addSubview:self.collectionView];
    }
    return self;
}

- (void)setProductInfoModel:(MmiaPaperProductListModel *)productInfoModel
{
    if( ![_productInfoModel isEqual:productInfoModel] )
    {
        _productInfoModel = productInfoModel;
        
        [self.collectionView reloadData];
    }
}

#pragma mark -UICollectionViewDataSource

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
            
            if( self.TapProductBrandLogoBlock )
            {
                self.TapProductBrandLogoBlock(self.productInfoModel.brandId);
            }
        };
    }
    else if( [kind isEqualToString:CHTCollectionElementKindSectionFooter] )
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ProductFooterIdentifier forIndexPath:indexPath];
       
        ShareViewFooter* footerView = (ShareViewFooter *)reusableView;
        footerView.ClickGoodOrShareButton = ^(UIButton *button){
            if (self.TapFootGoodOrShareBtnBlock)
            {
                self.TapFootGoodOrShareBtnBlock(button);
            }
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
    
    CGFloat rate = 0;
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
    
    CGFloat headerH = 0;
    if (self.productInfoModel.logo.length > 0)
    {
        headerH = (KProductDetailPicture_LeftMargin + KProductHeader_LogoImageHeight);
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

@end
