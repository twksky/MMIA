//
//  MmiaCollectionViewSmallLayout.m
//  MMIA
//
//  Created by MMIA-Mac on 15-5-14.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaCollectionViewSmallLayout.h"

@implementation MmiaCollectionViewSmallLayout

- (id)init
{
    if( self = [super init] )
    {
        self.itemSize = CGSizeMake(143, 254);
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.minimumInteritemSpacing = 10.0f;
        self.minimumLineSpacing = 2.0f;
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    return self;
}

- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context
{
    [super invalidateLayoutWithContext:context];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

@end
