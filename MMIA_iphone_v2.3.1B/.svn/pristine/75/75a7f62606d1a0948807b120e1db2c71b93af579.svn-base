//
//  MMiaPopListView.m
//  SplitTwoViewController
//
//  Created by MMIA-Mac on 15-1-14.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MMiaPopListView.h"
#import "MagezineItem.h"

#define POPLISTVIEW_SCREENINSET   15.
#define POPLISTVIEW_TOP_MARGIN    100
#define POPLISTVIEW_HEADER_HEIGHT 70.
#define POPLISTVIEW_HEIGHT        224.
#define RADIUS 5.

@interface MMiaPopListView () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
{
    NSString* _listTitle; // 显示标题
    NSArray*  _listArray; // 列表数据
}

@property (nonatomic, strong) UILabel*     titleView;
@property (nonatomic, strong) UIImageView* roundView;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView*      contentView;
@property (nonatomic, getter=isRound) BOOL round;

// ListView动画加载
- (void)fadeIn;
// ListView动画消失
- (void)fadeOut;

@end

@implementation MMiaPopListView

- (UILabel *)titleView
{
    if( !_titleView )
    {
        _titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), 40)];
        _titleView.backgroundColor = [UIColor blackColor];
        _titleView.font = [UIFont systemFontOfSize:17];
        _titleView.textColor = [UIColor whiteColor];
        _titleView.textAlignment = NSTextAlignmentCenter;
        
        if( self.round )
        {
            UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:_titleView.frame];
            bgImageView.backgroundColor = [UIColor clearColor];
            UIImage* image = [[UIImage imageNamed:@"popuppage_headbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 10, 10)];
            bgImageView.image = image;
//            [_titleView addSubview:bgImageView];
            [self.contentView insertSubview:bgImageView belowSubview:_titleView];
            _titleView.backgroundColor = [UIColor clearColor];
        }
    }
    return _titleView;
}

- (UITableView *)tableView
{
    if( !_tableView )
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleView.frame), CGRectGetMaxY(self.titleView.frame), CGRectGetWidth(self.titleView.bounds), POPLISTVIEW_HEIGHT - CGRectGetHeight(self.titleView.bounds))];
        _tableView.backgroundColor = [UIColor colorWithRed:0xef/255.0 green:0xee/255.0 blue:0xf2/255.0 alpha:1];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.alwaysBounceVertical = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (UIImageView *)roundView
{
    if( !_roundView )
    {
        UIImage* image = [[UIImage imageNamed:@"popuppage_footbar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
        _roundView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.tableView.frame), CGRectGetMaxY(self.tableView.frame), CGRectGetWidth(self.tableView.bounds), image.size.height)];
        _roundView.image = image;
    }
    return _roundView;
}

- (id)initWithTitle:(NSString *)title dataArray:(NSArray *)listArray isRound:(BOOL)round
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if( self = [super initWithFrame:rect] )
    {
        _listTitle = [title copy];
        _listArray = [listArray copy];
        _round = round;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];

        _contentView = [[UIView alloc] initWithFrame:CGRectMake(POPLISTVIEW_SCREENINSET, ( CGRectGetHeight(self.bounds) - POPLISTVIEW_HEIGHT )/2, CGRectGetWidth(self.bounds) - 2 * POPLISTVIEW_SCREENINSET, POPLISTVIEW_HEIGHT)];
        _contentView.tag = 1;
        _contentView.backgroundColor = [UIColor clearColor];
        
        [_contentView addSubview:self.titleView];
        [_contentView addSubview:self.tableView];
        
        if( self.round )
        {
            CGRect frame = _contentView.frame;
            frame.size.height += self.roundView.image.size.height;
            frame.origin.y -= (self.roundView.image.size.height / 2);
            _contentView.frame = frame;
            
            [_contentView addSubview:self.roundView];
        }
        
        [self addSubview:_contentView];
        
        self.titleView.text = _listTitle;
        
        // 添加点击ListView布局之外屏幕部分ListView消失的手势
        UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDismissTap:)];
        recognizer.delegate = self;
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)handleDismissTap:(UITapGestureRecognizer *)tap
{
    [self dismissWithAnimated:NO];
}

#pragma mark - Public Methods

- (void)showInSuperView:(UIView *)superView animated:(BOOL)animated
{
    [superView addSubview:self];
    
    if (animated)
    {
        [self fadeIn];
    }
}

- (void)dismissWithAnimated:(BOOL)animated
{
    if( animated )
    {
        [self fadeOut];
    }
    else
    {
        [self removeFromSuperview];
    }
}

#pragma mark - Private Methods

- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self removeFromSuperview];
        }
    }];
}

- (void)reateBtnClicked:(id)sender
{
    // TODO:
    if( [self.delegate respondsToSelector:@selector(popListView:didSelectedIndex:)] )
    {
        [self.delegate popListView:self didSelectedIndex: -1];
    }
    
    [self dismissWithAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if( (touch.view.tag == 1) || (touch.view.tag == 2) || [NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] )
    {
        return NO;
    }
    return YES;
}

#pragma mark - TableView datasource & delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return POPLISTVIEW_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), POPLISTVIEW_HEADER_HEIGHT)];
    view.backgroundColor = [UIColor colorWithRed:0xf9/255.0 green:0xf9/255.0 blue:0xfa/255.0 alpha:1];
    view.tag = 2;
    
    UIButton* createMagzineButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 15, CGRectGetWidth(view.bounds) - 2 * 30, POPLISTVIEW_HEADER_HEIGHT - 2 * 15)];
    createMagzineButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [createMagzineButton setTitle:@"新建专题" forState:UIControlStateNormal];
    [createMagzineButton setTitleColor:[UIColor colorWithRed:0xe1 / 255.0 green:0x4a / 255.0 blue:0x4a / 255.0 alpha:1] forState:UIControlStateNormal];
    createMagzineButton.layer.borderWidth = 1;
    createMagzineButton.layer.borderColor = createMagzineButton.titleLabel.textColor.CGColor;
    createMagzineButton.layer.cornerRadius = 4;
    
    UIImage* img = [UIImage imageNamed:@"recievespecialpopup_plusbutton.png"];
    UIImageView* imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake(CGRectGetWidth(createMagzineButton.bounds) / 2 - 55 , (CGRectGetHeight(createMagzineButton.bounds) - img.size.height) / 2, img.size.width, img.size.height);
    [createMagzineButton addSubview:imgView];
    
    [createMagzineButton addTarget:self action:@selector(reateBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:createMagzineButton];
    
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75/2;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"PopListViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if( !cell )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        
        UIImage* image = [UIImage imageNamed:@"recievespecialpage_specialicon.png"];
        cell.imageView.image = image;
        
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor colorWithRed:0x40/255.0 green:0x40/255.0 blue:0x40/255.0 alpha:1];
        
        UIView* perLine = [[UIView alloc] init];
        perLine.backgroundColor = [UIColor colorWithRed:0xe2/255.0 green:0xe2/255.0 blue:0xe2/255.0 alpha:1];
        perLine.frame = CGRectMake(0, 0, CGRectGetWidth(cell.bounds), 1);
        [cell.contentView addSubview:perLine];
    }

    MagezineItem* item = _listArray[indexPath.row];
    cell.textLabel.text = item.title;
    
    if( indexPath.row == _listArray.count - 1 )
    {
        UIView* nextLine = [[UIView alloc] init];
        nextLine.backgroundColor = [UIColor colorWithRed:0xe2/255.0 green:0xe2/255.0 blue:0xe2/255.0 alpha:1];
        nextLine.frame = CGRectMake(0, 75/2 - 1, CGRectGetWidth(cell.bounds), 1);
        nextLine.tag = 3;
        [cell.contentView addSubview:nextLine];
    }
    else
    {
        if( [cell.contentView viewWithTag:3] )
        {
            [[cell.contentView viewWithTag:3] removeFromSuperview];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if( [self.delegate respondsToSelector:@selector(popListView:didSelectedIndex:)] )
    {
        [self.delegate popListView:self didSelectedIndex:[indexPath row]];
    }
    
    [self dismissWithAnimated:YES];
}

@end
