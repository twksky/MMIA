//
//  MMiaConcernPersonViewController.h
//  MMIA
//
//  Created by lixiao on 14-9-18.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMiaConcernPersonViewController;
@protocol MMiaConcernPersonViewControllerDelegate <NSObject>

- (void)didSelectItemAtConcernPerson:(MMiaConcernPersonViewController *)concernPerson indexPath:(NSIndexPath *)indexPath;

@end
@interface MMiaConcernPersonViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,assign)id <MMiaConcernPersonViewControllerDelegate>delegate;
@property(nonatomic,assign)NSInteger userId;
-(void)doReturnBlock:(int)follow indexPath:(NSIndexPath *)indexPath;
@end
