//
//  MmiaMainViewController.m
//  MMIA
//
//  Created by MMIA-Mac on 15-5-15.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaMainViewController.h"
#import "MmiaDataModel.h"
#import "MJExtension.h"
#import "AdditionHeader.h"
#import "GlobalKey.h"
#import "GlobalNetwork.h"
#import "View+MASAdditions.h"
#import "AppDelegate.h"

#import "MmiaCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "MmiaTransitionController.h"

#import "MmiaCollectionViewSmallLayout.h"
#import "MmiaPaperViewController.h"
#import "MmiaAdboardView.h"
#import "MmiaSearchViewController.h"
#import "MainTableViewMoreCell.h"
#import "MainTableViewOnlyCell.h"
#import "MainTableViewTwoCell.h"
#import "MainTableViewLoadCell.h"


CGFloat const KBannerHeight = 228.0f;
CGFloat const KAddOffset = 44.0f;

@interface MmiaMainViewController () <UITableViewDelegate, UITableViewDataSource, MmiaPaperViewControllerDelegate, UINavigationControllerDelegate>
{
    MmiaDataModel *_model;
    
    CGFloat _footerViewPosition;
    CGFloat _footerViewOffsetY;
    CGPoint _windowOrigin;
    BOOL    _isFooterView;
}

@property (nonatomic, strong) UITableView*  tableView;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIWindow*     window;

@property (nonatomic, strong) MmiaTransitionController* transitionController;
@property (nonatomic, strong) MmiaPaperViewController* paperViewController;
@property (nonatomic, strong) MmiaAdboardView* adboardView;

@property (nonatomic, strong) NSMutableArray* dataArray;

- (void)layoutSubviews;
- (void)addNavigationBarItem;
- (void)refreshAdboardView:(NSArray *)data;
- (void)scrollPointToVisible:(CGPoint)point scrollEnabled:(BOOL)scrollEnabled;
- (void)windowTransformWithPoint:(CGPoint)finalOrigin;

@end

@implementation MmiaMainViewController

#pragma mark - init

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout])
    {
        [self.tableView registerNib:UINibWithName(@"MainTableViewMoreCell") forCellReuseIdentifier:TableViewMoreCellIdentifier];
        [self.tableView registerNib:UINibWithName(@"MainTableViewOnlyCell") forCellReuseIdentifier:TableViewOnlyCellIdentifier];
        [self.tableView registerNib:UINibWithName(@"MainTableViewTwoCell") forCellReuseIdentifier:TableViewTwoCellIdentifier];
        [self.tableView registerClass:[MainTableViewLoadCell class] forCellReuseIdentifier:TableViewLoadCellIdentifier];
    }
    return self;
}

- (void)layoutSubviews
{
    self.scrollView.height = self.view.height;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -self.scrollView.height, 0);
    self.tableView.tableFooterView = self.scrollView;
    
    // 重置contentInset和contentOffset
    if( _isFooterView )
    {
        [self.tableView setContentOffset:CGPointMake(0, _footerViewPosition) animated:NO];
    }
    
    _footerViewPosition = self.tableView.contentSize.height - fabs(self.tableView.contentInset.bottom);
    _footerViewOffsetY = fabs(_footerViewPosition - self.view.height);
    
    self.paperViewController.view.frame = self.scrollView.bounds;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self layoutSubviews];
    [self.paperViewController viewWillAppear:animated];
//    [self.view bringSubviewToFront:self.navigationView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.hidden = YES;
    [self addNavigationBarItem];

    _dataArray = [[NSMutableArray alloc] init];
//    for( NSInteger i = 0; i < 3; i ++ )
    {
        UIImageView* imageView1 = [[UIImageView alloc] initWithImage:UIImageNamed(@"photo1.jpg")];
        [_dataArray addObject:imageView1];
        
        UIImageView* imageView2 = [[UIImageView alloc] initWithImage:UIImageNamed(@"photo2.jpg")];
        [_dataArray addObject:imageView2];

        UIImageView* imageView3 = [[UIImageView alloc] initWithImage:UIImageNamed(@"photo3.jpg")];
        [_dataArray addObject:imageView3];
    }
    
    [self.scrollView addSubview:self.paperViewController.view];
    [self.paperViewController didMoveToParentViewController:self];

    [self requestWithStart:0];
    
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.navigationView addGestureRecognizer:panGesture];
    
    //[self.view bringSubviewToFront:self.navigationView];
}

- (void)requestWithStart:(NSInteger)start
{
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1697],@"userid", [NSNumber numberWithInteger:start],@"start",[NSNumber numberWithInteger:20],@"size",@"b61549cd8b00c2efddac690e8b728686", @"ticket", nil];
    
    NSString *urlStr = @"category/getFirstLevelCategory";//@"/product/test";
    NSDictionary* dict;
    
    [[MMiaNetworkEngine sharedInstance] startPostAsyncRequestWithUrl:urlStr param:dict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic)
     {
         _model = [MmiaDataModel objectWithKeyValues:responseDic];
         NSArray *arr = [MMiaDetailModel objectArrayWithKeyValuesArray:_model.data];
         for (MMiaDetailModel *data in arr)
         {
//             [self.dataArray addObject:data.imgUrl];
         }
         
         [self.tableView reloadData];
         
     }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
//         NSLog( @"err = %@", error );
         
     }];
    
    [self refreshAdboardView:_dataArray];
    
//    _footerViewPosition = self.tableView.contentSize.height - fabs(self.tableView.contentInset.bottom);
//    _footerViewOffsetY = fabs(_footerViewPosition - self.view.height);
}

#pragma mark - Accessors

- (UITableView *)tableView
{
    if ( !_tableView )
    {
        _tableView = UITableView.new;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.clipsToBounds = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self.view addSubview:_tableView];
        [self.view insertSubview:_tableView belowSubview:self.navigationView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (UIScrollView *)scrollView
{
    if( !_scrollView )
    {
        _scrollView = UIScrollView.new;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.alwaysBounceVertical = YES;
    }
    return _scrollView;
}

- (MmiaPaperViewController *)paperViewController
{
    if( !_paperViewController )
    {
        MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
        _paperViewController = [[MmiaPaperViewController alloc] initWithCollectionViewLayout:smallLayout];
        _paperViewController.delegate = self;
        _paperViewController.navigationView.hidden = YES;
        _paperViewController.topDataArray = @[@"photo1.jpg", @"photo2.jpg", @"photo3.jpg"];
        
        [_paperViewController willMoveToParentViewController:self];
    }
    return _paperViewController;
}

- (UIWindow *)window
{
    if( !_window )
    {
        _window = [AppDelegate sharedAppDelegate].window;
        _window.layer.shadowRadius = 5.0f;
        _window.layer.shadowOffset = CGSizeMake(0,0);
        _window.layer.shadowColor = [UIColor blackColor].CGColor;
        _window.layer.shadowOpacity = .5f;
    }
    return _window;
}

- (MmiaAdboardView *)adboardView
{
    if( !_adboardView )
    {
        _adboardView = [[MmiaAdboardView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, KBannerHeight)];
        _adboardView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        self.tableView.tableHeaderView = _adboardView;
    }
    return _adboardView;
}

#pragma mark - Private

- (void)addNavigationBarItem
{
    self.navigationView.backgroundColor = [UIColor clearColor];
    self.lineLabel.hidden = YES;
    
    UIImage* image = UIImageNamed(@"mmia_logo.png");
    UIImageView* logoImageView = UIImageViewImage(image);
    [self.navigationView addSubview:logoImageView];
    
    UIButton* cateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* butImage = UIImageNamed(@"分类_按钮.png");
    [cateButton setImage:butImage forState:UIControlStateNormal];
    [cateButton addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:cateButton];
    
    UIButton* searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* srcImage = UIImageNamed(@"searchBtn.png");
    [searchButton setImage:srcImage forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:searchButton];
    
    UIImage* upImage = UIImageNamed(@"上拉_icon.png");
    UIImageView* upImageView = UIImageViewImage(upImage);
    upImageView.tag = 110;
    [self.navigationView addSubview:upImageView];
    upImageView.hidden = YES;
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.navigationView).offset(10);
        make.top.equalTo(self.navigationView).offset(VIEW_OFFSET + 7);
        make.width.equalTo(@(image.size.width));
        make.height.equalTo(@(image.size.height));
    }];
    
    [cateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navigationView).offset(-10);
        make.top.equalTo(logoImageView.mas_top);
        make.width.equalTo(@(butImage.size.width));
        make.height.equalTo(@(butImage.size.height));
    }];
    
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cateButton.mas_left).offset(-21);
        make.top.equalTo(logoImageView.mas_top);
        make.width.equalTo(@(srcImage.size.width));
        make.height.equalTo(@(srcImage.size.height));
    }];
    
    [upImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView).offset(5);
        make.centerX.equalTo(self.navigationView);
        make.height.equalTo(@(upImage.size.height));
    }];
}

- (void)refreshAdboardView:(NSArray *)data
{
    WeakSelf(weakSelf);
    self.adboardView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return weakSelf.dataArray[pageIndex];
    };
    self.adboardView.totalPageCount = self.dataArray.count;
    self.adboardView.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"点击了第%ld个",pageIndex);
    };
}

- (void)scrollPointToVisible:(CGPoint)point scrollEnabled:(BOOL)scrollEnabled
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            [self.tableView setContentOffset:point animated:YES];
            
        } completion:^(BOOL finished) {
            self.tableView.scrollEnabled = scrollEnabled;
            self.scrollView.scrollEnabled = !scrollEnabled;
            
        }];
    });
}

- (void)windowTransformWithPoint:(CGPoint)finalOrigin
{
    CGRect frame = self.window.frame;
    frame.origin = finalOrigin;
    
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.window.transform = CGAffineTransformIdentity;
                         self.window.frame = frame;
                         
                     } completion:^(BOOL finished) {
                         
                         if( CGPointEqualToPoint(frame.origin, CGPointZero) )
                         {
                             [self.navigationView viewWithTag:110].hidden = YES;
                         }
                         else
                         {
                             [self.navigationView viewWithTag:110].hidden = NO;
                         }
                     }];
}

#pragma mark - 响应事件
#pragma mark **navigationBar拖拽

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:self.window];
    CGPoint velocity = [pan velocityInView:self.window];

    switch( pan.state )
    {
        case UIGestureRecognizerStateBegan:
            _windowOrigin = self.window.frame.origin;
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            if( _windowOrigin.y + translation.y >= 0 )
            {
                self.window.transform = CGAffineTransformMakeTranslation(0, translation.y);
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            CGPoint finalOrigin = CGPointZero;
            
            if( velocity.y >= 0 )
            {
                finalOrigin.y = Main_Screen_Height - self.naviBarView.height;
            }
            [self windowTransformWithPoint:finalOrigin];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark **点击分类按钮

- (void)categoryButtonClick:(UIButton *)sender
{
    // 分类页面
    CGRect frame = self.window.frame;
    CGPoint finalOrigin = CGPointZero;
    
    if( frame.origin.y == CGPointZero.y )
    {
        finalOrigin.y = Main_Screen_Height - self.naviBarView.height;
        [self windowTransformWithPoint:finalOrigin];
    }
    else
    {
        finalOrigin.y = Main_Screen_Height - self.naviBarView.height;
        frame.origin.y = Main_Screen_Height - 2 * self.naviBarView.height;;
        
        [UIView animateWithDuration:.3 animations:^{
            self.window.transform = CGAffineTransformIdentity;
            self.window.frame = frame;
            
        } completion:^(BOOL finished) {
            
            [self windowTransformWithPoint:finalOrigin];
        }];
    }
}

#pragma mark **点击搜索按钮

- (void)searchButtonClick:(UIButton *)sender
{
    CGRect frame = self.window.frame;
    if( frame.origin.y == (Main_Screen_Height - self.naviBarView.height) )
        return;
    
    // 搜索页面
    MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
    MmiaSearchViewController* searchVC = [[MmiaSearchViewController alloc] initWithCollectionViewLayout:smallLayout];
    searchVC.view.frame = self.view.bounds;
    [self.view addSubview:searchVC.view];
    [self addChildViewController:searchVC];
}

#pragma mark - MmiaPaperViewControllerDelegate

- (void)showViewController:(UIViewController *)viewController didSelectInPaperView:(MmiaPaperViewController *)paperView
{
    // push的时候tableView会滚动到_footerViewPosition位置
    if( _isFooterView )
    {
        // 重置contentInset
        [self.tableView setContentInset:UIEdgeInsetsZero];
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;

    switch ( row )
    {
        case 0:
        {
            MainTableViewMoreCell* moreCell = [tableView dequeueReusableCellWithIdentifier:TableViewMoreCellIdentifier forIndexPath:indexPath];
            moreCell.leftImageView.backgroundColor = [UIColor orangeColor];
            moreCell.rightTopImageView.backgroundColor = [UIColor orangeColor];
            moreCell.rightBottomImageView.backgroundColor = [UIColor orangeColor];
            
            return moreCell;
        }
            break;
        case 1:
        {
            MainTableViewOnlyCell* onlyCell = [tableView dequeueReusableCellWithIdentifier:TableViewOnlyCellIdentifier forIndexPath:indexPath];
            onlyCell.onlyImageView.backgroundColor = [UIColor orangeColor];
            
            return onlyCell;
        }
            break;
        case 2:
        {
            MainTableViewTwoCell* twoCell = [tableView dequeueReusableCellWithIdentifier:TableViewTwoCellIdentifier forIndexPath:indexPath];
            twoCell.leftImageView.backgroundColor = [UIColor orangeColor];
            twoCell.rightImageView.backgroundColor = [UIColor orangeColor];
            
            return twoCell;
        }
            break;
        case 3:
        {
            MainTableViewLoadCell* cell = [tableView dequeueReusableCellWithIdentifier:TableViewLoadCellIdentifier forIndexPath:indexPath];
            cell.loadLabel.text = @"···························向上滑动加载更多·······················";
            
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    CGFloat cellHeight = KTableViewMoreCell_Height;
    if( row == 1 )
    {
        cellHeight = KTableViewOnlyCell_Height;
    }
    else if( row == 2 )
    {
        cellHeight = KTableViewTwoCell_Height;
    }
    else if( row == 3 )
    {
        cellHeight = TableViewLoadCell_Height;
    }
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
    MmiaPaperViewController* paperViewController = [[MmiaPaperViewController alloc] initWithCollectionViewLayout:smallLayout];
    paperViewController.topDataArray = @[@"photo1.jpg", @"photo2.jpg", @"photo3.jpg"];
    
    [self.navigationController pushViewController:paperViewController animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    
    if( scrollView == self.tableView )
    {
        if( contentOffsetY >= _footerViewOffsetY + KAddOffset )
        {
            _isFooterView = YES;
            [self scrollPointToVisible:CGPointMake(0, _footerViewPosition) scrollEnabled:NO];
        }
    }
    else if( scrollView == self.scrollView )
    {
        if( contentOffsetY < -KAddOffset )
        {
            _isFooterView = NO;
            [self scrollPointToVisible:CGPointMake(0, _footerViewOffsetY) scrollEnabled:YES];
        }
    }
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if( animationController == self.transitionController)
    {
        return self.transitionController;
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (![fromVC isKindOfClass:[UICollectionViewController class]] || ![toVC isKindOfClass:[UICollectionViewController class]])
    {
        return nil;
    }
    if (!self.transitionController.hasActiveInteraction)
    {
        return nil;
    }
    
    self.transitionController.navigationOperation = operation;
    return self.transitionController;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
}

@end
