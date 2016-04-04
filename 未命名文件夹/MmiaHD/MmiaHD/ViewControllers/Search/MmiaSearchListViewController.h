//
//  MmiaSearchListViewController.h
//  MmiaHD
//
//  Created by MMIA-Mac on 15-3-11.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray* searchArray;

@end


@interface MmiaSearchListViewController : UIViewController

@property (nonatomic, strong) NSMutableArray* historyArray;
@property (nonatomic, strong) NSMutableArray* hotArray;
@property (nonatomic, assign) CGSize preferredContentSizeForView;

@end
