//
//  MmiaMainViewLayout.m
//  MMIA
//
//  Created by MMIA-Mac on 15-6-30.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaMainViewLayout.h"

@implementation MmiaMainViewLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attrs = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes* attributes in attrs)
    {
        if (attributes.frame.size.width == (self.collectionView.bounds.size.width-2)/2
            && attributes.frame.origin.x != 0
            && CGRectGetMaxX(attributes.frame) != self.collectionView.bounds.size.width)
        {
            CGRect frame = attributes.frame;
            frame.origin.x = 0;
            attributes.frame = frame;
        }
    }
    return attrs;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath];
    //    if (indexPath.row == 0 || indexPath.row == 5)
    //        attr.size = CGSizeMake(320, 100);
    //    else
    //        attr.size = CGSizeMake(160, 100);
    return attr;
}

- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    return attr;
}

@end
