//
//  MMIAPersonalHomePageViewController.m
//  MMIA
//
//  Created by lixiao on 15/2/5.
//  Copyright (c) 2015年 com.zixun. All rights reserved.
//

#import "MMIAPersonalHomePageViewController.h"
#import "LoginUserItem.h"
#import "MMIToast.h"
#import "MJRefresh.h"
#import "MagezineItem.h"
#import "MMIASettingViewController.h"
#import "MMiaDataSetViewController.h"
#import "MMiaCompanyDataSetViewController.h"
#import "MMiaQueryViewController.h"
//专题详情页
#import "MMiaDetailSpecialViewController.h"
//分享 喜欢
#import "MMiaLikeViewController.h"
#import "MMiaSpecialViewController.h"
#import "LoginInfoItem.h"
#import "MyCustomTabBarController.h"
#import "MMiaPagesContainer.h"
#import "MMiaPersonHomeView.h"
#import "MMiaConcernViewController.h"
#import "MMiaFunsViewController.h"
#import "MMiaDetailPictureViewController.h"
#import "MMiaDetailGoodsViewController.h"


@interface MMIAPersonalHomePageViewController ()<MMiaPersonHomeViewDelegate,MMiaSpecialViewControllerDelegate,MMiaLikeViewControllerDelegate>{
    
}

@property(nonatomic,retain) LoginInfoItem *loginItem;
@property (strong, nonatomic) MMiaPagesContainer* pagesContainer;
@property (nonatomic, retain) UILabel *specialLabel;
@property (nonatomic, retain) UILabel *likeLabel;

@end

@implementation MMIAPersonalHomePageViewController


#pragma mark - init

- (MMiaPagesContainer *)pagesContainer
{
    if( !_pagesContainer )
    {
        _pagesContainer = [[MMiaPagesContainer alloc] init];
        [_pagesContainer willMoveToParentViewController:self];
        UIImage *backImage = [UIImage imageNamed:@"personalcenter_head_bg.png"];
        MMiaPersonHomeView* personView = [[MMiaPersonHomeView alloc] initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.view.frame), backImage.size.height)];
        personView.addConcernButton.hidden = YES;
        personView.delegate = self;
        _pagesContainer.headerImageView = personView;
        _pagesContainer.topBarBackgroundColor = UIColorFromRGB(0x393b49);
        _pagesContainer.topBarHeight = 35;
        _pagesContainer.selectedPageItemImage = nil;
        _pagesContainer.pageItemsTitleColor = UIColorFromRGB(0xffffff);
        _pagesContainer.selectedPageItemTitleColor = UIColorFromRGB(0xe14a4a);
        _pagesContainer.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 45);
        _pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view insertSubview:_pagesContainer.view belowSubview:self.navigationView];
        [_pagesContainer didMoveToParentViewController:self];
    }
    return _pagesContainer;
}

-(UILabel *)specialLabel
{
    if (!_specialLabel)
    {
        _specialLabel = [[UILabel alloc] initWithFrame:CGRectMake((App_Frame_Width - 200)/2, VIEW_OFFSET + (kNavigationBarHeight - 19)/2, 200, 19)];
        _specialLabel.textAlignment = MMIATextAlignmentCenter;
        _specialLabel.backgroundColor = [UIColor clearColor];
        _specialLabel.textColor = UIColorFromRGB(0xffffff);
        _specialLabel.font = [UIFont systemFontOfSize:15];
    }
    return _specialLabel;
}

-(UILabel *)likeLabel
{
    if (!_likeLabel)
    {
       _likeLabel = [[UILabel alloc] initWithFrame:CGRectMake((App_Frame_Width - 200)/2, VIEW_OFFSET + (kNavigationBarHeight - 19)/2, 200, 19)];
        _likeLabel.textAlignment = MMIATextAlignmentCenter;
        _likeLabel.backgroundColor = [UIColor clearColor];
        _likeLabel.textColor = UIColorFromRGB(0xffffff);
        _likeLabel.font = [UIFont systemFontOfSize:15];
    }
    return _likeLabel;
}


-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isLogin = [defaults boolForKey:USER_IS_LOGIN];
    if( !isLogin )
    {
        AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.tabController switchToFirst];
    }
    for( UIViewController *viewController in self.pagesContainer.viewControllers )
    {
        [viewController viewWillAppear:YES];
    }
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:NO];
    [self.pagesContainer viewWillAppear:animated];
}

#pragma mark - lifeStyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationView.backgroundColor = [UIColor clearColor];
    self.navigationView.clipsToBounds = YES;
    [self.navigationView addSubview:self.specialLabel];
    [self.navigationView addSubview:self.likeLabel];
    self.specialLabel.hidden = NO;
    self.likeLabel.hidden = YES;
    self.view.backgroundColor = UIColorFromRGB(0xE1E1E1);
    self.loginItem = [[LoginInfoItem alloc]init];
    [self addNewBackBtnWithTarget:self selector:@selector(btnClick:)];
    UIButton *leftButton=(UIButton *)[self.navigationView viewWithTag:1003];
    [leftButton setImage:[UIImage imageNamed:@"personalcenter_settingicon.png"] forState:UIControlStateNormal];
    [self addNewRightBtnWithImage:[UIImage imageNamed:@"searchresultpage_searchbutton.png"] Target:self selector:@selector(btnClick:)];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:PERSON_HOME_HAVE];
    [defaults synchronize];
    //add viewControllers
    [self addViewControllers];
    [self getUserPersonalInfoRequest];
    
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(getUserPersonalInfoRequest) name:Change_PersonData object:nil];
    [nc addObserver:self selector:@selector(doMagezineRequest) name:Change_MagezineData object:nil];
    [nc addObserver:self selector:@selector(doMagezineRequest) name:Ining_MagezineData object:nil];
    [nc addObserver:self selector:@selector(dolikeDataRequest) name:Change_LikeData object:nil];
}

#pragma mark - LoadUI

-(void)addViewControllers
{
    self.pagesContainer.pageIndicatorViewSize = CGSizeMake(6, 4);
    CGFloat inset = self.pagesContainer.topBarHeight + CGRectGetHeight(self.pagesContainer.headerImageView.bounds);
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSInteger userId=[[defaults objectForKey:USER_ID]integerValue];
    
    MMiaSpecialViewController *specialVC = [[MMiaSpecialViewController alloc] init];
    specialVC.userId = userId;
    specialVC.title = @"专题";
    specialVC.showError = YES;
    specialVC.specialDelegate = self;
    specialVC.collectionInset = inset;
    
    MMiaLikeViewController *likeVC = [[MMiaLikeViewController alloc]init];
    likeVC.userId = userId;
    likeVC.title = @"喜欢";
    likeVC.delegate = self;
    likeVC.isOthers = NO;
    likeVC.collectionInset = inset;
    
    __block MMIAPersonalHomePageViewController *homeVC = self;
    self.pagesContainer.viewControllers = @[specialVC,likeVC];
        self.pagesContainer.selcectBlock = ^(int selctIndex)
        {
            CGFloat flagY = VIEW_OFFSET + kNavigationBarHeight;
            UIImage *backImage = [UIImage imageNamed:@"personalcenter_head_bg.png"];
            if (selctIndex == 0)
            {
                homeVC.specialLabel.hidden = NO;
                homeVC.likeLabel.hidden = YES;
                if (specialVC.collectionView.contentOffset.y >= (-inset + backImage.size.height - flagY))
                {
                    [homeVC topBarAddViewController:homeVC];
                }else
                {
                    [homeVC topBarAddHeaderView];
                }

            }else
            {
                homeVC.specialLabel.hidden = YES;
                homeVC.likeLabel.hidden = NO;
                if (likeVC.collectionView.contentOffset.y >= (-inset + backImage.size.height - flagY))
                {
                 [homeVC topBarAddViewController:homeVC];
                }else
                {
                    [homeVC topBarAddHeaderView];
                }

            }
        };
    }

#pragma mark -notification do
-(void)doMagezineRequest
{
    MMiaSpecialViewController *specialVC = (MMiaSpecialViewController *)[self.pagesContainer.viewControllers objectAtIndex:0];
    [MMiaErrorTipView hideErrorTipForView:specialVC.collectionView];
    if (specialVC.isLoadding == NO)
    {
        specialVC.isLoadding = YES;
        specialVC.isRefresh = YES;
        specialVC.nodataView.hidden = YES;
        specialVC.showError = NO;
        [specialVC getUserMagazineRequestStart:0 Size:Request_Data_Count];
    }
}

-(void)dolikeDataRequest
{
    MMiaLikeViewController *likeVC = (MMiaLikeViewController *)[self.pagesContainer.viewControllers objectAtIndex:1];
    [MMiaErrorTipView hideErrorTipForView:likeVC.collectionView];
    if (likeVC.isLoadding == NO)
    {
        likeVC.isLoadding = YES;
        likeVC.isRefresh = YES;
        likeVC.noDataView.hidden = YES;
        [likeVC getProductLikeDataByRequest:0];
    }
 
}

#pragma mark - controlEvent
/*
 @param   button
 @descripation  按钮点击事件
 */
- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == 1003) {
        
        MMIASettingViewController *mvc = [[MMIASettingViewController alloc]initWithLoginInfoItem:self.loginItem];
        [self.navigationController pushViewController:mvc animated:YES];
    }
    if (btn.tag == 1004) {
        //右边
        MMiaQueryViewController *queryVC=[[MMiaQueryViewController alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFromRight;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController pushViewController:queryVC animated:NO];
    }
}

#pragma mark-Public

-(void)selectSendRequest
{
    [self getUserPersonalInfoRequest];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSInteger userId=[[defaults objectForKey:USER_ID]integerValue];
    MMiaSpecialViewController *specialVC = (MMiaSpecialViewController *)[self.pagesContainer.viewControllers objectAtIndex:0];
    [MMiaErrorTipView hideErrorTipForView:specialVC.collectionView];
    if (specialVC.isLoadding == NO)
    {
        specialVC.userId = userId;
        specialVC.isLoadding = YES;
        [specialVC.dataArray removeAllObjects];
        [specialVC.collectionView reloadData];
        specialVC.nodataView.hidden = YES;
        [MMiaLoadingView showLoadingForView:specialVC.view];
        [specialVC getUserMagazineRequestStart:0 Size:Request_Data_Count];
    }
    
    
    MMiaLikeViewController *likeVC = (MMiaLikeViewController *)[self.pagesContainer.viewControllers objectAtIndex:1];
    [MMiaErrorTipView hideErrorTipForView:likeVC.collectionView];
    if (likeVC.isLoadding == NO)
    {
        likeVC.userId = userId;
        likeVC.isLoadding = YES;
        [likeVC.likeDataArr removeAllObjects];
        [likeVC.collectionView reloadData];
        likeVC.noDataView.hidden = YES;
        [MMiaLoadingView showLoadingForView:likeVC.view];
        [likeVC getProductLikeDataByRequest:0];
    }
}

#pragma mark-Private

-(void)getUserPersonalInfoRequest
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    int userId=[[defaults objectForKey:USER_ID]intValue];
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
    if (!userTicket)
    {
        userTicket=@"";
    }
    if (!userId)
    {
        userId=0;
    }
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userid",userTicket,@"ticket", nil];
    [appDelegate.mmiaDataEngine startAsyncRequestWithUrl:MMia_GET_PERSONAL_INFO_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        if ([jsonDict[@"result"]intValue]==0)
        {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:jsonDict[@"email"] forKey:USER_EMAIL];
            self.loginItem.id = [jsonDict[@"id"]integerValue];
            self.loginItem.headImageUrl = jsonDict[@"headPicture"];
            self.loginItem.nikeName = jsonDict[@"nickName"];
            self.loginItem.sex = [jsonDict[@"sex"]intValue];
            self.loginItem.signature = jsonDict[@"signature"];
            self.loginItem.email = jsonDict[@"email"];
            self.loginItem.userType = [jsonDict[@"userType"]intValue];
            self.loginItem.fansNumber = [jsonDict[@"fansNumber"]intValue];
            self.loginItem.focusPersonNumber = [jsonDict[@"focusPersonNumber"]intValue];
            if ([jsonDict[@"userType"]intValue] == 1)
            {
                self.loginItem.website = jsonDict[@"website"];
                self.loginItem.homepage = jsonDict[@"homepage"];
                self.loginItem.industry = jsonDict[@"industry"];
                self.loginItem.workUnit = jsonDict[@"workUnit"];
            }
            if ([self.pagesContainer.headerImageView isKindOfClass:[MMiaPersonHomeView class]])
            {
                [((MMiaPersonHomeView *)self.pagesContainer.headerImageView) resetSubViewsWithDictionary:self.loginItem];
            }
            self.specialLabel.text = self.loginItem.nikeName;
            self.likeLabel.text   = self.loginItem.nikeName;
            self.specialLabel.alpha = 0;
            self.likeLabel.alpha = 0;
        }
    }errorHandler:^(NSError *error){
        
        
    }];
}

//修改topBar
-(void)topBarAddViewController:(UIViewController *)viewController
{
    CGFloat flagY = VIEW_OFFSET + kNavigationBarHeight;
    [self.pagesContainer.topBar removeFromSuperview];
    CGRect frame = self.pagesContainer.topBar.frame;
    frame.origin.y = flagY;
    self.pagesContainer.topBar.frame = frame;
    [viewController.view addSubview:self.pagesContainer.topBar];
    UIImage *naBackImage;
    if (iOS7)
    {
        naBackImage = [UIImage imageNamed:@"personalcenter_topbar_64.png"];
        
    }else
    {
        naBackImage = [UIImage imageNamed:@"personalcenter_topbar_44.png"];
    }
    self.navigationView.backgroundColor = [UIColor colorWithPatternImage:naBackImage];
}

-(void)topBarAddHeaderView
{
    UIImage *backImage = [UIImage imageNamed:@"personalcenter_head_bg.png"];
    [self.pagesContainer.topBar removeFromSuperview];
    CGRect frame = self.pagesContainer.topBar.frame;
    frame.origin.y = backImage.size.height;
    self.pagesContainer.topBar.frame = frame;
    [self.pagesContainer.headerView addSubview:self.pagesContainer.topBar];
    self.navigationView.backgroundColor = [UIColor clearColor];
}


#pragma mark - MMiaPersonHomeViewDelegate

-(void)tapInsertSetViewControllerClick
{
    if (self.loginItem.userType==0)
    {
        MMiaDataSetViewController *dataSetVc = [[MMiaDataSetViewController alloc]initWithLoginItem:self.loginItem];
        [self.navigationController pushViewController:dataSetVc animated:YES];
    }else
    {
        MMiaCompanyDataSetViewController *companyDSvc = [[MMiaCompanyDataSetViewController alloc]initWithLoginItem:self.loginItem];
        [self.navigationController pushViewController:companyDSvc animated:YES];
        
    }
}

-(void)tapConcernViewClick
{
    MMiaConcernViewController *concernVC = [[MMiaConcernViewController alloc]initWithUserId:self.loginItem.id];
    [self.navigationController pushViewController:concernVC animated:YES];
}

-(void)tapFunsViewClick
{
    MMiaFunsViewController *funsVC = [[MMiaFunsViewController alloc]initWithUserId:self.loginItem.id];
    [self.navigationController pushViewController:funsVC animated:YES];
}

#pragma mark - MMiaSpecialViewControllerDelegate

-(void)viewController:(MMiaSpecialViewController *)viewController didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem *item=(MagezineItem *)[viewController.dataArray objectAtIndex:indexPath.item];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    int userId=[[defaults objectForKey:USER_ID]intValue];
    MMiaDetailSpecialViewController *despVC=[[MMiaDetailSpecialViewController alloc]initWithTitle:item.title MagazineId:item.aId UserId:userId isAttention:item.likeNum];
    [self.navigationController pushViewController:despVC animated:YES];
}

-(void)scrollViewDidScrollViewController:(MMiaSpecialViewController *)viewController ContentoffsetY:(CGFloat)offsetY contentInset:(CGFloat)contentInset
{
    MMiaPersonHomeView *homeView = (MMiaPersonHomeView *)self.pagesContainer.headerImageView;
    CGFloat flagY = VIEW_OFFSET + kNavigationBarHeight;
    CGFloat offSet = homeView.nikeNameLabel.frame.origin.y;
   
    if ((offsetY < -contentInset + offSet + flagY - CGRectGetMaxY(self.specialLabel.frame) || (offsetY > -contentInset + offSet + flagY - CGRectGetMaxY(self.specialLabel.frame) && offsetY < -contentInset + offSet + flagY - CGRectGetMinY(self.specialLabel.frame))))
    {
        self.specialLabel.alpha = 0;
        homeView.nikeNameLabel.alpha = 1;
    }
    if (offsetY > -contentInset + offSet + flagY - CGRectGetMinY(self.specialLabel.frame))
    {
        self.specialLabel.alpha = 1;
        homeView.nikeNameLabel.alpha = 0;
    }
    UIImage *backImage = [UIImage imageNamed:@"personalcenter_head_bg.png"];
    if ((offsetY >= (-contentInset + backImage.size.height - flagY)) && (self.navigationView.backgroundColor == [UIColor clearColor]))
    {
        [self topBarAddViewController:self];
    }
    if ((offsetY <= (-contentInset + backImage.size.height - flagY)) && (self.navigationView.backgroundColor != [UIColor clearColor]))
    {
        [self topBarAddHeaderView];
    }
    
}

#pragma mark - MMiaLikeViewControllerDelegate

-(void)likeviewController:(MMiaLikeViewController *)viewController didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem* item = [viewController.likeDataArr objectAtIndex:indexPath.item];
    if (item.magazineId>0)
    {
        MMiaDetailGoodsViewController *detailGoodsVC=[[MMiaDetailGoodsViewController alloc]initWithTitle:item.title Id:item.aId goodsImage:item.pictureImageUrl Width:item.imageWidth Height:item.imageHeight price:item.imgPrice productId:item.magazineId];
        detailGoodsVC.likeDelegate=self;
        [self.navigationController pushViewController:detailGoodsVC animated:YES];
    }else
    {
        
        MMiaDetailPictureViewController *detailPictureVC=[[MMiaDetailPictureViewController alloc]initWithTitle:item.title Id:item.aId goodsImage:item.pictureImageUrl Width:item.imageWidth Height:item.imageHeight price:item.imgPrice productId:item.magazineId];
        detailPictureVC.likeDelegate=self;
        [self.navigationController pushViewController:detailPictureVC animated:YES];
    }
}

-(void)likeScrollViewDidScrollViewController:(MMiaLikeViewController *)viewController ContentOffset:(CGFloat)contentOffsetY contentInset:(CGFloat)contentInset
{
    MMiaPersonHomeView *homeView = (MMiaPersonHomeView *)self.pagesContainer.headerImageView;
    CGFloat flagY = VIEW_OFFSET + kNavigationBarHeight;
    CGFloat offSet = homeView.nikeNameLabel.frame.origin.y;
    
    if ((contentOffsetY < -contentInset + offSet + flagY - CGRectGetMaxY(self.likeLabel.frame) || (contentOffsetY > -contentInset + offSet + flagY - CGRectGetMaxY(self.likeLabel.frame) && contentOffsetY < -contentInset + offSet + flagY - CGRectGetMinY(self.likeLabel.frame))))
    {
        self.likeLabel.alpha = 0;
        homeView.nikeNameLabel.alpha = 1;
    }
    if (contentOffsetY > -contentInset + offSet + flagY - CGRectGetMinY(self.likeLabel.frame))
    {
        self.likeLabel.alpha = 1;
        homeView.nikeNameLabel.alpha = 0;
    }
    
    UIImage *backImage = [UIImage imageNamed:@"personalcenter_head_bg.png"];
    if ((contentOffsetY >= (-contentInset + backImage.size.height - flagY)) && (self.navigationView.backgroundColor == [UIColor clearColor]))
    {
        [self topBarAddViewController:self];
    }
    if ((contentOffsetY <= (-contentInset + backImage.size.height - flagY)) && (self.navigationView.backgroundColor != [UIColor clearColor]))
    {
        [self topBarAddHeaderView];
    }

}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Change_PersonData object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Change_MagezineData object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Ining_MagezineData object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:Change_LikeData object:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
