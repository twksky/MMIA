//
//  MMiaConcernViewController.h
//  MMIA
//
//  Created by lixiao on 14-9-18.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import "MMiaBaseViewController.h"
#import "MMiaConcernPersonViewController.h"
#import "MMiaConcernMagezineViewController.h"

@interface MMiaConcernViewController : MMiaBaseViewController<MMiaConcernPersonViewControllerDelegate,MMiaConcernMagezineViewControllerDelegate>

@property (strong, nonatomic) NSArray* viewControllers;
@property (assign, nonatomic) NSUInteger selectedIndex;
@property (assign, nonatomic) NSUInteger topBarViewHeight;
@property (strong, nonatomic) UIFont*    topBarButtonFont;
@property (strong, nonatomic) UIColor*   buttonTitleColor;
@property (strong, nonatomic) UIColor*   selectedButtonTitleColor;
@property(nonatomic,assign)BOOL isOthers;

-(id)initWithUserId:(NSInteger)userId;
@end
