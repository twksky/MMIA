//
//  MMiaPersonHomeView.h
//  MMIA
//
//  Created by lixiao on 15/1/29.
//  Copyright (c) 2015年 com.zixun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginInfoItem.h"

@protocol MMiaPersonHomeViewDelegate <NSObject>

-(void)tapConcernViewClick;
-(void)tapFunsViewClick;

@optional

-(void)addConcernPerson:(UIButton *)button;
-(void)tapInsertSetViewControllerClick;

@end

@interface MMiaPersonHomeView : UIView<MMiaPersonHomeViewDelegate>

@property (nonatomic, retain) UIButton    *addConcernButton;
@property (nonatomic, retain) UILabel     *nikeNameLabel;
@property (nonatomic, assign) id<MMiaPersonHomeViewDelegate>delegate;

-(void)resetSubViewsWithDictionary:(LoginInfoItem *)loginItem;

@end
