//
//  MMIASeparatorLineCell.h
//  MMIA
//
//  Created by Vivian's Office MAC on 14-5-15.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMIASeparatorLineCell : UITableViewCell

@property (nonatomic,retain) UIColor *separtorLineColor;

- (void)cellNumberOfSection:(NSInteger)number andCellIndexPath:(NSIndexPath *)indexpath;
@end
