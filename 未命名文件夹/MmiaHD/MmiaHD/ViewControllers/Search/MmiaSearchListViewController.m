//
//  MmiaSearchListViewController.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-3-11.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaSearchListViewController.h"
#import "AdditionHeader.h"
#import "GlobalHeader.h"
#import "UIViewController+StackViewController.h"
#import "MagazineItem.h"


@implementation SearchTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if( self )
    {
        self.delegate = self;
        self.dataSource = self;
        
        _searchArray = [NSMutableArray array];
    }
    return self;
}

- (void)setSearchArray:(NSMutableArray *)searchArray
{
    if( _searchArray != searchArray )
    {
        _searchArray = searchArray;
        
        [self reloadData];
    }
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
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
    cell.textLabel.font = kTableViewCellFont;
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [GlobalFunction selectedViewForTableViewCell:cell];

//    MagazineItem* searchItem = self.searchArray[indexPath.row];
    cell.textLabel.text = self.searchArray[indexPath.row];//searchItem.titleText;
    
    return cell;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Category_TableView_Cell_Hight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* dict = @{SEARCH_SELITEM_KEY:self.searchArray[indexPath.row]};
    
    [DefaultNotificationCenter postNotificationName:PopoverController_Notification_Key object:nil userInfo:dict];
}

@end


@interface MmiaSearchListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView*     tableView;
@property (nonatomic, strong) SearchTableView* searchTableView;
@property (nonatomic, strong) UIButton*        deleteButton;

- (void)createNotifications;
- (void)destroyNotifications;

@end

@implementation MmiaSearchListViewController

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

- (SearchTableView *)searchTableView
{
    if( !_searchTableView )
    {
        _searchTableView = [[SearchTableView alloc] initWithFrame:self.tableView.frame style:UITableViewStylePlain];
        _searchTableView.backgroundColor = UIColorClear;
    }
    return _searchTableView;
}

- (UIButton *)deleteButton
{
    if( !_deleteButton )
    {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(self.tableView.width - 50, 0, 50, Category_TableView_Header_Hight);
        [_deleteButton setTitle:@"清除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _deleteButton.titleLabel.font = kTableViewCellFont;
        [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
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
    
    if( iOS7Later )
    {
        self.preferredContentSize = KPopoverContentSize;
    }
    else
    {
        self.contentSizeForViewInPopover = KPopoverContentSize;
    }
    
    [self createNotifications];
}

- (void)setPreferredContentSizeForView:(CGSize)preferredContentSizeForView
{
    _preferredContentSizeForView = preferredContentSizeForView;
    
    self.tableView.width = _preferredContentSizeForView.width;
    self.tableView.height = _preferredContentSizeForView.height;
}

- (void)deleteButtonClick:(UIButton *)sender
{
    NSString* filePath = [[UtilityFunction documentsPath] stringByAppendingPathComponent:Mmia_FILE_KEY];
    filePath = [filePath stringByAppendingPathComponent:SEARCH_HISTORY_KEY];
    
    NSFileManager* fileManager = DefaultFileManager;
    if( [fileManager fileExistsAtPath:filePath] )
    {
        NSError *err;
        [fileManager removeItemAtPath:filePath error:&err];
    }
    
    [self.historyArray removeAllObjects];
    self.historyArray = nil;
    
    [self.tableView reloadData];
}

#pragma mark *Notifications

- (void)createNotifications
{
    [DefaultNotificationCenter addObserver:self selector:@selector(searchTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [DefaultNotificationCenter addObserver:self selector:@selector(searchTextFieldChanged:) name:UITextFieldTextDidEndEditingNotification object:nil];
}

- (void)destroyNotifications
{
    [DefaultNotificationCenter removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
    [DefaultNotificationCenter removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)searchTextFieldChanged:(NSNotification *)notification
{
    UITextField* textField = (UITextField *)[notification object];
    if( textField.text.length <= 0 )
    {
        [self.searchTableView removeFromSuperview];
        self.tableView.hidden = NO;
    }
    else
    {
        self.tableView.hidden = YES;
        [self.view addSubview:self.searchTableView];
        // 测试数据
        NSMutableArray* array = [NSMutableArray arrayWithObjects:textField.text, nil];
        self.searchTableView.searchArray = array;
    }
}

#pragma mark - Public
#pragma mark * Overwritten setters

- (void)setHistoryArray:(NSMutableArray *)historyArray
{
    if( _historyArray != historyArray )
    {
        _historyArray = historyArray;
        
        [self.tableView reloadData];
    }
}

- (void)setHotArray:(NSMutableArray *)hotArray
{
    if( _hotArray != hotArray )
    {
        _hotArray = hotArray;
        
        [self.tableView reloadData];
    }
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if( self.historyArray )
        return 2;
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( section == 0 )
    {
        if( self.historyArray )
        {
            return self.historyArray.count;
        }
    }
    return self.hotArray.count;
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
    cell.textLabel.font = kTableViewCellFont;
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectedBackgroundView = [GlobalFunction selectedViewForTableViewCell:cell];
    
    if( indexPath.section == 0 )
    {
        if( self.historyArray )
        {
            cell.textLabel.text = self.historyArray[indexPath.row];
            return cell;
        }
    }
    if( self.hotArray.count > 0 )
    {
        MagazineItem* item = self.hotArray[indexPath.row];
        cell.textLabel.text = item.titleText;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, Category_TableView_Header_Hight)];
    view.backgroundColor = ColorWithHexRGB(0xf1f1f1);
    
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, view.top, view.width - 10, view.height)];
    headerLabel.font = kTableViewCellFont;
    [view addSubview:headerLabel];

    if( section == 0 )
    {
        if( self.historyArray )
        {
            headerLabel.text = @"最近搜索";
            [view addSubview:self.deleteButton];
            
            return view;
        }
    }
    headerLabel.text = @"热门推荐";
    
    return view;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Category_TableView_Cell_Hight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Category_TableView_Header_Hight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary* dict;
    if( self.hotArray.count > 0 )
    {
        dict = @{SEARCH_SELITEM_KEY:self.hotArray[indexPath.row]};
    }
    
    if( indexPath.section == 0 )
    {
        if( self.historyArray )
        {
            dict = @{SEARCH_SELITEM_KEY:self.historyArray[indexPath.row]};
        }
    }
    
    [DefaultNotificationCenter postNotificationName:PopoverController_Notification_Key object:nil userInfo:dict];
}

- (void)dealloc
{
    [self destroyNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
