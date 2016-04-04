//
//  MMiaSetDataViewCell.h
//  MMIA
//
//  Created by lixiao on 14-6-19.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//
//公司资料设置cell

#import <UIKit/UIKit.h>
#define CORNERS  10

#define LINE_WIDTH 4.0f
#define CORNER_LINE_WIDTH 2.0f
#define CONTENTVIEW_LINE_COLOR            [UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1]


@interface MMIASetDataCellContentView : UIView
@property (nonatomic,assign)BOOL addCorner;
@property (nonatomic,assign)CGSize cornerSize;
@property (nonatomic,assign)UIRectCorner rectCorner;
@property (nonatomic,strong)UIColor *strokeColor;
@property (nonatomic,strong)UIColor *fileColor;

@end

@interface MMiaSetDataViewCell : UITableViewCell

@property(nonatomic,retain)UILabel *typeLabel;
@property(nonatomic,retain)UILabel *contentLabel;
@property(nonatomic,retain)UIImageView *accessoryImageView;
@property(nonatomic,retain)MMIASetDataCellContentView *lineContentView;

- (void)resetSubViewWithSize:(CGSize)size withCellIndexPath:(NSIndexPath *)indePath cellNumber:(NSInteger)cellNumber
;

@end
