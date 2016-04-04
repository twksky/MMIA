//
//  BrandEntryDetailCell.m
//  MMIA
//
//  Created by MMIA-Mac on 15-6-10.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "BrandEntryDetailCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "ProductHeader.h"
#import "BrandEntrySingleCell.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "MmiaBrandViewController.h"


const CGFloat KCellImageViewHeight = 200.0f;

@interface BrandEntryDetailCell () <UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout>

@property (strong, nonatomic) UICollectionView* collectionView;

@end

@implementation BrandEntryDetailCell

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
        [_collectionView registerNib:UINibWithName(@"BrandEntrySingleCell") forCellWithReuseIdentifier:BrandEntrySingleCellIdentifier ];
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

- (void)setBrandEntryModel:(MmiaPaperProductListModel *)brandEntryModel
{
    if( ![_brandEntryModel isEqual:brandEntryModel] )
    {
        _brandEntryModel = brandEntryModel;
        
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
    if( self.brandEntryModel )
    {
        return 1;
    }
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* reusableView;
    if( [kind isEqualToString:CHTCollectionElementKindSectionHeader] )
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:ProductHeaderIdentifier forIndexPath:indexPath];
        
        ProductHeader* headerView = (ProductHeader *)reusableView;
        [headerView reloadProductHeaderWithModel:self.brandEntryModel productHeaderState:BrandEntryDetailHeaderType];
        headerView.TapBrandLogoBlock = ^{
            
            if( self.TapProductBrandLogoBlock )
            {
                self.TapProductBrandLogoBlock((self.brandEntryModel.brandId));
            }
        };
    }
    
    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BrandEntrySingleCell* cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:BrandEntrySingleCellIdentifier forIndexPath:indexPath];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = ColorWithHexRGB(0xcccccc).CGColor;
    
    [cell reloadSingleCellWithModel:self.brandEntryModel];
    
    return cell;
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = KCellImageViewHeight + KProductDetailPicture_LeftMargin;
    if( self.brandEntryModel.title.length > 0 )
    {
        CGFloat titleH = [GlobalFunction getTextSizeWithSystemFont:UIFontSystem(KProductHeaderName_FontOfSize) ConstrainedToSize:CGSizeMake(self.collectionView.width - KProductDetailPicture_LeftMargin * 4, MAXFLOAT) string:self.brandEntryModel.title].height;
        
        height += (KProductDetailPicture_LeftMargin + titleH);
    }
    if( self.brandEntryModel.describe.length > 0 )
    {
        CGFloat describeH = [GlobalFunction getTextSizeWithSystemFont:UIFontSystem(KProductHeaderDescrib_FontOfSize) ConstrainedToSize:CGSizeMake(self.collectionView.width - KProductDetailPicture_LeftMargin * 4, MAXFLOAT) string:self.brandEntryModel.describe].height;
        
        height += (KProductDetailPicture_LeftMargin + describeH);
    }

    CGSize size = CGSizeMake( self.collectionView.width, height);
    
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    if( !self.brandEntryModel )
        return 0;
    
    CGFloat headerH = 0;
    if (self.brandEntryModel.logo.length > 0)
    {
        headerH += (KProductHeader_LogoImageHeight +KProductDetailPicture_LeftMargin);
    }
    
    if( self.brandEntryModel.name.length > 0 )
    {
        CGFloat titleH = [GlobalFunction getTextSizeWithSystemFont:UIFontSystem(KProductHeaderTitle_FontOfSize) ConstrainedToSize:CGSizeMake(self.collectionView.width - KProductDetailPicture_LeftMargin * 2, MAXFLOAT) string:self.brandEntryModel.name].height;
        
        headerH += (KProductDetailPicture_LeftMargin + titleH);
    }
    if( self.brandEntryModel.slogan.length > 0 )
    {
        CGFloat describeH = [GlobalFunction getTextSizeWithSystemFont:UIFontSystem(KProductHeaderDescrib_FontOfSize) ConstrainedToSize:CGSizeMake(self.collectionView.width - KProductDetailPicture_LeftMargin * 2, MAXFLOAT) string:self.brandEntryModel.slogan].height;
        
        headerH += (KProductHeader_TextMargin + describeH);
    }
    return headerH;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if( self.TapProductBrandLogoBlock )
    {
        self.TapProductBrandLogoBlock(self.brandEntryModel.brandId);
    }
}

@end
