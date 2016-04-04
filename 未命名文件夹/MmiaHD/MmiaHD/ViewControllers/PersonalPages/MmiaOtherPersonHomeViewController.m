//
//  MmiaOtherPersonHomeViewController.m
//  MmiaHD
//
//  Created by lixiao on 15/3/25.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaOtherPersonHomeViewController.h"
#import "MmiaLoginViewController.h"
#import "MmiaSpecialViewController.h"
#import "MmiaLikeViewController.h"
#import "MmiaDetailSpecialViewController.h"
#import "MmiaDetailGoodsViewController.h"
#import "AppDelegate.h"
#import "AdditionHeader.h"
#import "GlobalHeader.h"
#import "UIViewController+StackViewController.h"
#import "CollectionViewWaterfallCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MmiaPersonHomeHeaderView.h"
#import "MmiaRecommendWaterFallHeader.h"
#import "MmiaPersonHomeCell.h"
#import "MJRefresh.h"
#import "MagazineItem.h"
#import "MmiaToast.h"

#define SpecialButton_Tag    100
#define HeaderHeight         (UIImageNamed(@"personalcenter_topbg.png").size.  height + 46)
#define ButtonHeight         46

@interface MmiaOtherPersonHomeViewController ()<MmiaSpecialViewControllerDelagate, MmiaLikeViewControllerDelagate, MmiaPersonHomeHeaderViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSInteger         _userId;
    UIView            *_buttonView;
    UILabel           *_lineLabel;
    NSMutableArray    *_buttonArr;
    BOOL              _isLoadding;
    BOOL              _isRefresh;
}

@property (nonatomic, retain) LoginInfoItem               *loginItem;
@property (nonatomic, strong) MmiaPersonHomeHeaderView  *headerView;
@property (nonatomic, retain) MmiaRecommendWaterFallHeader *recommendView;
@property (nonatomic, assign) NSUInteger                selectedIndex;
@property (nonatomic, assign) CGFloat                   contentOffsetY;
@property (nonatomic, retain) UITableView               *tableView;
@property (nonatomic, retain) NSMutableArray            *personArr;

@end

@implementation MmiaOtherPersonHomeViewController

#pragma mark - init

-(id)initWithUserId:(NSInteger)userId
{
    self = [super init];
    if (self)
    {
        _userId = userId;
    }
    return self;
}

- (MmiaPersonHomeHeaderView *)headerView
{
    if( !_headerView )
    {
        _headerView = [[MmiaPersonHomeHeaderView alloc] init];
        _headerView.setButton.hidden = YES;
        _headerView.frame = self.contentView.bounds;
        _headerView.delegate = self;
        _headerView.addConcernButton.hidden = NO;
    }
    return _headerView;
}

#pragma mark - View life cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UIViewController *viewController in self.viewControllers)
    {
        viewController.view.frame = self.contentView.bounds;
        [viewController viewWillAppear:animated];
    }
    [_headerView resetFrame: CGRectMake(0, -HeaderHeight, self.contentView.width, HeaderHeight)];
    self.tableView.frame = CGRectMake(0, 0, self.anotherView.width, self.anotherView.height - 44);
    self.recommendView.frame = CGRectMake(0, 0, self.anotherView.width, 45);
    self.tableView.contentInset = UIEdgeInsetsMake(self.recommendView.height, 0, 0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.personArr = [[NSMutableArray alloc]init];
    _buttonArr = [[NSMutableArray alloc]init];
    self.loginItem = [[LoginInfoItem alloc]init];

    [DefaultNotificationCenter addObserver:self selector:@selector(doCollectionViewOffsetY:) name:OtherHomeOffset_Notification_Key object:nil];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.anotherView addSubview:self.tableView];
    self.recommendView =[[MmiaRecommendWaterFallHeader alloc]init];
    self.recommendView.title = @"推荐内容";
    [self.anotherView addSubview:self.recommendView];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(64, 0, 1, self.anotherView.height)];
    _lineLabel.clipsToBounds = YES;
    _lineLabel.backgroundColor = [UIColor whiteColor];
    [self.anotherView addSubview:_lineLabel];
    
    if (self.isPortrait)
    {
        self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
        _lineLabel.hidden = YES;
    }else
    {
        self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
        _lineLabel.hidden = NO;
    }
    
    MmiaSpecialViewController *specialVC = [[MmiaSpecialViewController alloc]initWithUserId:_userId];
    specialVC.specialDelegate = self;
    specialVC.collectionInset = HeaderHeight;
    MmiaLikeViewController *likeVC = [[MmiaLikeViewController alloc]initWithUserId:_userId];
    likeVC.likeDelegate = self;
    likeVC.collectionInset = HeaderHeight;
    
    _contentOffsetY = -HeaderHeight;
    self.viewControllers = @[specialVC, likeVC];
    [self loadUI];
    
    [self getUserPersonalInfoRequest];
    _isLoadding = YES;
    [self getRecommendPerson:0];

}

#pragma mark - Private

- (void)loadUI
{
    _buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, HeaderHeight - 46, 600, ButtonHeight)];
    _buttonView.userInteractionEnabled = YES;
    _buttonView.backgroundColor = ColorWithHexRGB(0xebebeb);
    [self.headerView addSubview:_buttonView];
    
    NSArray *buttonTitleArr = [NSArray arrayWithObjects:@"专题", @"喜欢", nil];
    for (int i = 0; i < buttonTitleArr.count; i++)
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(55 + i * (90 + 400 / 2), 0, 400 / 2, ButtonHeight)];
        [button setTitle:[buttonTitleArr objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:ColorWithHexRGB(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:ColorWithHexRGB(0xd51024) forState:UIControlStateSelected];
        button.backgroundColor = [UIColor clearColor];
        [button.titleLabel setFont:UIFontBoldSystem(15)];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = SpecialButton_Tag + i;
        [_buttonView addSubview:button];
        [_buttonArr addObject:button];
    }
    
    UIButton *specialBtn = (UIButton *)[_buttonView viewWithTag:SpecialButton_Tag];
    [specialBtn setSelected:YES];
    self.selectedIndex = 0;
}

- (void)buttonClick:(UIButton *)button
{
    if ((button.tag == SpecialButton_Tag && self.selectedIndex != 0) || (button.tag == SpecialButton_Tag + 1 && self.selectedIndex != 1))
    {
        for (UIButton *btn in _buttonArr)
        {
            [btn setSelected:NO];
        }
        [button setSelected:YES];
        [self setSelectedIndex:(button.tag - SpecialButton_Tag)];
    }
}

- (void)refreshRecommendPersonWithDownNum:(NSInteger)downNum
{
    if( _isLoadding )
    {
        _isLoadding = NO;
    }
    if( _isRefresh )
    {
        [_tableView headerEndRefreshing];
        _isRefresh = NO;
    }
    else
    {
        [_tableView footerEndRefreshing];
    }
    [_tableView reloadData];
    
    if( downNum >= Request_Data_Count )
    {
        [self addRefreshFooter];
    }
    else
    {
        [self removeRefreshFooter];
    }
}

- (void)netWorkError:(NSError *)error
{
    if( _isLoadding )
    {
        _isLoadding = NO;
    }
    if( _isRefresh )
    {
        [_tableView headerEndRefreshing];
        _isRefresh = NO;
    }
    else
    {
        [_tableView footerEndRefreshing];
    }
}

//通知
- (void)doCollectionViewOffsetY:(NSNotification *)nc
{
    NSDictionary *infoDict = nc.userInfo;
    NSInteger offsetY = [[infoDict objectForKey:PersonHome_OffsetYInfoKey]integerValue];
    self.contentOffsetY = offsetY;
    
    [_buttonView removeFromSuperview];
    if (offsetY >= -ButtonHeight)
    {
        _buttonView.frame = CGRectMake(0, 0, self.contentView.width, ButtonHeight);
        [self.contentView addSubview:_buttonView];
    }else
    {
        _buttonView.frame = CGRectMake(0, self.headerView.height - ButtonHeight, self.contentView.width, ButtonHeight);
        [self.headerView addSubview:_buttonView];
    }
}

//页面选中跳转

- (void)insertIntoVcWithMagezieItem:(MagazineItem *)item IndexPath:(NSIndexPath *)indexPath InsertIntoType:(NSInteger)type
{
    MmiaDetailGoodsViewController *goodsVC = [[MmiaDetailGoodsViewController alloc]initWithMagezineItem:item IndexPath:indexPath];
    goodsVC.view.frame = self.view.bounds;
    goodsVC.enterType = type;
    self.rightStackViewController = goodsVC;
}

//登陆

- (void)loginSuccess
{
    [super loginSuccess];
    [self getUserPersonalInfoRequest];
    
    [self.personArr removeAllObjects];
    [self getRecommendPerson:0];
}

#pragma mark - add下拉上拉刷新

- (void)addRefreshFooter
{
    __block MmiaOtherPersonHomeViewController *homeVC = self;
    [self.tableView addFooterWithCallback:^{
        if(homeVC->_isLoadding )
            return;
        homeVC->_isRefresh = NO;
        homeVC->_isLoadding = YES;
        [homeVC getRecommendPerson:homeVC.personArr.count];
    }];
}

- (void)removeRefreshFooter
{
    if( ![_tableView isFooterHidden])
    {
        [_tableView removeFooter];
    }
}

#pragma mark - Request
//个人资料
- (void)getUserPersonalInfoRequest
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *userTicket = [defaults objectForKey:USER_TICKET];
    if (!userTicket)
    {
        userTicket = @"";
    }
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:_userId],@"userid",userTicket,@"ticket", nil];
    
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_PersonalInfo_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        if ([jsonDict[@"result"]intValue] == 0)
        {
            self.loginItem.userId = [jsonDict[@"id"]integerValue];
            self.loginItem.headImageUrl = jsonDict[@"headPicture"];
            self.loginItem.nikeName = jsonDict[@"nickName"];
            self.loginItem.sex = [jsonDict[@"sex"]integerValue];
            self.loginItem.signature = jsonDict[@"signature"];
            self.loginItem.email = jsonDict[@"email"];
            self.loginItem.userType = [jsonDict[@"userType"]integerValue];
            self.loginItem.fansNumber = [jsonDict[@"fansNumber"]integerValue];
            self.loginItem.focusPersonNumber = [jsonDict[@"focusPersonNumber"]integerValue];
            self.loginItem.isAttention = [jsonDict[@"isAttention"]integerValue];
            
            if ([jsonDict[@"userType"]intValue] == 1)
            {
                self.loginItem.website = jsonDict[@"website"];
                self.loginItem.homepage = jsonDict[@"homepage"];
                self.loginItem.industry = jsonDict[@"industry"];
                self.loginItem.workUnit = jsonDict[@"workUnit"];
            }
            [_headerView resetSubViewsWithDictionary:self.loginItem];
            
            if (self.loginItem.isAttention == 1)
            {
                [self.headerView.addConcernButton setImage:[UIImage imageNamed:@"personalcenter_followedicon.png"] forState:UIControlStateNormal];
            }else
            {
               [self.headerView.addConcernButton setImage:[UIImage imageNamed:@"personalcenter_plusicon.png"] forState:UIControlStateNormal];
            }
        }
        
    }errorHandler:^(NSError *error){
        
    }];
}

//推荐的用户
- (void)getRecommendPerson:(NSInteger)start
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userTicket = [defaults objectForKey:USER_TICKET];
    if (!userTicket) {
        userTicket = @"";
    }
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:userTicket, @"ticket", [NSNumber numberWithInteger:start],@"start", [NSNumber numberWithInteger:Request_Data_Count], @"size", nil];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_Recommend_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        if ([jsonDict[@"result"]integerValue] == 0)
        {
            NSInteger downNum = [jsonDict[@"num"] integerValue];
            NSArray *dataArr = jsonDict[@"data"];
            
            if (_isRefresh)
            {
                [self.personArr removeAllObjects];
            }
            
            for (NSDictionary *dict in dataArr)
            {
                MagazineItem *item = [[MagazineItem alloc]init];
                item.userId = [dict[@"id"]integerValue];
                item.aId = [dict[@"shareId"]integerValue];
                item.magazineId = [dict[@"productId"]integerValue];
                item.titleText = [dict objectForKey:@"name"];
                item.headImageUrl = [dict objectForKey:@"headPicture"];
                item.subTitle = [dict objectForKey:@"signature"];
                item.isAttention = [[dict objectForKey:@"isAttention"]integerValue];
                item.creatTime = [[dict objectForKey:@"newstShareTime"]doubleValue];
                item.pictureImageUrl = [dict objectForKey:@"pictureUrl"];
                item.imageWidth = [[dict objectForKey:@"width"]integerValue];
                item.imageHeight = [[dict objectForKey:@"height"]integerValue];
                [self.personArr addObject:item];
            }
            [self refreshRecommendPersonWithDownNum:downNum];
        }
    }errorHandler:^(NSError *error){
        
    }];
}

//关注某人
- (void)getFocusFollowSomeOneDataWithTargetUser:(UIButton *)button
                                  InNSIndexPath:(NSIndexPath *)indexPath
                                RequestInfoDict:(NSDictionary *)infoDict
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_FocusOne_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject){
        
        if ([jsonObject[@"result"] intValue]==0)
        {
            if (indexPath != nil)
            {
                [button setTitle:@"取消关注" forState:UIControlStateNormal];
                MagazineItem *item = [self.personArr objectAtIndex:indexPath.row];
                MagazineItem *newItem = item;
                newItem.isAttention = 1;
                [self.personArr replaceObjectAtIndex:indexPath.row withObject:newItem];
            }else
            {
                 [button setImage:[UIImage imageNamed:@"personalcenter_followedicon.png"] forState:UIControlStateNormal];
                self.loginItem.isAttention = 1;
                if (self.concernClickBlock)
                {
                    self.concernClickBlock(YES);
                }
            }
            [MmiaToast showWithText:@"关注成功" topOffset:Main_Screen_Height - 20 image:nil];
            
        }else
        {
           [MmiaToast showWithText:@"关注失败" topOffset:Main_Screen_Height - 20 image:nil];
        }
        
    }errorHandler:^(NSError *error){
       [MmiaToast showWithText:@"关注失败" topOffset:Main_Screen_Height - 20 image:nil];
    }];
}

//取消关注某人
- (void)getCancelFollowSomeOneDataWithTargetUser:(UIButton *)button
                                   InNSIndexPath:(NSIndexPath *)indexPath
                                RequestInfoDict:(NSDictionary *)infoDict
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [app.mmiaNetworkEngine startAsyncRequestWithUrl:Mmia_CancelOne_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonObject){
        
        if ([jsonObject[@"result"] intValue]==0)
        {
            if (indexPath != nil)
            {
                [button setTitle:@"关注" forState:UIControlStateNormal];
                 MagazineItem *item = [self.personArr objectAtIndex:indexPath.row];
                MagazineItem *newItem = item;
                newItem.isAttention = 0;
                [self.personArr replaceObjectAtIndex:indexPath.row withObject:newItem];

            }else
            {
                [button setImage:[UIImage imageNamed:@"personalcenter_plusicon.png"] forState:UIControlStateNormal];
                 self.loginItem.isAttention = 0;
                
                if (self.concernClickBlock)
                {
                    self.concernClickBlock(NO);
                }
            }
                [MmiaToast showWithText:@"取消关注成功" topOffset:Main_Screen_Height - 20 image:nil];
        }else
        {
           [MmiaToast showWithText:@"取消关注失败" topOffset:Main_Screen_Height - 20 image:nil];
        }
    }errorHandler:^(NSError *error){
       [MmiaToast showWithText:@"取消关注失败" topOffset:Main_Screen_Height - 20 image:nil];
    }];
}

#pragma mark * Overwritten setters

- (void)setViewControllers:(NSArray *)viewControllers
{
    if (_viewControllers != viewControllers)
    {
        _viewControllers = viewControllers;
    }
    for (UIViewController *viewController in viewControllers)
    {
        [viewController willMoveToParentViewController:self];       viewController.view.frame = self.contentView.bounds;
        
        [self.contentView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    for( UIViewController *viewController in self.viewControllers )
    {
        viewController.view.hidden = YES;
    }
    UIViewController* selVC = self.viewControllers[selectedIndex];
    selVC.view.hidden = NO;
    [self.view bringSubviewToFront:selVC.view];
    
    [self.headerView removeFromSuperview];
    
    CGPoint contentOffset = CGPointMake(0, self.contentOffsetY);
    if (selectedIndex == 0)
    {
        MmiaSpecialViewController *specialVC = (MmiaSpecialViewController *)[self.viewControllers objectAtIndex:0];
        if (self.contentOffsetY < -ButtonHeight)
        {
            [specialVC.specialCollectionView setContentOffset:contentOffset animated:NO];
        }else if (self.contentOffsetY >= -ButtonHeight && specialVC.specialCollectionView.contentOffset.y <= -ButtonHeight)
        {
            [specialVC.specialCollectionView setContentOffset:CGPointMake(0, -ButtonHeight) animated:NO];
        }
        [specialVC.specialCollectionView addSubview:self.headerView];
        
    }else if (selectedIndex == 1)
    {
        MmiaLikeViewController *likeVC = (MmiaLikeViewController *)[self.viewControllers objectAtIndex:1];
        if (self.contentOffsetY < -ButtonHeight)
        {
            [likeVC.likeCollectionView setContentOffset:contentOffset animated:NO];
        }else if (self.contentOffsetY >= -ButtonHeight && likeVC.likeCollectionView.contentOffset.y <= -ButtonHeight)
        {
            [likeVC.likeCollectionView setContentOffset:CGPointMake(0, -ButtonHeight) animated:NO];
        }
        [likeVC.likeCollectionView addSubview:self.headerView];
        
    }    _selectedIndex = selectedIndex;
}

#pragma mark - UIViewControllerRotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [_headerView resetFrame: CGRectMake(0, -HeaderHeight, self.contentView.width, HeaderHeight)];
    self.tableView.frame = CGRectMake(0, 0, self.anotherView.width, self.anotherView.height - 44);
    self.recommendView.frame = CGRectMake(0, 0, self.anotherView.width, 45);
    
    if (self.isPortrait)
    {
        _lineLabel.hidden = YES;
    }else
    {
        _lineLabel.hidden = NO;
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.isPortrait)
    {
        return 80;
    }else
    {
        return 200;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MagazineItem *item = [self.personArr objectAtIndex:indexPath.row];
    [self insertIntoVcWithMagezieItem:item IndexPath:indexPath InsertIntoType:3];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.personArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    MagazineItem *item = [self.personArr objectAtIndex:indexPath.row];
    
    if (self.isPortrait)
    {
        cell = (MmiaPersonPortraitCell *)[tableView dequeueReusableCellWithIdentifier:@"PortraitCell"];
        if (cell == nil)
        {
            cell = [[MmiaPersonPortraitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PortraitCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [((MmiaPersonPortraitCell *)cell).headImageView sd_setImageWithURL:[NSURL URLWithString:item.headImageUrl] placeholderImage:[UIImage imageNamed:@"personalcenter_DefaultPersonPic.png"]];
    }else
    {
        cell = (MmiaPersonLanscapeCell *)[tableView dequeueReusableCellWithIdentifier:@"LanscapeCell"];
        if (cell == nil)
        {
            cell = [[MmiaPersonLanscapeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LanscapeCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        ((MmiaPersonLanscapeCell *)cell).concernBlock = ^(UIButton *button)
        {
            
            if ([StandardUserDefaults boolForKey:USER_IS_LOGIN] == NO)
            {
                [super insertIntoLoginVC];
                return;
            }

            NSInteger userId = [[StandardUserDefaults objectForKey:USER_ID]integerValue];
            NSString *userTicket = [StandardUserDefaults objectForKey:USER_TICKET];
            if (!userTicket) {
                userTicket = @"";
            }
            NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:userId],@"myUserid", userTicket, @"ticket", [NSNumber numberWithInteger:item.userId], @"targetUserid", nil];
            
            if (item.isAttention == 1)
            {
                [self getCancelFollowSomeOneDataWithTargetUser:button InNSIndexPath:indexPath RequestInfoDict:dict];
            }else
            {
                [self getFocusFollowSomeOneDataWithTargetUser:button InNSIndexPath:indexPath RequestInfoDict:dict];
            }
        };

        [((MmiaPersonLanscapeCell *)cell).headImageView sd_setImageWithURL:[NSURL URLWithString:item.headImageUrl] placeholderImage:[UIImage imageNamed:@"personalcenter_DefaultPersonPic.png"]];
        ((MmiaPersonLanscapeCell *)cell).nikeNameLabel.text = item.titleText;
        ((MmiaPersonLanscapeCell *)cell).introduceLabel.text = item.subTitle;
        ((MmiaPersonLanscapeCell *)cell).timeLabel.text = [NSString distanceNowTime:item.creatTime];
        if (item.isAttention == 0)
        {
            [((MmiaPersonLanscapeCell *)cell).concernButton setTitle:@"关注" forState:UIControlStateNormal];
        }else
        {
            [((MmiaPersonLanscapeCell *)cell).concernButton setTitle:@"取消关注" forState:UIControlStateNormal];
        }
    }
    return cell;
}

#pragma mark - MmiaSpecialViewControllerDelagate

- (void)specialVCCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MmiaSpecialViewController *specialVC = (MmiaSpecialViewController *)[self.viewControllers objectAtIndex:0];
    MagazineItem *item = [specialVC.dataArr objectAtIndex:indexPath.row];
    
    MmiaDetailSpecialViewController *detailVC = [[MmiaDetailSpecialViewController alloc]initWithUserId:_userId Item:item];
    detailVC.view.frame = self.view.bounds;
    self.rightStackViewController = detailVC;
}

#pragma mark - MmiaLikeViewControllerDelagate

- (void)likeVCCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MmiaLikeViewController *likeVC = (MmiaLikeViewController *)[self.viewControllers objectAtIndex:1];
    MagazineItem *item = [likeVC.dataArr objectAtIndex:indexPath.row];
  [self insertIntoVcWithMagezieItem:item IndexPath:indexPath InsertIntoType:0];
}

#pragma mark - MMiaPersonHomeViewDelegate

- (void)addConcernPerson:(UIButton *)button
{
    if ([StandardUserDefaults boolForKey:USER_IS_LOGIN] == NO)
    {
        [super insertIntoLoginVC];
        return;
    }
    NSInteger userId = [[StandardUserDefaults objectForKey:USER_ID]integerValue];
    NSString *userTicket = [StandardUserDefaults objectForKey:USER_TICKET];
    if (!userTicket) {
        userTicket = @"";
    }
     NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:userId],@"myUserid", userTicket,@"ticket", [NSNumber numberWithLong:_userId],@"targetUserid", nil];
    
    if (self.loginItem.isAttention == 1)
    {
        [self getCancelFollowSomeOneDataWithTargetUser:button InNSIndexPath:nil RequestInfoDict:dict];
    }else
    {
        [self getFocusFollowSomeOneDataWithTargetUser:button InNSIndexPath:nil RequestInfoDict:dict];
    }
}
- (void)dealloc
{
    [DefaultNotificationCenter removeObserver:self name:OtherHomeOffset_Notification_Key  object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
