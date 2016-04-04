//
//  MMiaCollectionViewWaterfallHeader.h
//  MMIA
//
//  Created by MMIA-Mac on 14-7-4.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMiaCollectionViewWaterfallHeader;
@protocol MMiaCollectionViewWaterfallHeaderDelegate <NSObject>

- (void)MMiaCollectionViewWaterfallHeaderTap:(MMiaCollectionViewWaterfallHeader*)header;

@end

@interface MMiaCollectionViewWaterfallHeader : UICollectionReusableView

@property (nonatomic, weak) id <MMiaCollectionViewWaterfallHeaderDelegate> delegate;
@property (nonatomic, strong) NSIndexPath* indexPath;
@property (nonatomic, strong) id content; //content的类型可以自己指定

- (void)initializeHeaderWithLeftImage:(UIImage*)leftImage rightImage:(UIImage*)rightImage titleString:(NSString*)titleString;

- (void)fillContent:(id)content indexPath:(NSIndexPath*)indexPath;

@end
