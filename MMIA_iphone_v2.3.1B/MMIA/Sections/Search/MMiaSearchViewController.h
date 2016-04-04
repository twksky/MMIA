//
//  MMiaSearchViewController.h
//  MMIA
//
//  Created by lixiao on 15/1/9.
//  Copyright (c) 2015年 com.zixun. All rights reserved.
//

#import "MMiaBaseViewController.h"

@class MMiaSearchViewController;

@protocol MMiaSearchViewControllerDelegate <NSObject>

-(void)clickSearchKeyWord:(NSString *)keyWord;

@end


@interface MMiaSearchViewController : MMiaBaseViewController
@property (nonatomic,assign) id<MMiaSearchViewControllerDelegate>delegate;

-(id)initWithUserid:(int)userId keyword:(NSString *)keyword;

@end
