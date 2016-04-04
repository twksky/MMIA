//
//  MMIASeparatorLineCell.m
//  MMIA
//
//  Created by Vivian's Office MAC on 14-5-15.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import "MMIASeparatorLineCell.h"

@implementation MMIASeparatorLineCell
{
    UIView *_separtorLineViewUp;
    UIView *_separtorLineViewdown;
}
- (void)setSepartorLineColor:(UIColor *)separtorLineColor
{
    if (_separtorLineColor) {
        _separtorLineColor=nil;
    }
    _separtorLineColor = separtorLineColor;
    _separtorLineViewdown.backgroundColor = _separtorLineColor;
    _separtorLineViewUp.backgroundColor = _separtorLineColor;

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _separtorLineViewUp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        _separtorLineViewUp.backgroundColor = BACK_GROUND_COLOR;
        _separtorLineViewUp.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_separtorLineViewUp];
        _separtorLineViewdown = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
        _separtorLineViewdown.backgroundColor = BACK_GROUND_COLOR;
        _separtorLineViewdown.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_separtorLineViewdown];
        _separtorLineViewUp.hidden = YES;
        _separtorLineViewdown.hidden = NO;
    }
    return self;
}
- (void)cellNumberOfSection:(NSInteger)number andCellIndexPath:(NSIndexPath *)indexpath
{
    if ((number-1) == indexpath.row) {
        //唯一一行
        if (indexpath.row == 0) {
            _separtorLineViewdown.hidden = NO;

        }else{
            //最后一行
            _separtorLineViewUp.hidden = NO;
        }
    }else {
        if (indexpath.row!=0) {
            //中间cell
            _separtorLineViewdown.hidden = NO;
            _separtorLineViewUp.hidden = NO;
        }else{
            //第一行
            _separtorLineViewdown.hidden = NO;
        }
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
