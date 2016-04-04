//
//  MmiaMinorCategoryViewController.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-3-10.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaMinorCategoryViewController.h"
#import "AdditionHeader.h"
#import "GlobalHeader.h"
#import "MagazineItem.h"


@interface MmiaMinorCategoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation MmiaMinorCategoryViewController

- (UITableView *)tableView
{
    if ( !_tableView )
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorClear;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - View life cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.frame = self.view.bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = ColorWithHexRGBA(0xf0f0f0, 0.7);
    self.title = @"二级分类";
    
    if( iOS7Later )
    {
        self.preferredContentSize = KPopoverContentSize;
    }
    else
    {
        self.contentSizeForViewInPopover = KPopoverContentSize;
    }
}

#pragma mark - Public
#pragma mark * Overwritten setters

- (void)setDataArray:(NSArray *)dataArray
{
    if( _dataArray != dataArray )
    {
        _dataArray = dataArray;
        
        [self.tableView reloadData];
    }
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MagazineItem* minorItem = self.dataArray[section];
    return minorItem.subMagezineArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = UIColorClear;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if( cell == nil )
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    MagazineItem* minorItem = self.dataArray[indexPath.section];
    MagazineItem* magazineItem = minorItem.subMagezineArray[indexPath.row];
    cell.textLabel.text = magazineItem.titleText;
    cell.textLabel.font = kTableViewCellFont;
    
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [GlobalFunction selectedViewForTableViewCell:cell];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, Category_TableView_Header_Hight)];
    view.backgroundColor = ColorWithHexRGB(0xf1f1f1);
    
    MagazineItem* minorItem = self.dataArray[section];
    
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, view.top, view.width - 10, view.height)];
    headerLabel.font = kTableViewCellFont;
    headerLabel.text = minorItem.titleText;
    [view addSubview:headerLabel];
    
    return view;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Category_TableView_Cell_Hight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    MagazineItem* minorItem = self.dataArray[section];
    if( minorItem.titleText.length <= 0 )
        return 0;
    
    return Category_TableView_Header_Hight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 进入列表页面
    MagazineItem* minorItem = self.dataArray[indexPath.section];
    MagazineItem* magazineItem = minorItem.subMagezineArray[indexPath.row];
    NSDictionary* dict = @{SEARCH_SELITEM_KEY:magazineItem};
    
    [DefaultNotificationCenter postNotificationName:PopoverController_Notification_Key object:nil userInfo:dict];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
