//
//  MmiaMainViewController.h
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-4.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaMainViewController.h"
#import "UIViewController+StackViewController.h"
#import "CollectionViewWaterfallCell.h"
#import "CollectionViewWaterfallHeader.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MmiaDetailSpecialViewController.h"
#import "MmiaAdboardView.h"
#import "MmiaModelRoomViewController.h"
#import "MmiaPersonalHomeViewController.h"
#import "MmiaOtherPersonHomeViewController.h"
#import "MmiaDetailSpecialViewController.h"
#import "MmiaSearchResultViewController.h"


const NSInteger CollectionView_Cell_Width  = 170;
const NSInteger CollectionView_Cell_Height = 212;

const NSInteger Cell_Image_Bottom_Margin = 19;

const NSInteger Cell_Label_Margin = 10.0f;
const NSInteger Cell_Label_Height = 50;

@interface MmiaMainViewController () <CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) MmiaAdboardView*  adboardView;

@property (nonatomic, strong) NSMutableArray* bannerArray;
@property (nonatomic, strong) NSMutableArray* categroyArray;
@property (nonatomic, assign) CGFloat         sectionInsetLeft;
@property (nonatomic, strong) NSMutableArray* sectionViewsArray;

- (void)getHomePageDataForRequest;
- (void)refreshBannerData:(NSArray *)array;
- (void)showStackViewController;

@end

@implementation MmiaMainViewController

#pragma mark - Accessors

- (UICollectionView *)collectionView
{
    if( !_collectionView )
    {
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(0, self.sectionInsetLeft, 0, self.sectionInsetLeft);
        layout.headerHeight = 60;
        layout.footerHeight = 1;
        layout.minimumColumnSpacing = 16;
        layout.minimumInteritemSpacing = 16;
        layout.columnCount = 5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, App_Portrait_Frame_Width + 186, App_Portrait_Frame_Height) collectionViewLayout:layout];
//        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.clipsToBounds = YES;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColorClear;
        _collectionView.contentInset = UIEdgeInsetsMake(MainPage_Banner_Image_Hight + 1, 0, 0, 0);
        [_collectionView registerClass:[CollectionViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
        [_collectionView registerClass:[CollectionViewWaterfallHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HEADER_IDENTIFIER];
        [_collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:FOOTER_IDENTIFIER];
    }
    return _collectionView;
}

#pragma mark - View life cycle

- (id)init
{
    self = [super init];
    if( self )
    {
        _bannerArray = [NSMutableArray array];
        _categroyArray = [NSMutableArray array];
        _sectionViewsArray = [NSMutableArray array];
        
        self.portrait = YES;
        _sectionInsetLeft = 20;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 获取标准的self.view.frame
    if( !UIInterfaceOrientationIsPortrait(self.interfaceOrientation) )
    {
        if( self.portrait )
        {
            self.portrait = NO;
            self.sectionInsetLeft = 35;
        }
    }
}

//- (void)viewDidLayoutSubviews
//{
//}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MyNSLog( @"MainViewFrame = %@, %f,%f", NSStringFromCGRect(self.view.frame), App_Frame_Height, App_Frame_Width );
    self.view.backgroundColor = ColorWithHexRGB(0xfbfbfb);
    
    [self.view addSubview:self.collectionView];
    
    [self getHomePageDataForRequest];
    [self createNotifications];
    
    _adboardView = [[MmiaAdboardView alloc] initWithFrame:CGRectMake(0, -MainPage_Banner_Image_Hight, App_Portrait_Frame_Width, MainPage_Banner_Image_Hight)];
    [self.collectionView addSubview:_adboardView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // CollectionView布局
    CHTCollectionViewWaterfallLayout* layout = (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    
    if( self.portrait )
    {
        // 竖屏
        self.collectionView.width = App_Portrait_Frame_Width + 186;
        self.collectionView.height = App_Portrait_Frame_Height;
        self.adboardView.width = App_Portrait_Frame_Width;
        
        layout.minimumColumnSpacing = 16;
        layout.minimumInteritemSpacing = 16;
    }
    else
    {
        // 横屏
        self.collectionView.width = App_Landscape_Frame_Width;
        self.collectionView.height = App_Landscape_Frame_Height;
        self.adboardView.width = App_Landscape_Frame_Width;
        
        layout.minimumColumnSpacing = 26;
        layout.minimumInteritemSpacing = 26;
    }
    layout.sectionInset = UIEdgeInsetsMake(0, self.sectionInsetLeft, 0, self.sectionInsetLeft);
    [layout invalidateLayout];
}

#pragma mark - Private

- (void)getHomePageDataForRequest
{
    [[AppDelegate sharedAppDelegate].mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_HOMEPAGE_URL param:nil requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary* dataDict)
     {
         if( [dataDict[@"result"] intValue] == 0 )
         {
             NSDictionary* dict = dataDict[@"data"];
             NSArray* bannerArr = dict[@"banner"];
             NSArray* categoryArr = dict[@"recommend"];
             
//             MyNSLog( @"bannerArr = %@, %d", bannerArr, bannerArr.count );
//             MyNSLog( @"magArr = %@", categoryArr );
             
             // 解析广告位图片数据
             NSMutableArray* bannerUrlArr = [[NSMutableArray alloc] initWithCapacity:bannerArr.count];
             for( NSDictionary* banDict in bannerArr )
             {
                 MagazineItem* bannerItem = [[MagazineItem alloc] init];
                 bannerItem.aId = [banDict[@"id"] integerValue];
                 bannerItem.userId = [banDict[@"userId"] integerValue];
                 bannerItem.magazineId = [banDict[@"magazineId"] integerValue];
                 bannerItem.pictureImageUrl = banDict[@"pictureUrl"];
                 bannerItem.headImageUrl = banDict[@"toUrl"];
                 bannerItem.isAttention = [banDict[@"isAttention"] integerValue];
                 if( bannerItem.pictureImageUrl.length > 0 )
                 {
                     [self.bannerArray addObject:bannerItem];
                     [bannerUrlArr addObject:bannerItem.pictureImageUrl];
                 }
             }
             [self refreshBannerData:bannerUrlArr];
             
             // 解析全部频道图片数据
             for( NSDictionary* dict in categoryArr )
             {
                 MagazineItem* categroyItem = [[MagazineItem alloc] init];
                 categroyItem.titleText = dict[@"name"];

                 NSMutableArray* array = [NSMutableArray arrayWithCapacity:[dict[@"magazines"] count]];
                 for (NSDictionary* magazineDict in dict[@"magazines"])
                 {
                     MagazineItem* magazineItem = [[MagazineItem alloc] init];
                     magazineItem.aId = [magazineDict[@"id"] integerValue];
                     magazineItem.userId = [magazineDict[@"userId"] integerValue];
                     magazineItem.magazineId = [magazineDict[@"magazineId"] integerValue];
                     magazineItem.titleText = magazineDict[@"title"];
                     magazineItem.pictureImageUrl = magazineDict[@"pictureUrl"];
                     magazineItem.imageWidth = [magazineDict[@"width"] floatValue];
                     magazineItem.imageHeight = [magazineDict[@"height"] floatValue];
                     
                     //lx add
                     magazineItem.headImageUrl = magazineDict[@"toUrl"];
                     magazineItem.isAttention = [magazineDict[@"isAttention"] integerValue];
                     
                     [array addObject:magazineItem];
                 }
                 categroyItem.subMagezineArray = array;
                 
                 [self.categroyArray addObject:categroyItem];
             }
             [self.collectionView reloadData];
         }
         else
         {
         }
         
     } errorHandler:^(NSError* error)
     {
         MyNSLog( @"error = %@", [error localizedDescription] );
     }];
}

- (void)refreshBannerData:(NSArray *)array
{
    [self.adboardView setAlphaOfobjs:0.5];
    [self.adboardView setImageArray:array];

    __weak MmiaMainViewController* weakSelf = self;
    self.adboardView.TapActionBlock = ^(NSInteger pageIndex){
        
        MagazineItem *item = [weakSelf.bannerArray objectAtIndex:pageIndex];
        [weakSelf insertIntoViewControllerWithItem:item];
    };
}

- (void)showStackViewController
{
    // TODO:半透明背景
//    if( ![self.view viewWithTag:11] )
//    {
//        UIView* maskLayerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
//        maskLayerView.tag = 11;
//        maskLayerView.backgroundColor = [UIColor lightGrayColor];
//        [self.view addSubview:maskLayerView];
//    }
    MmiaDetailSpecialViewController* detailVC = [[MmiaDetailSpecialViewController alloc] init];
    detailVC.view.frame = self.view.bounds;
    self.rightStackViewController = detailVC;
}

//lx add 跳转逻辑
- (void)insertIntoViewControllerWithItem:(MagazineItem *)item
{
    BOOL isLogin = [StandardUserDefaults boolForKey:USER_IS_LOGIN];
    NSInteger userId = [[StandardUserDefaults objectForKey:USER_ID]integerValue];
    
    //item.headImageUrl 为将要跳转webView的url
    if (item.headImageUrl.length != 0)
    {
        MmiaModelRoomViewController *roomVC = [[MmiaModelRoomViewController alloc]initWithUrlString:item.headImageUrl];
        roomVC.view.frame = self.view.bounds;
        self.rightStackViewController = roomVC;
        
    }else if (item.magazineId != -1)
    {
        MmiaDetailSpecialViewController *detailSpecialVC = [[MmiaDetailSpecialViewController alloc]initWithUserId:item.userId Item:item];
        detailSpecialVC.view.frame = self.view.bounds;
        self.rightStackViewController = detailSpecialVC;
        
    }else if (item.userId == userId && isLogin == YES)
    {
        MmiaPersonalHomeViewController *homeVC = [[MmiaPersonalHomeViewController alloc]init];
        homeVC.view.frame = self.view.bounds;
        self.rightStackViewController = homeVC;
        
    }else if (item.userId != userId)
    {
        MmiaOtherPersonHomeViewController *otherVC = [[MmiaOtherPersonHomeViewController alloc]initWithUserId:item.userId];
        otherVC.view.frame = self.view.bounds;
        self.rightStackViewController = otherVC;
    }
}

#pragma mark *Notifications

- (void)createNotifications
{
    [super createNotifications];
    
    [DefaultNotificationCenter addObserver:self selector:@selector(didSeletedPopoverItem:) name:PopoverController_Notification_Key object:nil];
}

- (void)destroyNotifications
{
    [super destroyNotifications];
    
    [DefaultNotificationCenter removeObserver:self name:PopoverController_Notification_Key object:nil];
}

- (NSString *)didSeletedPopoverItem:(NSNotification *)notification
{
    NSString* textString = [super didSeletedPopoverItem:notification];
    
    // 进入分类/搜索列表页
    NSInteger userId=[[StandardUserDefaults objectForKey:USER_ID]intValue];
    MmiaSearchResultViewController* searchVC = [[MmiaSearchResultViewController alloc] initWithKeyWord:textString UserId:userId];
    searchVC.view.frame = self.view.bounds;
    self.rightStackViewController = searchVC;
    
    return textString;
}

#pragma mark * Overwritten setters

- (void)setSectionInsetLeft:(CGFloat)sectionInsetLeft
{
    if( _sectionInsetLeft != sectionInsetLeft )
    {
        _sectionInsetLeft = sectionInsetLeft;
        
        [self layoutSubviews];
    }
}

#pragma mark -UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.categroyArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    MagazineItem* categoryItem = self.categroyArray[section];
    NSInteger count = categoryItem.subMagezineArray.count;
    if( count > 5 )
        return 5;
    
    return count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* reusableView = nil;
    
    MagazineItem* categoryItem = self.categroyArray[indexPath.section];
    
    if( [kind isEqualToString:CHTCollectionElementKindSectionHeader] )
    {
        reusableView = (CollectionViewWaterfallHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEADER_IDENTIFIER forIndexPath:indexPath];
        [(CollectionViewWaterfallHeader *)reusableView fillWithContent:categoryItem.titleText indexPath:indexPath originX:self.sectionInsetLeft];
        
        // 记录新的reusableView
        BOOL exist = NO;
        for( CollectionViewWaterfallHeader* headerView in self.sectionViewsArray )
        {
            if( [headerView.indexPath isEqual:indexPath] )
            {
                exist = YES;
                break;
            }
        }
        if( !exist )
        {
            [self.sectionViewsArray addObject:reusableView];
        }
    }
    else if( [kind isEqualToString:CHTCollectionElementKindSectionFooter] )
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:FOOTER_IDENTIFIER forIndexPath:indexPath];
        reusableView.backgroundColor = ColorWithHexRGB(0x595959);
    }
    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewWaterfallCell *cell = (CollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    
    MagazineItem* categoryItem = self.categroyArray[indexPath.section];
    MagazineItem* subCategoryItem = categoryItem.subMagezineArray[indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:subCategoryItem.pictureImageUrl]];
    cell.imageView.frame = CGRectMake(0.f, cell.bounds.origin.y, CollectionView_Cell_Width, CollectionView_Cell_Height);
    
    cell.displaybgView.frame = CGRectMake(0.f, cell.contentView.bounds.origin.y + cell.imageView.height - Cell_Label_Height, cell.imageView.width, Cell_Label_Height);
    
    cell.displayLabel.text = subCategoryItem.titleText;
    cell.displayLabel.frame = CGRectMake(Cell_Label_Margin, cell.displaybgView.top, cell.displaybgView.width - 2 * Cell_Label_Margin, cell.displaybgView.height);
    
    if( self.portrait && indexPath.row == 4 )
    {
        UIView* bgView = [[UIView alloc] initWithFrame:cell.bounds];
        bgView.backgroundColor = self.view.backgroundColor;
        bgView.tag = 200;
        [cell.contentView addSubview:bgView];
    }
    else
    {
        [[cell.contentView viewWithTag:200] removeFromSuperview];
    }
    
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(CollectionView_Cell_Width, CollectionView_Cell_Height + Cell_Image_Bottom_Margin);
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagazineItem* categoryItem = self.categroyArray[indexPath.section];
    MagazineItem* subCategoryItem = categoryItem.subMagezineArray[indexPath.row];
    [self insertIntoViewControllerWithItem:subCategoryItem];
}

#pragma mark - UIViewControllerRotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    MyNSLog( @"mainVC rotate" );
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        // 竖屏
        self.portrait = YES;
        self.sectionInsetLeft = 20;
    }
    else
    {
        // 横屏
        self.portrait = NO;
        self.sectionInsetLeft = 35;
    }
    for( CollectionViewWaterfallHeader* hederView in self.sectionViewsArray )
    {
        hederView.originX = self.sectionInsetLeft;
    }
    
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithArray:[self.collectionView indexPathsForVisibleItems]]];
}

// 只需要在顶层视图控制器中开启shouldAutorotate旋转
// 在子视图控制器就可以直接使用supportedInterfaceOrientations
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
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
