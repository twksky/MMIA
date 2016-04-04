//
//  MMiaConcernViewController.m
//  MMIA
//
//  Created by lixiao on 14-9-18.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import "MMiaConcernViewController.h"
#import "MMiaConcernPersonViewController.h"
#import "MMiaConcernMagezineViewController.h"
#import "MagezineItem.h"
#import "MMiaConcernPersonHomeViewController.h"
#import "MMiaDetailSpecialViewController.h"

#define kButtonHorizontalMargin 10
#define kButtonTopHeight        30

@interface MMiaConcernViewController ()
{
    UIView         *_topBarView;
    NSMutableArray *_buttonArr;
    NSInteger      _userId;
}

@property (readonly, assign, nonatomic) CGFloat viewControlWidth;
@property (readonly, assign, nonatomic) CGFloat viewControlHeight;

- (void)setUp;
- (void)loadNavView;
- (void)addTopButtonView;

@end

@implementation MMiaConcernViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self setUp];
    }
    return self;
}


-(id)initWithUserId:(NSInteger)userId
{
    self = [super init];
    if (self)
    {
        _userId = userId;
    }
    return self;
}
- (void)setUp
{
    _topBarViewHeight = 40;
    _topBarButtonFont = [UIFont systemFontOfSize:15];
    _buttonTitleColor = [UIColor blackColor];
    _selectedButtonTitleColor = [UIColor whiteColor];
    
    _buttonArr = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:YES];
    
    for( UIViewController *viewController in self.viewControllers )
    {
        [viewController viewWillAppear:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNavView];
    [self addTopButtonView];
    
   MMiaConcernPersonViewController *personVC=[[MMiaConcernPersonViewController alloc]init];
    personVC.userId=_userId;
    personVC.delegate=self;
    personVC.view.frame = CGRectMake(0,  CGRectGetMaxY(_topBarView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(_topBarView.frame));
    MMiaConcernMagezineViewController *mageZineVC=[[MMiaConcernMagezineViewController alloc]init];
    mageZineVC.delegate=self;
    mageZineVC.userId=_userId;
    mageZineVC.view.frame = CGRectMake(0, CGRectGetMaxY(_topBarView.frame), VIEW_OFFSET + CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(_topBarView.frame));
    self.viewControllers=@[personVC,mageZineVC];
}

- (void)loadNavView
{
    [self setTitleString:@"关注"];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height-1, self.navigationView.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xA6A6A6);
    [self.navigationView addSubview:lineView];
    [self addBackBtnWithTarget:self selector:@selector(btnClick:)];
    self.view.backgroundColor = UIColorFromRGB(0xE1E1E1);
}

#pragma mark - Private

- (void)btnClick:(UIButton *)button
{
    if( button.tag == 1001 )
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)addTopButtonView
{
    _topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_OFFSET + kNavigationBarHeight, CGRectGetWidth(self.view.bounds), self.topBarViewHeight)];
    _topBarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_topBarView];
    
    UIButton* _personalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _personalButton.backgroundColor = [UIColor clearColor];
    _personalButton.tag = 0;

    [_personalButton setBackgroundImage:[[UIImage imageNamed:@"concern_left.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:16] forState:UIControlStateNormal];
    [_personalButton setBackgroundImage:[[UIImage imageNamed:@"concern_left_select.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:16] forState:UIControlStateSelected];
    [_personalButton setTitle:@"关注的人" forState:UIControlStateNormal];
    [_personalButton setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
    [_personalButton setTitleColor:self.selectedButtonTitleColor forState:UIControlStateSelected];
    _personalButton.titleLabel.font = self.topBarButtonFont;
    _personalButton.frame = CGRectMake(kButtonHorizontalMargin, (CGRectGetHeight(_topBarView.bounds) - kButtonTopHeight)/2, (CGRectGetWidth(_topBarView.bounds) - 2 * kButtonHorizontalMargin)/2, kButtonTopHeight);
    [_personalButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_topBarView addSubview:_personalButton];
    [_buttonArr addObject:_personalButton];
    
    UIButton* _specialButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _specialButton.backgroundColor = [UIColor clearColor];
    _specialButton.tag = 1;
    [_specialButton setBackgroundImage:[[UIImage imageNamed:@"concern_right.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:16] forState:UIControlStateNormal];
    [_specialButton setBackgroundImage:[[UIImage imageNamed:@"concern_right_select.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:16] forState:UIControlStateSelected];
    [_specialButton setTitle:@"关注的专题" forState:UIControlStateNormal];
    [_specialButton setTitleColor:self.buttonTitleColor forState:UIControlStateNormal];
    [_specialButton setTitleColor:self.selectedButtonTitleColor forState:UIControlStateSelected];
    _specialButton.titleLabel.font = self.topBarButtonFont;
    _specialButton.frame = CGRectMake(CGRectGetMaxX(_personalButton.frame), CGRectGetMinY(_personalButton.frame), CGRectGetWidth(_personalButton.bounds), kButtonTopHeight);
    [_specialButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_topBarView addSubview:_specialButton];
    [_buttonArr addObject:_specialButton];
}

- (void)buttonTapped:(UIButton*)button
{
    for( UIButton* btn in _buttonArr )
    {
        [btn setSelected:NO];
        btn.userInteractionEnabled = YES;
    }
    [button setSelected:YES];
    button.userInteractionEnabled = NO;
    self.selectedIndex = button.tag;
}

#pragma mark * Overwritten setters

- (void)setViewControllers:(NSArray *)viewControllers
{
    if( _viewControllers != viewControllers )
    {
        _viewControllers = viewControllers;
        
        for( UIViewController *viewController in viewControllers )
        {
            [viewController willMoveToParentViewController:self];
            viewController.view.frame = CGRectMake(0., CGRectGetMaxY(_topBarView.frame), self.viewControlWidth, self.viewControlHeight);
            [self.view addSubview:viewController.view];
            [viewController didMoveToParentViewController:self];
        }
        UIButton* btn = (UIButton *)_buttonArr[0];
        [btn setSelected:YES];
        btn.userInteractionEnabled = NO;
        self.selectedIndex = btn.tag;
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
}

- (CGFloat)viewControlWidth
{
    return CGRectGetWidth(self.view.frame);
}

- (CGFloat)viewControlHeight
{
    return CGRectGetHeight(self.view.frame) - CGRectGetMaxY(_topBarView.frame);
}
#pragma mark -MMiaConcernPersonViewControllerDelegate
- (void)didSelectItemAtConcernPerson:(MMiaConcernPersonViewController *)concernPerson indexPath:(NSIndexPath *)indexPath
{
    MagezineItem *item=[concernPerson.dataArray objectAtIndex:indexPath.row];
    MMiaConcernPersonHomeViewController *personHomeVC=[[MMiaConcernPersonHomeViewController alloc]initWithUserid:item.userId];

    personHomeVC.funsBlock=^(int follow){
        for (UIViewController *vc in self.viewControllers)
        {
            if ([vc isKindOfClass:[MMiaConcernPersonViewController class]])
            {
                [(MMiaConcernPersonViewController *)vc doReturnBlock:follow indexPath:indexPath];
                
            }
        }
    };

    [self.navigationController pushViewController:personHomeVC animated:YES];
    
}

#pragma mark -MMiaConcernMagezineViewControllerDelegate
-(void)didSelectItemAtConcernMagezine:(MMiaConcernMagezineViewController *)concernMagezine indexPath:(NSIndexPath *)indexPath
{
   MagezineItem *item=[concernMagezine.dataArray objectAtIndex:indexPath.row];
    MMiaDetailSpecialViewController *despVC=[[MMiaDetailSpecialViewController alloc]initWithTitle:item.title MagazineId:item.aId UserId:item.userId isAttention:item.likeNum];
    despVC.magezineBlock=^(int concern){
        for (UIViewController *vc in self.viewControllers) {
            if ([vc isKindOfClass:[MMiaConcernMagezineViewController class]])
            {
                [(MMiaConcernMagezineViewController *)vc doReturnConcernMagezineBlock:concern indexPath:indexPath];
            }
        }
    };
    despVC.isNotEdit=YES;
    despVC.isAttention=item.type;
    [self.navigationController pushViewController:despVC animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
