//
//  MMiaMinorCategoryViewController.m
//  MMIA
//
//  Created by yhx on 14-10-27.
//  Copyright (c) 2014年 广而告之. All rights reserved.
//

#import "MMiaMinorCategoryViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MMiaMainViewWaterfallCell.h"
#import "MMiaCollectionViewWaterfallHeader.h"
#import "MMiaCommonUtil.h"
#import "MMIToast.h"
#import "MMiaErrorTipView.h"
#import "MMiaSingleCategoryContainer.h"

#define CELL_IDENTIFIER @"Cell"
#define HEADER_IDENTIFIER @"WaterfallHeader"

static const NSInteger Cell_Init_Count       = 4;
static const CGFloat Minor_Cell_Width        = 80;
static const CGFloat Minor_Cell_Height       = 135;
static const CGFloat Minor_Cell_Image_Width  = 66;
static const CGFloat Minor_Cell_Image_Height = 87.5;
static const CGFloat Minor_Cell_Image_Margin = 13;

@interface MMiaMinorCategoryViewController () <UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout, MMiaErrorTipViewDelegate>
{
    NSInteger categoryId;
    NSString* titleString;
    BOOL      isLoadding;
}

@property (nonatomic, strong) UICollectionView* collectionView;

@property (nonatomic, strong) NSMutableArray* secCategroyArr;
@property (nonatomic, strong) NSMutableArray* subCategroyArr;
@property (nonatomic, strong) NSMutableArray* statusArray;

- (void)getMinorCategoryDataForRequest;
- (void)netWorkError:(NSError *)error;

@end

@implementation MMiaMinorCategoryViewController

#pragma mark - Accessors

- (UICollectionView *)collectionView
{
    if( !_collectionView )
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.headerHeight = 35;
        layout.minimumColumnSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.columnCount = 4;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(80, VIEW_OFFSET + kNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - kNavigationBarHeight - VIEW_OFFSET) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[MMiaMainViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[MMiaCollectionViewWaterfallHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
    }
    return _collectionView;
}

#pragma mark - Life Cycle

- (id)initWithInfo:(NSInteger)info title:(NSString*)titleName
{
    self = [self init];
    if( self )
    {
        categoryId  = info;
        titleString = titleName;
    }
    return self;
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
    [appDelegate.tabController hideOrNotCustomTabBar:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitleString:titleString];
    [self addBackBtnWithTarget:self selector:@selector(back)];
    self.view.backgroundColor = [UIColor colorWithRed:0xef/255.0 green:0xef/255.0 blue:0xef/255.0 alpha:1.0];
    
    [self.view addSubview:self.collectionView];
    
    _secCategroyArr = [NSMutableArray array];
    _subCategroyArr = [NSMutableArray array];
    _statusArray = [NSMutableArray array];
    
    isLoadding = YES;
    [MMiaLoadingView showLoadingForView:self.view];
    [self getMinorCategoryDataForRequest];
}

#pragma mark - Private

- (void)getMinorCategoryDataForRequest
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary* dict = @{@"categoryId":[NSNumber numberWithLong:categoryId]};
    [appDelegate.mmiaDataEngine startAsyncRequestWithUrl:MMia_MINOR_CATEGROY_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary* dataDict)
     {
         if( [dataDict[@"result"] intValue] == 0 )
         {
             isLoadding = NO;
             [MMiaLoadingView hideLoadingForView:self.view];
             //MyNSLog( @"minorDict = %@", dataDict );
             
             NSArray* categoryArr = dataDict[@"data"];
             for( NSDictionary* minorDict in categoryArr )
             {
                 NSString* sectionName = minorDict[@"name"];
                 if( sectionName.length <= 0 )
                     continue;
                 
                 [self.secCategroyArr addObject:sectionName];
                 NSNumber* isOpen = @NO;
                 [self.statusArray addObject:isOpen];
                 
                 NSArray* subCategroyArr = minorDict[@"subCategroy"];
                 NSMutableArray* array = [NSMutableArray arrayWithCapacity:subCategroyArr.count + 10];
                 for( NSDictionary* subCategroyDict in subCategroyArr )
                 {
                     MagezineItem* subItem = [[MagezineItem alloc] init];
                     subItem.logoWord = subCategroyDict[@"name"];
                     if( subItem.logoWord.length <= 0 )
                         continue;
                     subItem.aId = [subCategroyDict[@"id"] intValue];
                     subItem.pictureImageUrl = subCategroyDict[@"imgUrl"];
                     [array addObject:subItem];
                 }
                 // 添加为4的倍数
                 NSInteger count = array.count;
                 if( count % Cell_Init_Count != 0 )
                 {
                     for( int i = 0; i < (floor(count/Cell_Init_Count) + 1) * Cell_Init_Count - count; ++i )
                     {
                         [array addObject:[NSNull null]];
                     }
                 }
                 [self.subCategroyArr addObject:array];
             }
             [self.collectionView reloadData];
         }
         else
         {
             [self netWorkError:nil];
         }
         
     } errorHandler:^(NSError* error)
     {
         [self netWorkError:nil];
     }];
}

- (void)netWorkError:(NSError *)error
{
    if( isLoadding )
    {
        isLoadding = NO;
        [MMiaLoadingView hideLoadingForView:self.view];
    }
    CGFloat errTipY = (CGRectGetHeight(self.view.bounds) - 125)/2;
    CGFloat errTipX = CGRectGetWidth(self.view.bounds) / 2;
    [MMiaErrorTipView showErrorTipForView:self.view center:CGPointMake(errTipX, errTipY) error:error delegate:self];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openBtnClicked:(UIButton *)sender
{
    sender.hidden = YES;
    
    MMiaMainViewWaterfallCell* cell = (MMiaMainViewWaterfallCell *)[[sender superview] superview];
    NSInteger section = cell.indexPath.section;
    NSInteger itemIndex = cell.indexPath.item;
    
    BOOL isOpen = [self.statusArray[section] boolValue];
    [self.statusArray replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:!isOpen]];

    NSMutableArray* indexPathArr = [[NSMutableArray alloc] init];
    
    if( isOpen ) // 展开状态需要缩起
    {
        for( int i = itemIndex; i >= Cell_Init_Count; --i )
        {
            NSIndexPath* path = [NSIndexPath indexPathForRow:i inSection:section];
            [indexPathArr addObject:path];
        }
        [self.collectionView deleteItemsAtIndexPaths:indexPathArr];
        
        // 展开之前的Item显示按钮
        NSIndexPath* preIndex = [NSIndexPath indexPathForItem:Cell_Init_Count - 1 inSection:section];
        MMiaMainViewWaterfallCell* preCell = (MMiaMainViewWaterfallCell *)[self.collectionView cellForItemAtIndexPath:preIndex];
        [cell.openButton setBackgroundImage:[UIImage imageNamed:@"展开_按钮.png"] forState:UIControlStateNormal];
        preCell.openButton.hidden = NO;
        [preCell.openButton addTarget:self action:@selector(openBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        preCell.indexPath = preIndex;
    }
    else         // 缩起状态需要展开
    {
        for( int i = itemIndex + 1; i < [self.subCategroyArr[section] count]; ++i )
        {
            NSIndexPath* path = [NSIndexPath indexPathForRow:i inSection:section];
            [indexPathArr addObject:path];
        }
        [self.collectionView insertItemsAtIndexPaths:indexPathArr];
    }
    
    // 此效果当前刷新的section会闪屏
//    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:section]];
}

#pragma mark -MMiaErrorTipViewDelegate

- (void)onErrorTipViewRefreshBtnClicked:(MMiaErrorTipView* )sender
{
    isLoadding = YES;
    [MMiaErrorTipView hideErrorTipForView:self.view];
    [MMiaLoadingView showLoadingForView:self.view];
    [self getMinorCategoryDataForRequest];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = [self.subCategroyArr[section] count];
    BOOL isOpen = [self.statusArray[section] boolValue];
    
    if( count > Cell_Init_Count && !isOpen )
    {
        return Cell_Init_Count;
    }
    return count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.secCategroyArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMiaMainViewWaterfallCell *cell =
    (MMiaMainViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                           forIndexPath:indexPath];
    NSInteger section = indexPath.section;
    NSArray* _sectionArr = self.subCategroyArr[section];
    MagezineItem* item = _sectionArr[indexPath.item];
//    MyNSLog( @"section & row = %d, %d", section, indexPath.item );
    
    if( ![item isMemberOfClass:[NSNull class]] )
    {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl]];
        cell.imageView.frame = CGRectMake((Minor_Cell_Width - Minor_Cell_Image_Width)/2, Minor_Cell_Image_Margin, Minor_Cell_Image_Width, Minor_Cell_Image_Height);
        
        cell.displayLabel.numberOfLines = 0;
        cell.displayLabel.font = [UIFont systemFontOfSize:13];
        cell.displayLabel.text = item.logoWord;
        
        cell.displayLabel.frame = CGRectMake(5, CGRectGetMaxY(cell.imageView.frame), Minor_Cell_Width - 10, Minor_Cell_Height - Minor_Cell_Image_Margin - Minor_Cell_Image_Height);
    }
    else
    {
        cell.imageView.frame = cell.displayLabel.frame = CGRectMake(0, 0, 0, 0);
    }
    
    // 添加右下角展开/缩起按钮
    NSInteger num = [self.collectionView numberOfItemsInSection:indexPath.section];
    if( _sectionArr.count > Cell_Init_Count && (indexPath.row == num - 1) )
    {
        BOOL isOpen = [self.statusArray[indexPath.section] boolValue];
        if( isOpen )
        {
            [cell.openButton setBackgroundImage:[UIImage imageNamed:@"缩起_按钮.png"] forState:UIControlStateNormal];
        }
        else
        {
            [cell.openButton setBackgroundImage:[UIImage imageNamed:@"展开_按钮.png"] forState:UIControlStateNormal];
        }
        cell.openButton.hidden = NO;
        [cell.openButton addTarget:self action:@selector(openBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.indexPath = indexPath;
    }
    else
    {
        cell.indexPath = nil;
        cell.openButton.hidden = YES;
    }

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    MMiaCollectionViewWaterfallHeader *reusableView = nil;
    
    if( [kind isEqualToString:CHTCollectionElementKindSectionHeader] )
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
        [reusableView fillContent:nil indexPath:indexPath];
        [reusableView initializeHeaderWithLeftImage:nil rightImage:nil titleString:self.secCategroyArr[indexPath.section]];
    }
    
    return reusableView;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(Minor_Cell_Width, Minor_Cell_Height);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* _sectionArr = self.subCategroyArr[indexPath.section];
    MagezineItem* item = _sectionArr[indexPath.item];
    
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
