//
//  MMiaMainViewController.m
//  MMIA
//
//  Created by MMIA-Mac on 14-7-2.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import "MMiaMainViewController.h"
#import "MagezineItem.h"
#import "MMiaPagesContainer.h"
#import "MMiaDetailSpecialViewController.h"
#import "MMiaConcernPersonHomeViewController.h"
#import "MMIToast.h"

@interface MMiaMainViewController () <MMiaAdboardViewDelegate>
{
    BOOL isRefresh;
    BOOL isLoading;
}
@property (strong, nonatomic) NSMutableArray* bannerArr;  // 广告图片数据
@property (strong, nonatomic) MMiaPagesContainer* pagesContainer;
@property (strong, nonatomic) UICollectionView* observeCollectionView;

- (void)addViewControllersForPagesContainer;
- (void)createNotifications;
- (void)destroyNotifications;
- (void)netWorkWithError:(NSError *)error;

@end

@implementation MMiaMainViewController

#pragma mark - Accessors

- (MMiaPagesContainer *)pagesContainer
{
    if( !_pagesContainer )
    {
        _pagesContainer = [[MMiaPagesContainer alloc] init];
        [_pagesContainer willMoveToParentViewController:self];
        
        MMiaAdboardView* adboardView = [[MMiaAdboardView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CONTENT_INSET_TOP)];
        adboardView.tag = 10;
        adboardView.delegate = self;
        _pagesContainer.headerImageView = adboardView;
        
        _pagesContainer.view.frame = CGRectMake(0, VIEW_OFFSET, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 45 - VIEW_OFFSET);
        _pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_pagesContainer.view];
        [_pagesContainer didMoveToParentViewController:self];
    }
    return _pagesContainer;
}

#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    // initialize array
    _bannerArr = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //lx change
  // [self hideNavigationBar];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:NO];
    [self.pagesContainer viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // add pagesContainer
    [self addViewControllersForPagesContainer];
    
    isLoading = YES;
    [self getHomePageDataForRequest];
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [self getAllMagezineType];
   });
    
}

#pragma mark - Public
//lx add
//写文件
-(void)writeMagezineType:(NSArray *)array
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
     NSString *typePath = [documentsDirectory stringByAppendingPathComponent:@"magezineType.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:typePath])
    {
         [fm removeItemAtPath:typePath error:nil];
    }
    [fm createFileAtPath:typePath contents:nil attributes:nil];
    [array writeToFile:typePath atomically:YES];
}

//类型杂志
-(void)getAllMagezineType
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlStr=@"humpback4/getZhuantiCategorys.do";
    [appDelegate.mmiaDataEngine startAsyncRequestWithUrl:urlStr param:nil requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *dataDict)
     {
          if( [dataDict[@"result"] intValue] == 0 )
          {
              NSArray *dataArr=[dataDict objectForKey:@"data"];
              [self writeMagezineType:dataArr];
          }
         
     }errorHandler:^(NSError *error){
         
     }];
}

// 首页三合一接口
- (void)getHomePageDataForRequest
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary* dict = @{@"start":[NSNumber numberWithInt:0], @"size":[NSNumber numberWithInt:Request_Data_Count]};
        [appDelegate.mmiaDataEngine startAsyncRequestWithUrl:MMia_HOMEPAGE_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary* dataDict)
    {
        if( [dataDict[@"result"] intValue] == 0 )
        {
            NSDictionary* dict = dataDict[@"data"];
            NSArray* banArr = dict[@"banner"];
            NSArray* magArr = dict[@"magazine"];
            
//            MyNSLog( @"bannerArr = %@", banArr );
//            MyNSLog( @"magArr = %@", magArr );
            
            isLoading = NO;
            if( isRefresh )
            {
                [self.bannerArr removeAllObjects];
            }

            // 解析广告位图片数据
            NSMutableArray* bannerUrlArr = [[NSMutableArray alloc] initWithCapacity:banArr.count];
            for( NSDictionary* banDict in banArr )
            {
                MagezineItem* bannerItem = [[MagezineItem alloc] init];
                bannerItem.aId = [banDict[@"id"] intValue];
                bannerItem.pictureImageUrl = banDict[@"pictureUrl"];
                bannerItem.toUrl = banDict[@"toUrl"];
                bannerItem.userId = [banDict[@"userId"] intValue];
                bannerItem.magazineId = [banDict[@"magazineId"] intValue];
                bannerItem.type = [banDict[@"isAttention"] intValue];
                
                if( bannerItem.pictureImageUrl.length > 0 )
                {
                    [self.bannerArr addObject:bannerItem];
                    [bannerUrlArr addObject:bannerItem.pictureImageUrl];
                }
            }
            [self.pagesContainer refreshAdboardData:bannerUrlArr];
            
            // 解析全部频道图片数据
            NSMutableArray* magazineArr = [[NSMutableArray alloc] initWithCapacity:magArr.count];
            for( NSDictionary* magDict in magArr )
            {
                MagezineItem* item = [[MagezineItem alloc] init];
                item.aId = [magDict[@"id"] intValue];
                item.pictureImageUrl = magDict[@"pictureUrl"];
                item.logoWord = magDict[@"logoWord"];
                item.userId = [magDict[@"userId"] intValue];
                item.magazineId = [magDict[@"magazineId"] intValue];
                item.imageWidth = [magDict[@"width"] floatValue];
                item.imageHeight = [magDict[@"height"] floatValue];
                item.type = [magDict[@"isAttention"] intValue];
                [magazineArr addObject:item];
            }

            for (UIViewController* viewController in self.pagesContainer.viewControllers)
            {
                if( [viewController isKindOfClass:[MMiaFullPageController class]] )
                {
                    [(MMiaFullPageController *)viewController refreshPageData:magazineArr downNum:magArr.count];
                    
                    break;
                }
            }
            isRefresh = NO;
        }
        else
        {
            [self netWorkWithError:nil];
        }
        
    } errorHandler:^(NSError* error)
    {
        
//        MyNSLog( @"error = %@", [error localizedDescription] );
        [self netWorkWithError:error];
    }];
}

- (void)netWorkWithError:(NSError *)error
{
    for( UIViewController* viewController in self.pagesContainer.viewControllers )
    {
        if( [viewController isKindOfClass:[MMiaFullPageController class]] )
        {
            [(MMiaFullPageController *)viewController netWorkError:error];
            break;
        }
    }
    
    if( isLoading )
    {
        isLoading = NO;
    }
    if( isRefresh )
    {
        isRefresh = NO;
    }
}

#pragma mark - Private

/**
 * 添加每个标签对应的ViewControllers
 */
- (void)addViewControllersForPagesContainer
{
    CGFloat inset = self.pagesContainer.topBarHeight + CGRectGetHeight(self.pagesContainer.headerImageView.bounds);
    
    MMiaFullPageController* fullVC = [[MMiaFullPageController alloc] init];
    fullVC.title = @"全部";
    fullVC.collectionInset = inset;
    
    MMiaClothesPageController* clothVC = [[MMiaClothesPageController alloc] init];
    clothVC.title = @"衣";
    clothVC.collectionInset = inset;
    
    MMiaFoodPageController* foodVC = [[MMiaFoodPageController alloc] init];
    foodVC.title = @"食";
    foodVC.collectionInset = inset;
    
    MMiaLivePageController* liveVC = [[MMiaLivePageController alloc] init];
    liveVC.title = @"住";
    liveVC.collectionInset = inset;
    
    MMiaTravelPageController* travelVC = [[MMiaTravelPageController alloc] init];
    travelVC.title = @"行";
    travelVC.collectionInset = inset;

    self.pagesContainer.viewControllers = @[fullVC, clothVC, foodVC, liveVC, travelVC];

    [self createNotifications];
}

- (void)createNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPage:) name:@"RefreshMainPage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemInMainAtIndexPath:) name:@"didSelectItemAtMain" object:nil];
}

- (void)destroyNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RefreshMainPage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didSelectItemAtMain" object:nil];
}

#pragma mark - KVO & NSNotification

- (void)refreshPage:(NSNotification*)notification
{
    if( isLoading )
        return;
    
    isLoading = YES;
    isRefresh = YES;
    [self getHomePageDataForRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self destroyNotifications];
}

#pragma mark - MMiaAdboardView delegate

- (void)MMiaAdboardViewTap:(NSInteger)currentNum
{
    // TODO:跳转到杂志主页
    MagezineItem* item = [self.bannerArr objectAtIndex:currentNum];
    [self tapToVc:item];
}

#pragma mark - NSNotificationCenter

- (void)didSelectItemInMainAtIndexPath:(NSNotification*)notification
{
   
    NSDictionary* dict = [notification userInfo];
   MagezineItem* item = dict[@"item"];
    [self tapToVc:item];

}
-(void)tapToVc:(MagezineItem *)item
{
     NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSInteger userId=item.userId;
    NSInteger defaultsId=[[defaults objectForKey:USER_ID]integerValue];
    BOOL isLogin=[defaults boolForKey:USER_IS_LOGIN];
    //全为-1
    if (item.magazineId==-1 && item.userId==-1)
    {
        [MMIToast showWithText:@"用户不存在" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-50 image:nil];
        return;
    }
    //登录，用户主页
    if (isLogin && item.magazineId==-1 && userId==defaultsId)
    {
        [MMIToast showWithText:@"自己的主页请点击右下角进入个人中心查看" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-50 image:nil];
        return;
    }
    
    if (isLogin && item.magazineId==-1 && userId!=defaultsId)
    {
       // NSLog(@"item.userId=%d",item.userId);
        MMiaConcernPersonHomeViewController *concernVC=[[MMiaConcernPersonHomeViewController alloc]initWithUserid:item.userId];
        [self.navigationController pushViewController:concernVC animated:YES];
        return;
    }
    //登录专题页
    if (isLogin && item.magazineId!=-1 && userId==defaultsId)
    {
        [MMIToast showWithText:@"自己的专题请点击右下角进入个人中心查看" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-50 image:nil];
        return;
    }
    
    if (isLogin && item.magazineId!=-1 && userId!=defaultsId)
    {
        MMiaDetailSpecialViewController *specialVC=[[MMiaDetailSpecialViewController alloc]initWithTitle:@"" MagazineId:item.magazineId UserId:item.userId isAttention:item.likeNum];
        specialVC.isNotEdit=YES;
        specialVC.isAttention=item.type;
        [self.navigationController pushViewController:specialVC animated:YES];
        return;
    }
    //未登录 用户主页
    if (isLogin==NO && item.magazineId==-1)
    {
         // NSLog(@"item.userId=%d",item.userId);
        MMiaConcernPersonHomeViewController *concernVC=[[MMiaConcernPersonHomeViewController alloc]initWithUserid:item.userId];
        [self.navigationController pushViewController:concernVC animated:YES];
        return;
    }
    if (isLogin==NO && item.magazineId!=-1)
    {
        MMiaDetailSpecialViewController *specialVC=[[MMiaDetailSpecialViewController alloc]initWithTitle:@"" MagazineId:item.magazineId UserId:item.userId isAttention:item.likeNum];
        specialVC.isNotEdit=YES;
        specialVC.isAttention=item.type;
        [self.navigationController pushViewController:specialVC animated:YES];
    }
    

}

@end
