//
//  MyCustomTabBarController.m
//  MMIA
//
//  Created by yhx on 14-7-2.
//
//

#import <AVFoundation/AVFoundation.h>
#import "MyCustomTabBarController.h"
#import "MMiaMainViewController.h"
#import "MMiaTabLikeViewController.h"
#import "MMIASettingViewController.h"
#import "MMIALoginViewController.h"
#import "MMIAPersonalHomePageViewController.h"
#import "MMiaInningMagezineViewController.h"
#import "MMIToast.h"
#import "MMiaCategroyViewController.h"

@interface MyCustomTabBarController (){
    UIImagePickerController *_ipc;
    MyCustomTabBarMainVIew *_mainView;
    NSArray  *_loginArr;
    NSArray  *_quitArr;
    NSInteger      _selectButtonTag;
    BOOL     _likeVCRefresh;
    BOOL     _homeVCRefresh;
}

@end

@implementation MyCustomTabBarController

- (id)init
{
    self = [super init];
    if (self)
    {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mamabangRefreshed:) name:@"MamabangRefreshed" object:nil];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBarHidden)
        [self.navigationController setNavigationBarHidden:YES animated:YES];
   _mainView=[[MyCustomTabBarMainVIew alloc]initWithLoseScopeHeight:CGRectGetHeight( _tabBarBg.frame)];
    _mainView.delegate=self;
    [_mainView.alertWindow1 makeKeyAndVisible];
    _mainView.alertWindow1.hidden=YES;
    
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _btnArr = [NSMutableArray array];
    
    _tabBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height - 45, self.view.frame.size.width, 45)];
    _tabBarBg.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    _tabBarBg.image = [UIImage imageNamed:@"菜单条.png"];
//    _tabBarBg.backgroundColor=UIColorFromRGB(0xF4F4F4);
    _tabBarBg.clipsToBounds = NO;
    _tabBarBg.userInteractionEnabled = YES;
    [self.view addSubview:_tabBarBg];
    
    UIButton* mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mainBtn.tag = 0;
    mainBtn.frame = CGRectMake(0, 0, 64, 45);
    mainBtn.center = CGPointMake(32, 45/2);
    [mainBtn setShowsTouchWhenHighlighted:YES];
    [mainBtn setImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    [mainBtn setImage:[UIImage imageNamed:@"home_red.png"] forState:UIControlStateSelected];
    [mainBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_tabBarBg addSubview:mainBtn];
    [_btnArr addObject:mainBtn];
    
    UIButton* classBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   classBtn.tag = 1;
    classBtn.frame = CGRectMake(64, 0, 64, 45);
    classBtn.center = CGPointMake(32 + 64, 45/2);
    [classBtn setShowsTouchWhenHighlighted:YES];
    [classBtn setImage:[UIImage imageNamed:@"class.png"] forState:UIControlStateNormal];
    [classBtn setImage:[UIImage imageNamed:@"class_red.png"] forState:UIControlStateSelected];
    [classBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_tabBarBg addSubview:classBtn];
    [_btnArr addObject:classBtn];
    
    
    //lx add
    UIButton* centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    centerBtn.tag = 4;
    centerBtn.frame = CGRectMake(64, 0, 64, 45);
    centerBtn.center = CGPointMake(32 + 64*2, 45/2);
    [centerBtn setShowsTouchWhenHighlighted:YES];
    [centerBtn setImage:[UIImage imageNamed:@"center.png"] forState:UIControlStateNormal];
//    [centerBtn setImage:[UIImage imageNamed:@"center_select.png"] forState:UIControlStateSelected];
    [centerBtn addTarget:self action:@selector(centerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_tabBarBg addSubview:centerBtn];
   
    
    
    UIButton* likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    likeBtn.tag = 2;
    likeBtn.frame = CGRectMake(80 * 2, 0, 80, 45);
    likeBtn.center = CGPointMake(32 +64 * 3, 45/2);
    [likeBtn setShowsTouchWhenHighlighted:YES];
    [likeBtn setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
    [likeBtn setImage:[UIImage imageNamed:@"like_red.png"] forState:UIControlStateSelected];
    [likeBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_tabBarBg addSubview:likeBtn];
    [_btnArr addObject:likeBtn];
    
    UIButton* setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.tag = 3;
    setBtn.frame = CGRectMake(80 * 3, 0, 80, 45);
    setBtn.center = CGPointMake(32 + 64 * 4, 45/2);
    [setBtn setShowsTouchWhenHighlighted:YES];
    [setBtn setImage:[UIImage imageNamed:@"my.png"] forState:UIControlStateNormal];
    [setBtn setImage:[UIImage imageNamed:@"my_red.png"] forState:UIControlStateSelected];
    [setBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_tabBarBg addSubview:setBtn];
    [_btnArr addObject:setBtn];
    
    // 首页
    MMiaMainViewController* mmiaVC = [[MMiaMainViewController alloc] initWithNibName:@"MMiaMainViewController" bundle:nil];
    UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:mmiaVC];
    nav1.navigationBar.barStyle = UIBarStyleBlack;
    nav1.navigationBar.translucent = YES;
    
    // 类目页
    MMiaCategroyViewController *categroyVC = [[MMiaCategroyViewController alloc]init];
    UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:categroyVC];
    nav2.navigationBar.barStyle = UIBarStyleBlack;
    nav2.navigationBar.translucent = NO;
    
    // 喜欢页
     MMiaTabLikeViewController *likeVC=[[MMiaTabLikeViewController alloc]init];
     UINavigationController *nav3=[[UINavigationController alloc]initWithRootViewController:likeVC];
     nav3.navigationBar.barStyle=UIBarStyleBlack;
     nav3.navigationBar.translucent = NO;
    
    // 个人中心
    MMIAPersonalHomePageViewController *homeVC = [[MMIAPersonalHomePageViewController alloc] init];
    UINavigationController* nav4 = [[UINavigationController alloc] initWithRootViewController:homeVC];
    nav4.navigationBar.barStyle = UIBarStyleBlack;
    nav4.navigationBar.translucent = NO;
     NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:PERSON_HOME_HAVE];
    [defaults setBool:NO forKey:PERSON_LIKE_HAVE];
    [defaults synchronize];
    [self setViewControllers:[NSArray arrayWithObjects:nav1, nav2, nav3, nav4, nil]];

    nav1.view.frame = self.view.bounds;
    nav2.view.frame = self.view.bounds;
    nav3.view.frame = self.view.bounds;
    nav4.view.frame = self.view.bounds;
    
    [self hideTabBar];
    mainBtn.selected = YES;
    
//    [self.tabBar removeFromSuperview];
//    [self.tabBar addSubview:_tabBarBg];
    
//    if (!iOS7)
//    {
//        [self buttonTapped:hisBtn];
//        [self performSelector:@selector(switchToFirst) withObject:nil afterDelay:0.001];
    
//    }
    }

- (void)buttonTapped:(UIButton*)btn
{
    _selectButtonTag = btn.tag;
    // 隐藏centerButton
    UIButton *centerButton = (UIButton *)[_tabBarBg viewWithTag:4];
    if (centerButton.isSelected)
    {
        _mainView.alertWindow1.hidden=YES;
        [centerButton setSelected:NO];
    }
    
    UINavigationController* nav = self.viewControllers[self.selectedIndex];
    
    if( self.selectedIndex == 0 && _selectButtonTag == 0 )
    {
        // 选中状态下再次点击TabBar，刷新首页内容操作，无loading状态
        MMiaMainViewController* mainVC = [[nav viewControllers] firstObject];
        [mainVC refreshPage:nil];
        return;
    }
    if( _selectButtonTag == 2 || _selectButtonTag == 3 )
    {
        // 登录状态
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL isLogin = [defaults boolForKey:USER_IS_LOGIN];
        if( !(isLogin && [defaults objectForKey:USER_ID] && [defaults objectForKey:USER_TICKET]) )
        {
            MMIALoginViewController* loginVC = [[MMIALoginViewController alloc] init];
            [loginVC setTarget:self withSuccessAction:@selector(logonSuccess) withRegisterAction:@selector(registerSuccess)];

            [nav pushViewController:loginVC animated:YES];
            
            return;
        }
    }
    
    for (UIButton* btn in _btnArr)
    {
        [btn setSelected:NO];
    }
    [btn setSelected:YES];
    [self setSelectedIndex:btn.tag];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UINavigationController* nav1 = [self viewControllers][_selectButtonTag];
    
    if( _selectButtonTag == 2 && _likeVCRefresh )
    {
        if( [defaults boolForKey:PERSON_LIKE_HAVE] )
        {
            MMiaTabLikeViewController* likeVC = [[nav1 viewControllers] firstObject];
            [likeVC refreshLikeData];
        }
        _likeVCRefresh = NO;
    }
    
    if( _selectButtonTag == 3  && _homeVCRefresh )
    {
        if( [defaults boolForKey:PERSON_HOME_HAVE] )
        {
            MMIAPersonalHomePageViewController* homeVC = [[nav1 viewControllers] firstObject];
            [homeVC selectSendRequest];
        }
        _homeVCRefresh = NO;
    }
}

- (void)logonSuccess
{
    UINavigationController* curVC = self.viewControllers[self.selectedIndex];
    [curVC popViewControllerAnimated:NO];
    
    _likeVCRefresh = YES;
    _homeVCRefresh = YES;
    
   [self buttonTapped:_btnArr[_selectButtonTag]];
   }

- (void)registerSuccess
{
    UINavigationController* curVC = self.viewControllers[self.selectedIndex];
    [curVC popViewControllerAnimated:NO];
    [self logonSuccess];
}

-(void)centerButtonClick:(UIButton *)button
{
//    if (button.isSelected)
//    {
//        _mainView.alertWindow1.hidden=YES;
//        [button setSelected:NO];
//    }
//    else
//    {
        UINavigationController* nav = self.viewControllers[self.selectedIndex];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL isLogin = [defaults boolForKey:USER_IS_LOGIN];
        if( !(isLogin && [defaults objectForKey:USER_ID] && [defaults objectForKey:USER_TICKET]) )
        {
            MMIALoginViewController* loginVC = [[MMIALoginViewController alloc] init];
            [loginVC setTarget:self withSuccessAction:@selector(logonSuccess) withRegisterAction:@selector(registerSuccess)];
            
            [nav pushViewController:loginVC animated:YES];
            return;
        }
    
        _mainView.alertWindow1.hidden=NO;
//        [button setSelected:YES];
//    }
}


- (void)hideTabBar
{
	for(UIView *view in self.view.subviews)
	{
		if([view isKindOfClass:[UITabBar class]])
		{
			view.hidden = YES;
		}
        else if ([view isKindOfClass:NSClassFromString(@"UITransitionView")])
        {
            view.frame = self.view.bounds;
        }
	}
}

- (void)hideOrNotCustomTabBar:(BOOL)hidden
{
    _tabBarBg.hidden = hidden;
}

- (void)switchToFirst
{
    [self buttonTapped:_btnArr[0]];
}

- (void)switchToLast
{
    [self buttonTapped:_btnArr[3]];
    
}

-(void)setHomeVC
{
    [self setViewControllers:_loginArr];
}
-(void)setLoginVC
{
    [self setViewControllers:_quitArr];
}

#pragma mark - MyCustomTabBarMainVIewDelegate
-(void)tapCenterButtonImageView:(UIImageView *)imageView inView:(MyCustomTabBarMainVIew *)view
{
   // [_mainView dismissTabBarMainView];
  
   
    if (!_ipc)
    {
         UIImagePickerController *pc=[[UIImagePickerController alloc]init];
        pc.delegate=self;
       pc.allowsEditing=YES;
        _ipc=pc;
    }
   
    
    UIButton *centerButton=(UIButton *)[_tabBarBg viewWithTag:4];
    [centerButton setSelected:NO];
      UINavigationController* curVC = self.viewControllers[self.selectedIndex];
    if (imageView.tag==1) {
        _ipc.sourceType=UIImagePickerControllerSourceTypeCamera;
        [curVC presentViewController:_ipc animated:YES completion:^{
            BOOL isCameraValid = YES;
            if (iOS7)
            {
                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus != AVAuthorizationStatusAuthorized)
                {
                    isCameraValid = NO;
                }
            }
            if (isCameraValid==NO)
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"请在iPhone的“设置-隐私-相机”选项中，允许广而告之访问你的相机。" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
                
            }

            
        }];
      
      
        
    }
    if (imageView.tag==2) {
    UIImagePickerController    *pc=[[UIImagePickerController alloc]init];
        pc.delegate=self;
        pc.allowsEditing=YES;
       pc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:pc animated:YES completion:nil];
        }

   _mainView.alertWindow1.hidden=YES;
    
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    [_mainView dismissTabBarMainView];
      MMiaInningMagezineViewController *inMagezineVC=[[MMiaInningMagezineViewController alloc]initWithImage:image imgId:0];
      UINavigationController* curVC = self.viewControllers[self.selectedIndex];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [curVC pushViewController:inMagezineVC animated:YES];
    
 
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    if ([picker respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else if ([picker respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}
#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [_ipc dismissViewControllerAnimated:YES completion:nil];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
