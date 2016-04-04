//
//  CollectionViewWaterfallHeader.h
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionViewWaterfallHeader;
@protocol CollectionViewWaterfallHeaderDelegate <NSObject>

- (void)CollectionViewWaterfallHeaderTap:(CollectionViewWaterfallHeader*)header;

@end

@interface CollectionViewWaterfallHeader : UICollectionReusableView

@property (nonatomic, strong) NSIndexPath* indexPath;
@property (nonatomic, assign) CGFloat      originX;
@property (nonatomic, weak  ) id <CollectionViewWaterfallHeaderDelegate> delegate;

- (void)fillWithContent:(NSString *)contentLabel indexPath:(NSIndexPath*)indexPath originX:(CGFloat)originX;

@end
