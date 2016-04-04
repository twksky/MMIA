//
//  MMiaConcernPersonHomeViewController.m
//  MMIA
//
//  Created by lixiao on 14-9-19.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaConcernPersonHomeViewController.h"
#import "MMiaCommonUtil.h"
#import "MMiaMainViewWaterfallCell.h"
#import "MJRefresh.h"
#import "MMIToast.h"
#import "MMIAAboutPersonViewController.h"
#import "MMiaAboutCompanyViewController.h"
#import "LoginInfoItem.h"
#import "MMiaNoDataView.h"
#import "MMiaFunsViewController.h"
#import "MMiaPagesContainer.h"
#import "MMiaPersonHomeView.h"
#import "MMiaConcernSpecialViewController.h"
#import "MMiaDetailPictureViewController.h"
#import "MMiaDetailGoodsViewController.h"
#import "MMiaDetailSpecialViewController.h"
#import "MMiaLikeViewController.h"
#import "MMiaSpecialViewController.h"


@interface MMiaConcernPersonHomeViewController ()<MMiaPersonHomeViewDelegate,MMiaConcernSpecialViewControllerDelegate, MMiaLikeViewControllerDelegate>
{
    UIView *_bgView;
    UIView *_topView;
    NSInteger _userid;
    NSMutableArray *_btnArray;
    BOOL      _isLoadding;
    BOOL      _isRefresh;
    BOOL      _showErrTipView;
    BOOL      _isPersonRequest;
    int       _downNum;
    MMiaNoDataView *_nodataView;
    BOOL         _isConcern;
    
}
@property (nonatomic,retain) LoginInfoItem *loginItem;
@property (strong, nonatomic) MMiaPagesContainer* pagesContainer;
@property (nonatomic, retain) UILabel *specialLabel;
@property (nonatomic, retain) UILabel *likeLabel;
@end

@implementation MMiaConcernPersonHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id)initWithUserid:(NSInteger)userid
{
    self=[super init];
    if (self)
    {
        _userid=userid;
    }
    return self;
}

- (MMiaPagesContainer *)pagesContainer
{
    if( !_pagesContainer )
    {
        _pagesContainer = [[MMiaPagesContainer alloc] init];
        [_pagesContainer willMoveToParentViewController:self];
        UIImage *backImage = [UIImage imageNamed:@"personalcenter_head_bg.png"];
        MMiaPersonHomeView* personView = [[MMiaPersonHomeView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), backImage.size.height)];
        personView.delegate = self;
        _pagesContainer.headerImageView = personView;
        _pagesContainer.topBarBackgroundColor = UIColorFromRGB(0x393b49);
        _pagesContainer.topBarHeight = 35;
        _pagesContainer.selectedPageItemImage = nil;
        _pagesContainer.pageItemsTitleColor = UIColorFromRGB(0xffffff);
        _pagesContainer.selectedPageItemTitleColor = UIColorFromRGB(0xe14a4a);
        _pagesContainer.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
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
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:YES];
    
     [self.pagesContainer viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.navigationView addSubview:self.specialLabel];
    [self.navigationView addSubview:self.likeLabel];
    self.specialLabel.hidden = NO;
    self.likeLabel.hidden = YES;
    [self addNewBackBtnWithTarget:self selector:@selector(buttonClick:)];
   self.view.backgroundColor = UIColorFromRGB(0xE1E1E1);
    self.loginItem = [[LoginInfoItem alloc]init];
   // add viewControllers
   [self addViewControllers];
   [self getUserPersonalInfoRequest];
    
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(dolikeDataRequest:) name:Change_LikeData object:nil];
}

#pragma mark - LoadUI

-(void)addViewControllers
{
    self.pagesContainer.pageIndicatorViewSize = CGSizeMake(6, 4);
    CGFloat inset = self.pagesContainer.topBarHeight + CGRectGetHeight(self.pagesContainer.headerImageView.bounds);
    
   MMiaConcernSpecialViewController *specialVC = [[MMiaConcernSpecialViewController alloc]init];
    specialVC.userId = _userid;
    specialVC.title = @"专题";
    specialVC.specialDelegate = self;
    specialVC.collectionInset = inset;
    
    MMiaLikeViewController *likeVC = [[MMiaLikeViewController alloc]init];
    likeVC.userId = _userid;
    likeVC.title = @"喜欢";
    likeVC.delegate = self;
    likeVC.collectionInset = inset;
    
    self.pagesContainer.viewControllers = @[specialVC, likeVC];
    
    __block MMiaConcernPersonHomeViewController *homeVC = self;
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
                [homeVC topBarAddViewController: homeVC];
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
                [homeVC topBarAddViewController: homeVC];
            }else
            {
                [homeVC topBarAddHeaderView];
            }
        }
    };
}

#pragma mark-buttonClick
-(void)buttonClick:(UIButton *)button
{
    if (button.tag==1003)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}

#pragma mark -Private
-(void)getUserPersonalInfoRequest
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
    if (!userTicket)
    {
        userTicket=@"";
    }
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:_userid],@"userid",userTicket,@"ticket", nil];
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.mmiaDataEngine startAsyncRequestWithUrl:MMia_GET_PERSONAL_INFO_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        if ([jsonDict[@"result"]intValue]==0)
        {
            MMiaPersonHomeView *personView = (MMiaPersonHomeView *)self.pagesContainer.headerImageView;
            int concern=[[jsonDict objectForKey:@"isAttention"]intValue];
            if (concern==1)
            {
                _isConcern=YES;
                [personView.addConcernButton setImage:[UIImage imageNamed:@"personalcenter_followedicon.png"] forState:UIControlStateNormal];
            }else
            {
                _isConcern=NO;
                [personView.addConcernButton setImage:[UIImage imageNamed:@"personalcenter_plusicon.png"] forState:UIControlStateNormal];
            }
            _userid=[jsonDict[@"id"]intValue];
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

//取消关注
-(void)getCancelFollowSomeOneDataWithTargetUser:(UIButton *)button
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
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
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"myUserid", userTicket,@"ticket", [NSNumber numberWithLong:_userid],@"targetUserid", nil];
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_CANCEL_FOLLOWONE_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject){
        [button setEnabled:YES];
        if ([jsonObject[@"result"] intValue]==0)
        {
            if (self.funsBlock)
            {
                self.funsBlock(-1);
            }
            
             [button setImage:[UIImage imageNamed:@"personalcenter_plusicon.png"] forState:UIControlStateNormal];
            [MMIToast showWithText:@"取消关注成功" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
            _isConcern=NO;
            
        }else
        {
            [MMIToast showWithText:@"取消关注失败" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
            _isConcern=YES;
        }
        
    }errorHandler:^(NSError *error){
        [button setEnabled:YES];
        [MMIToast showWithText:@"取消关注失败" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
        _isConcern=YES;
    }];
    
}
//关注
-(void)getFocusFollowSomeOneDataWithTargetUser:(UIButton *)button
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
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
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"myUserid", userTicket,@"ticket", [NSNumber numberWithLong:_userid],@"targetUserid", nil];
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_FOCUS_FOLLOWONE_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject){
        [button setEnabled:YES];
        if ([jsonObject[@"result"] intValue]==0)
        {
            if (self.funsBlock)
            {
                self.funsBlock(1);
            }
           [button setImage:[UIImage imageNamed:@"personalcenter_followedicon.png"] forState:UIControlStateNormal];
            [MMIToast showWithText:@"关注成功" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
            _isConcern=YES;
        }else
        {
            [MMIToast showWithText:@"关注失败" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
            _isConcern=NO;
        }
        
    }errorHandler:^(NSError *error){
        [button setEnabled:YES];
        [MMIToast showWithText:@"关注失败" topOffset:CGRectGetHeight([UIScreen mainScreen].bounds)-20 image:nil];
        _isConcern=NO;
    }];
}


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
//根据变异量设置topBar
-(void)resetTopBarOffset:(CGFloat)offsetY ViewController:(UIViewController *)viewController ContentInset:(CGFloat)contentInset
{
    CGFloat flagY = VIEW_OFFSET + kNavigationBarHeight;
    UIImage *backImage = [UIImage imageNamed:@"personalcenter_head_bg.png"];
    if ((offsetY >= (-contentInset + backImage.size.height - flagY)) && (self.navigationView.backgroundColor == [UIColor clearColor]))
    {
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
    if ((offsetY <= (-contentInset + backImage.size.height - flagY)) && (self.navigationView.backgroundColor != [UIColor clearColor]))
    {
        [self.pagesContainer.topBar removeFromSuperview];
        CGRect frame = self.pagesContainer.topBar.frame;
        frame.origin.y = backImage.size.height;
        self.pagesContainer.topBar.frame = frame;
        [self.pagesContainer.headerView addSubview:self.pagesContainer.topBar];
        self.navigationView.backgroundColor = [UIColor clearColor];
    }
    
}

#pragma mark - MMiaPersonHomeViewDelegate

-(void)addConcernPerson:(UIButton *)button;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL islogin=[defaults boolForKey:USER_IS_LOGIN];
            if (islogin==NO)
          {
             [MMIToast showWithText:@"抱歉，您还没有登录" topOffset:Main_Screen_Height-20 image:nil];
                return;
           }
        if (_isConcern)
        {
             [self getCancelFollowSomeOneDataWithTargetUser:button];
        }else{
               //关注
              [self getFocusFollowSomeOneDataWithTargetUser:button];
        }
    [button setEnabled:NO];
 
}

#pragma mark - MMiaConcernSpecialViewControllerDelegate

-(void)concernSpecialViewController:(MMiaConcernSpecialViewController *)viewController didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem *item=(MagezineItem *)[viewController.specialArray objectAtIndex:indexPath.item];
    MMiaDetailSpecialViewController *despVC=[[MMiaDetailSpecialViewController alloc]initWithTitle:item.title MagazineId:item.aId UserId:_userid isAttention:item.likeNum];
    despVC.magezineBlock = ^(int concern){
        for (UIViewController *vc in self.pagesContainer.viewControllers) {
            if ([vc isKindOfClass:[MMiaConcernSpecialViewController class]])
            {
                [(MMiaConcernSpecialViewController *)vc doReturnSpecialBlock:concern indexPath:indexPath];
            }
        }
    };

    [self.navigationController pushViewController:despVC animated:YES];
}

-(void)concernScrollViewDidScrollViewController:(MMiaConcernSpecialViewController *)viewController ContentoffsetY:(CGFloat)offsetY contentInset:(CGFloat)contentInset
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
        [self topBarAddViewController:viewController];
    }
    if ((contentOffsetY <= (-contentInset + backImage.size.height - flagY)) && (self.navigationView.backgroundColor != [UIColor clearColor]))
    {
        [self topBarAddHeaderView];
    }

}

#pragma mark-notificationCenter

-(void)dolikeDataRequest:(NSNotification *)nc
{
    MMiaLikeViewController *likeVC = (MMiaLikeViewController *)[self.pagesContainer.viewControllers objectAtIndex:1];
    if (likeVC.indexPath)
    {
        int likeNum=[[nc.userInfo objectForKey:Add_Like_Num]intValue];
        MagezineItem* item = [likeVC.likeDataArr objectAtIndex:likeVC.indexPath.item];
        item.likeNum+=likeNum;
        [likeVC.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:likeVC.indexPath]];
    }

//    if ([[nc.userInfo objectForKey:Add_Like_Num]integerValue]==-1  && likeVC.indexPath)
//    {
//        [likeVC.likeDataArr removeObjectAtIndex:likeVC.indexPath.item];
//        [likeVC.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:likeVC.indexPath]];
//    }
//    if  ([[nc.userInfo objectForKey:Add_Like_Num]integerValue]==1  && likeVC.indexPath)
//    {
//        [likeVC.likeDataArr insertObject:likeVC.selectItem atIndex:0];
//        [likeVC.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]]];
//        NSIndexPath *newIndexPath=[NSIndexPath indexPathForItem:0 inSection:0];
//        likeVC.indexPath=newIndexPath;
//    }
    
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Change_LikeData object:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
