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


@interface BrandIntroduceDetailCell () <UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout>

@property (strong, nonatomic) UICollectionView* collectionView;

@end

@implementation BrandIntroduceDetailCell

- (UICollectionView *)collectionView
{
    if( !_collectionView )
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumColumnSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.columnCount = 1;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, VIEW_OFFSET + kNavigationBarHeight, self.width, self.height - VIEW_OFFSET - kNavigationBarHeight) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        [_collectionView registerClass:[BrandHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:BrandHeaderIdentifier];
        [_collectionView registerClass:[ProductDetailPictureCell class]
            forCellWithReuseIdentifier:ProductDetailPictureCellIdentifier];
        [_collectionView registerClass:[BrandFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:BrandFooterIdentifier];
        
        _collectionView.backgroundColor = [UIColor redColor];
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
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* reusableView;
    if( [kind isEqualToString:CHTCollectionElementKindSectionHeader] )
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BrandHeaderIdentifier forIndexPath:indexPath];
        // TODO:header赋值
        BrandHeader* headerView = (BrandHeader *)reusableView;
        
    }
    else if( [kind isEqualToString:CHTCollectionElementKindSectionFooter] )
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:BrandFooterIdentifier forIndexPath:indexPath];
        // TODO:footer赋值
        BrandFooter* footerView = (BrandFooter *)reusableView;
    }
    
    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailPictureCell* cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:ProductDetailPictureCellIdentifier forIndexPath:indexPath];

    return cell;
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake( 0, 0 );
    
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
