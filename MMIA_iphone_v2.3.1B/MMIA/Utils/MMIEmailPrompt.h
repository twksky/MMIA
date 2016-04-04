//
//  MMIEmailPrompt.h
//  MMIA
//
//  Created by Free on 14-6-14.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMIEmailPrompt;

@protocol MMIEmailPromptDelegate <NSObject>

-(void)sendSelectCellStr:(NSString *)str;

@end

@interface MMIEmailPrompt : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,assign) id<MMIEmailPromptDelegate> emailDelegate;




-(void)reinitDataArray:(NSString *)str;

@end
