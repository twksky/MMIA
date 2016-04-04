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
@property (nonatomic, retain) NSString* titleString;
@property (nonatomic, retain) UIImage* leftImage;
@property (nonatomic, retain) UIImage* rightImage;

- (void)initializeHeaderWithLeftImage:(UIImage*)leftImage rightImage:(UIImage*)rightImage titleString:(NSString*)titleString;

@end
