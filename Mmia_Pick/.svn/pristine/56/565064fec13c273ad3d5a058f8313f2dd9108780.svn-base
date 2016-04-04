//
//  MmiaCollectionViewLargeLayout.m
//  MMIA
//
//  Created by MMIA-Mac on 15-5-14.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaCollectionViewLargeLayout.h"

@implementation MmiaCollectionViewLargeLayout

- (id)init
{
    if( self = [super init] )
    {
        self.itemSize = CGSizeMake(280, 500);
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.minimumInteritemSpacing = 5.0f;
        self.minimumLineSpacing = 5.0f;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [self layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        if (layoutAttributes.representedElementCategory != UICollectionElementCategoryCell)
            continue; // skip headers
        
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
            
            layoutAttributes.alpha = 0;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
