//
//  MmiaEmailPrompt.h
//  MmiaHD
//
//  Created by twksky on 15/3/24.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MmiaEmailPrompt;

@protocol MmiaEmailPromptDelegate <NSObject>

-(void)sendSelectCellStr:(NSString *)str;

@end

@interface MmiaEmailPrompt : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,assign) id<MmiaEmailPromptDelegate> emailDelegate;




-(void)reinitDataArray:(NSString *)str;

@end
