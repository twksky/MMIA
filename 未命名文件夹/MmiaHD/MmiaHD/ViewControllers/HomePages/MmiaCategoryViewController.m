//
//  MmiaCategoryViewController.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-3-10.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaCategoryViewController.h"
#import "AdditionHeader.h"
#import "GlobalHeader.h"
#import "MmiaMinorCategoryViewController.h"
#import "MagazineItem.h"


@interface MmiaCategoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation MmiaCategoryViewController

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
    self.view.backgroundColor = ColorWithHexRGBA(0xf0f0f0, 0.2);
    self.title = @"全部分类";
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
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
    MagazineItem* categoryItem = self.dataArray[indexPath.row];
    cell.textLabel.text = categoryItem.titleText;
    cell.textLabel.font = kTableViewCellFont;
    
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectedBackgroundView = [GlobalFunction selectedViewForTableViewCell:cell];

    return cell;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Category_TableView_Cell_Hight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MmiaMinorCategoryViewController* minorCategoryVC = [[MmiaMinorCategoryViewController alloc] init];
    MagazineItem* categoryItem = self.dataArray[indexPath.row];
    minorCategoryVC.dataArray = categoryItem.subMagezineArray;
    
    [self.navigationController pushViewController:minorCategoryVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
