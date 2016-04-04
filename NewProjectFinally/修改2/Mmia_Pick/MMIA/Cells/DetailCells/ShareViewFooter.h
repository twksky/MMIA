//
//  ShareViewFooter.h
//  MMIA
//
//  Created by lixiao on 15/6/12.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewFooter : UICollectionReusableView

@property (copy, nonatomic) void (^ClickGoodOrShareButton)(UIButton *button);

@end
