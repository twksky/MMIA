//
//  MMIAGroupTableViewCell.h
//  MMIA
//
//  Created by Vivian's Office MAC on 14-6-1.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CORNERS  10

#define LINE_WIDTH 4.0f
#define CORNER_LINE_WIDTH 2.0f
#define CONTENTVIEW_LINE_COLOR            [UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1]


@interface MMIAGroupTableViewCellContentView : UIView
@property (nonatomic,assign)BOOL addCorner;
@property (nonatomic,assign)CGSize cornerSize;
@property (nonatomic,assign)UIRectCorner rectCorner;
@property (nonatomic,strong)UIColor *strokeColor;
@property (nonatomic,strong)UIColor *fileColor;

@end

@interface MMIAGroupTableViewCell : UITableViewCell
@property (nonatomic,strong) MMIAGroupTableViewCellContentView *MGTVCContentView;
@property (nonatomic,strong) UIImageView *MGTVCImageView;
@property (nonatomic,strong) UILabel *MGTVCTitleLabel;
@property (nonatomic,strong) UILabel *MGTVCDetialLabel;
@property (nonatomic,strong) UIImageView *MGTVCAccessoryView;
@property (nonatomic,assign) BOOL setGroup;

- (void)resetSubViewWithSize:(CGSize)size withCellIndexPath:(NSIndexPath *)indePath cellNumber:(NSInteger)cellNumber;
@end
