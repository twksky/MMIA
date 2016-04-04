//
//  BrandIntroduceDetailCell.m
//  MMIA
//
//  Created by MMIA-Mac on 15-6-10.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "BrandIntroduceDetailCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "BrandHeader.h"
#import "BrandFooter.h"
#import "ProductDetailPictureCell.h"
#import "GlobalFunction.h"


@interface BrandIntroduceDetailCell () <UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout>

@property (strong, nonatomic) UICollectionView* collectionView;

@end

@implementation BrandIntroduceDetailCell

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
        [_collectionView registerNib:UINibWithName(@"BrandHeader") forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:BrandHeaderIdentifier];
        // Cell
        [_collectionView registerNib:UINibWithName(@"ProductDetailPictureCell") forCellWithReuseIdentifier:ProductDetailPictureCellIdentifier ];
        // Footer
        [_collectionView registerClass:[BrandFooter class] forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter withReuseIdentifier:BrandFooterIdentifier];
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

- (void)setBrandIntroduceModel:(MmiaPaperProductListModel *)brandIntroduceModel
{
    if( ![_brandIntroduceModel isEqual:brandIntroduceModel] )
    {
        _brandIntroduceModel = brandIntroduceModel;
        
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
    return self.brandIntroduceModel.brandPictureList.count;
  
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* reusableView;
    if( [kind isEqualToString:CHTCollectionElementKindSectionHeader] )
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BrandHeaderIdentifier forIndexPath:indexPath];
        
        BrandHeader* headerView = (BrandHeader *)reusableView;
        [headerView reloadBrandHeaderWithModel:self.brandIntroduceModel];
        headerView.TapWebsiteBlock = ^{
            
            if( self.TapBrandWebsiteBlock )
            {
                self.TapBrandWebsiteBlock(self.brandIntroduceModel.officalWebsite);
            }
        };
    }
    else if( [kind isEqualToString:CHTCollectionElementKindSectionFooter] )
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BrandFooterIdentifier forIndexPath:indexPath];
        
        BrandFooter* footerView = (BrandFooter *)reusableView;
        [footerView reloadBrandFooterWithModel:self.brandIntroduceModel];
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
    
    MmiaProductPictureListModel *model = [self.brandIntroduceModel.brandPictureList objectAtIndex:indexPath.row];
    [cell reloadCellWithModel:model];
    
    return cell;
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MmiaProductPictureListModel *model = [self.brandIntroduceModel.brandPictureList objectAtIndex:indexPath.row];
    
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
    if( !self.brandIntroduceModel )
        return 0;
    
    CGFloat headerH = KProductDetailPicture_LeftMargin + KProductHeader_TextLineHeight + KProductlHeader_TopMarginHeight;
    if( self.brandIntroduceModel.describe.length > 0 )
    {
        CGFloat describeH = [GlobalFunction getTextSizeWithSystemFont:UIFontSystem(KProductHeaderDescrib_FontOfSize) ConstrainedToSize:CGSizeMake(self.collectionView.width - KProductDetailPicture_LeftMargin * 2, MAXFLOAT) string:self.brandIntroduceModel.describe].height;
        
        headerH += describeH;
    }
    
    if( self.brandIntroduceModel.officalWebsite.length > 0 )
    {
        CGFloat websiteLabelH = [GlobalFunction getTextSizeWithSystemFont:UIFontSystem(KProductHeaderDescrib_FontOfSize) ConstrainedToSize:CGSizeMake(self.collectionView.width - KProductDetailPicture_LeftMargin * 2, MAXFLOAT) string:@"官方网站"].height + 8    ;
        
        CGFloat webH = [GlobalFunction getTextSizeWithSystemFont:UIFontSystem(KProductHeaderTitle_FontOfSize) ConstrainedToSize:CGSizeMake(self.collectionView.width - KProductDetailPicture_LeftMargin * 2, MAXFLOAT) string:self.brandIntroduceModel.officalWebsite].height;
    
        headerH += (websiteLabelH + webH + KProductDetailPicture_LeftMargin * 2 + KProductHeader_TextLineHeight + 7);
    }
    
    if( self.brandIntroduceModel.title.length > 0 )
    {
        CGFloat titleH = [GlobalFunction getTextSizeWithSystemFont:UIFontBoldSystem(KProductHeaderName_FontOfSize) ConstrainedToSize:CGSizeMake(self.collectionView.width - KProductDetailPicture_LeftMargin * 2, MAXFLOAT) string:self.brandIntroduceModel.title].height;
       
        headerH += (KProductDetailPicture_LeftMargin + titleH + KProductHeader_TextLineHeight);
    }

    return headerH;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section
{
    if( !self.brandIntroduceModel )
        return 0;
    
    CGFloat footerH = KProductHeader_TextLineHeight;
    
    if( self.brandIntroduceModel.address.count > 0 )
    {
        CGFloat addressNameH = [GlobalFunction getTextSizeWithSystemFont:UIFontSystem(KProductHeaderDescrib_FontOfSize) ConstrainedToSize:CGSizeMake(self.collectionView.width - KProductDetailPicture_LeftMargin * 2, MAXFLOAT) string:@"门店地址"].height;
        
        CGFloat phoneLabelH = [GlobalFunction getTextSizeWithSystemFont:UIFontSystem(KProductHeaderDescrib_FontOfSize) ConstrainedToSize:CGSizeMake(self.collectionView.width - KProductDetailPicture_LeftMargin * 2, MAXFLOAT) string:@"联系方式"].height;
        
        footerH += (addressNameH + phoneLabelH + KProductDetailPicture_LeftMargin * 3 + KProductHeader_TextLineHeight);
        
        for( MmiaBrandAddressModel* model in self.brandIntroduceModel.address )
        {
            CGFloat nHeight = [GlobalFunction getTextSizeWithSystemFont:UIFontSystem(KProductHeaderTitle_FontOfSize) ConstrainedToSize:CGSizeMake(self.collectionView.width - KProductDetailPicture_LeftMargin * 2, MAXFLOAT) string:model.name].height;
            
            CGFloat pHeight = [GlobalFunction getTextSizeWithSystemFont:UIFontSystem(KProductHeaderTitle_FontOfSize) ConstrainedToSize:CGSizeMake(self.collectionView.width - KProductDetailPicture_LeftMargin * 2, MAXFLOAT) string:model.phone].height;
            
            footerH += (KProductHeader_TextMargin * 2 + nHeight + pHeight);
        }
    }
    // lx add 增加分享view
    UIImage *goodImage = [UIImage imageNamed:@"点赞.png"];
    footerH += (goodImage.size.height + 20);

    return footerH;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
