//
//  MmiaLoadingCollectionCell.h
//  MMIA
//
//  Created by lixiao on 15/5/26.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MmiaLoadingCollectionCell : UIView//UICollectionViewCell

- (void)startAnimation;
- (void)stopAnimation;
- (void)addReloadButtonWithTarget:(id)target selector:(SEL)selector;
- (void)hiddenReloadButton:(BOOL)hidden;

@end
