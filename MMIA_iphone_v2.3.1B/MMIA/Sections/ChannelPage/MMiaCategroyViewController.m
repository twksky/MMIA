//
//  MMiaCategroyViewController.m
//  MMIA
//
//  Created by Jack on 14-10-23.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaCategroyViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MMiaCollectionViewWaterfallHeader.h"
#import "MMiaErrorTipView.h"
#import "MMiaMainViewWaterfallCell.h"
#import "MMiaMinorCategoryViewController.h"
#import "MMIToast.h"
#import "MMiaQueryViewController.h"
#import "MMiaSingleCategoryContainer.h"

#define CELL_IDENTIFIER   @"findWaterfallCell"
#define HEADER_IDENTIFIER @"findWaterfallHeader"

const NSInteger TableView_Cell_Width  = 70;
const NSInteger TableView_Cell_Height = 45;

static const CGFloat Search_Image_Margin = 10;

@interface MMiaCategroyViewController () <UITableViewDataSource, UITableViewDelegate,UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout,MMiaErrorTipViewDelegate>
{
    BOOL _isLoadding;
}

@property (strong, nonatomic) UICollectionView* collectionView;
@property (strong, nonatomic) NSMutableArray*   categroyArray;
@property (nonatomic, strong) NSIndexPath* currentIndexPath;

- (void)getCategroyDataForRequest;
- (void)netWorkError:(NSError *)error;

@end

@implementation MMiaCategroyViewController

- (UITableView *)tableView
{
    if( !_tableView )
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEW_OFFSET + kNavigationBarHeight, TableView_Cell_Width, self.view.bounds.size.height - kNavigationBarHeight - VIEW_OFFSET - 45)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UICollectionView *)collectionView
{
    if( !_collectionView )
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(0 , 0, 0, 0);
        layout.minimumColumnSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.headerHeight = 35;
        layout.columnCount = 3;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.tableView.bounds), VIEW_OFFSET + kNavigationBarHeight, CGRectGetWidth(self.view.bounds) - CGRectGetWidth(self.tableView.bounds), self.view.bounds.size.height - kNavigationBarHeight - VIEW_OFFSET - 45) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        _collectionView.clipsToBounds = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[MMiaMainViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[MMiaCollectionViewWaterfallHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0xef/255.0 green:0xef/255.0 blue:0xef/255.0 alpha:1.0];
    [self setNaviBarViewBackgroundColor: UIColorFromRGB(0x393b49)];
    [self searchNavigationBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
   
    _categroyArray = [NSMutableArray array];
    _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    _isLoadding = YES;
    [MMiaLoadingView showLoadingForView:self.view];
    [self getCategroyDataForRequest];
}


#pragma mark - Private

- (void)getCategroyDataForRequest
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.mmiaDataEngine startAsyncRequestWithUrl:MMia_CATEGROY_URL param:nil requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *dataDict)
     {
         if( [dataDict[@"result"] intValue] == 0 )
         {
             _isLoadding = NO;
             [MMiaLoadingView hideLoadingForView:self.view];
             
             NSArray* dataArray = dataDict[@"data"];
             for (NSDictionary* dict in dataArray  ) {
                 MagezineItem* categroyItem = [[MagezineItem alloc] init];
                 NSString *name = dict[@"name"];
                 name = [[name componentsSeparatedByString:@"/"] objectAtIndex:0];
                 categroyItem.logoWord = name;
                 NSArray* dataArray = dict[@"subCategroy"];
                 NSMutableArray* subCategoryArr = [[NSMutableArray alloc]init];
                 for (NSDictionary* dict in dataArray)
                 {
                     MagezineItem* categroyItem = [[MagezineItem alloc] init];
                     categroyItem.logoWord = dict[@"name"];
                     NSArray* dataItemArray = dict[@"subCategroy"];
                     NSMutableArray* subCategoryItemArr = [[NSMutableArray alloc]init];
                     for (NSDictionary* dict in dataItemArray)
                     {
                         MagezineItem* categroyItem = [[MagezineItem alloc] init];
                         categroyItem.aId = [dict[@"id"] intValue];
                         categroyItem.logoWord = dict[@"name"];
                         if( categroyItem.logoWord.length <= 0 )
                             continue;
                         categroyItem.pictureImageUrl = dict[@"imgUrl"];
                         categroyItem.magazineId = [dict[@"categoryId"] intValue];
                         [subCategoryItemArr addObject:categroyItem];
                     }
                     categroyItem.subMagezineItem = subCategoryItemArr;
                     [subCategoryArr addObject:categroyItem];
                 }
                 categroyItem.subMagezineItem = subCategoryArr;
                 [_categroyArray addObject:categroyItem];
             }
             [self.tableView reloadData];
             [self.tableView selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
             [self.collectionView reloadData];
         }
         else
         {
             [self netWorkError:nil];
         }
         
     }errorHandler:^(NSError *error){
         
         [self netWorkError:error];
     }];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:NO];
}

- (void)searchNavigationBar
{
    UIView* searchView = [[UIView alloc] initWithFrame:CGRectMake( 10,VIEW_OFFSET + 5, CGRectGetWidth(self.view.bounds) - 60, 32 )];
    searchView.backgroundColor = [UIColor whiteColor];
    searchView.layer.cornerRadius = 16;
    [self.navigationView addSubview:searchView];
    
    UIImage* _image = [UIImage imageNamed:@"searchpage_topsearchicon.png"];
    UIImageView* searchImage = [[UIImageView alloc] initWithFrame:CGRectMake( Search_Image_Margin, (CGRectGetHeight(searchView.bounds) - _image.size.height)/2, _image.size.width, _image.size.height )];
    searchImage.image = _image;
    [searchView addSubview:searchImage];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(searchImage.frame) + Search_Image_Margin, 0, CGRectGetWidth(searchView.bounds) - CGRectGetMaxX(searchImage.frame) - Search_Image_Margin, CGRectGetHeight(searchView.bounds) )];
    label.font = [UIFont boldSystemFontOfSize:13];
    label.textColor = [UIColor grayColor];
    label.text = @"搜索你喜欢的商品或商家";
    label.backgroundColor = [UIColor clearColor];
    [searchView addSubview:label];
    
    UILabel* searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 50, 0, 60, 32)];
    searchLabel.text = @"搜索";
    searchLabel.textColor = [UIColor whiteColor];
    searchLabel.font = [UIFont systemFontOfSize:15];
    searchLabel.userInteractionEnabled = YES;
    searchLabel.backgroundColor = [UIColor clearColor];
    [searchView addSubview:searchLabel];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSearchTap:)];
    [self.navigationView addGestureRecognizer:singleTap];
    
}



- (void)handleSearchTap:(UITapGestureRecognizer *)tap
{
    MMiaQueryViewController *queryVC=[[MMiaQueryViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromRight;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:queryVC animated:NO];
  
}


- (void)netWorkError:(NSError *)error
{
    if( _isLoadding )
    {
        _isLoadding = NO;
        [MMiaLoadingView hideLoadingForView:self.view];
    }
    CGFloat errTipY = (CGRectGetHeight(self.view.bounds) - 125)/2;
    CGFloat errTipX = CGRectGetWidth(self.view.bounds) / 2;
    [MMiaErrorTipView showErrorTipForView:self.view center:CGPointMake(errTipX, errTipY) error:error delegate:self];
}

#pragma mark -MMiaErrorTipViewDelegate

- (void)onErrorTipViewRefreshBtnClicked:(MMiaErrorTipView* )sender
{
    _isLoadding = YES;
    [MMiaErrorTipView hideErrorTipForView:self.view];
    [MMiaLoadingView showLoadingForView:self.view];
    [self getCategroyDataForRequest];
}



#pragma mark - TableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _categroyArray.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed:0xf0/255.0 green:0xf0/255.0 blue:0xf0/255.0 alpha:1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        // 显示类目名称
        UILabel* categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TableView_Cell_Width, TableView_Cell_Height)];
        categoryLabel.tag = 110;
        categoryLabel.backgroundColor = [UIColor clearColor];
        categoryLabel.font = [UIFont systemFontOfSize:14];
        categoryLabel.textAlignment = NSTextAlignmentCenter;
        categoryLabel.highlightedTextColor = [UIColor colorWithRed:0xe1/255.0 green:0x4a/255.0 blue:0x4a/255.0 alpha:1];
        categoryLabel.textColor = [UIColor colorWithRed:0x40/255.0 green:0x40/255.0 blue:0x40/255.0 alpha:1];
        [cell.contentView addSubview:categoryLabel];
    }
    
    UILabel* label = (UILabel *)[cell.contentView viewWithTag:110];
    MagezineItem* item = self.categroyArray[indexPath.row];
    label.text = item.logoWord;
    label.font = [UIFont systemFontOfSize:14];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 更换当前选中类目数据
    self.currentIndexPath = indexPath;
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.tableView selectRowAtIndexPath:self.currentIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark -UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.categroyArray.count == 0) {
        return 0;
    }
    MagezineItem* category = self.categroyArray[self.currentIndexPath.row];
    return category.subMagezineItem.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.categroyArray.count == 0) {
        return 0;
    }
    MagezineItem* category = [self.categroyArray objectAtIndex:self.currentIndexPath.row];
    MagezineItem* subCategory = category.subMagezineItem[section];
    return subCategory.subMagezineItem.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    MMiaCollectionViewWaterfallHeader *reusableView = nil;
    MagezineItem* category = self.categroyArray[self.currentIndexPath.row];
    MagezineItem* subCategory = category.subMagezineItem[indexPath.section];
    if( [kind isEqualToString:CHTCollectionElementKindSectionHeader] )
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEADER_IDENTIFIER forIndexPath:indexPath];
        [reusableView fillContent:nil indexPath:indexPath];
        [reusableView initializeHeaderWithLeftImage:nil rightImage:nil titleString:subCategory.logoWord];
        
    }
    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMiaMainViewWaterfallCell *cell =
    (MMiaMainViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    MagezineItem* category = self.categroyArray[self.currentIndexPath.row];;
    MagezineItem* subCategory = category.subMagezineItem[indexPath.section];
    MagezineItem* subCategoryItem = subCategory.subMagezineItem[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:subCategoryItem.pictureImageUrl]];
    NSInteger width = (CGRectGetWidth(self.view.bounds) - TableView_Cell_Width) / 3 - 8;
    cell.imageView.frame = CGRectMake((cell.bounds.size.width - width) / 2, cell.bounds.origin.y, width, width / 150.0 * 200);
    cell.displayLabel.text = subCategoryItem.logoWord;
    cell.displayLabel.font = [UIFont systemFontOfSize:12];
    cell.displayLabel.numberOfLines = 0;
    cell.displayLabel.frame = CGRectMake(0.f, cell.contentView.bounds.origin.y + cell.imageView.frame.size.height, CGRectGetWidth(cell.imageView.bounds), 30);
    return cell;
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger width = (CGRectGetWidth(self.view.bounds) - TableView_Cell_Width) / 3;
    CGSize size = CGSizeMake( width, width / 150.0 * 200 + 30 );
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem* category = [self.categroyArray objectAtIndex:self.currentIndexPath.row];
    MagezineItem* subCategory = category.subMagezineItem[indexPath.section];
    MagezineItem* item = subCategory.subMagezineItem[indexPath.row];
    if( [item isMemberOfClass:[NSNull class]] )
    {
        return;
    }
    MMiaSingleCategoryContainer* singleVC = [[MMiaSingleCategoryContainer alloc] initWithInfo:item.aId title:item.logoWord];
    [self.navigationController pushViewController:singleVC animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
