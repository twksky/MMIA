//
//  MMiaSearchViewController.m
//  MMIA
//
//  Created by lixiao on 15/1/9.
//  Copyright (c) 2015年 com.zixun. All rights reserved.
//

#import "MMiaSearchViewController.h"
#import "MMiaSearchPageContainer.h"
#import "MMiaSearchGoodsViewController.h"
#import "MMiaSearchShopViewController.h"
#import "MMIToast.h"
#import "MagezineItem.h"
#import "MMiaDetailGoodsViewController.h"
#import "MMiaConcernPersonHomeViewController.h"
#import "MMIALoginViewController.h"

static const CGFloat Search_Image_Margin = 10;

@interface MMiaSearchViewController ()<UITextFieldDelegate,MMiaSearchGoodsViewControllerDelegate,MMiaSearchShopViewControllerDelegate>{
    int _userId;
    NSString *_keyWord;
    UITextField  *_searchTextFiled;
}
@property(nonatomic, retain) MMiaSearchPageContainer *searchPageContainer;
@property (nonatomic, assign) CGFloat topHeaderHeight;
@end

@implementation MMiaSearchViewController

#pragma mark - inint
-(id)initWithUserid:(int)userId keyword:(NSString *)keyword
{
    self = [super init];
    if (self)
    {
        _userId = userId;
        _keyWord = keyword;
    }
    return self;
    
}

-(MMiaSearchPageContainer *)searchPageContainer
{
    if (!_searchPageContainer)
    {
        _searchPageContainer = [[MMiaSearchPageContainer alloc] init];
        [_searchPageContainer willMoveToParentViewController:self];
        _searchPageContainer.view.frame = CGRectMake(0, VIEW_OFFSET + 44, App_Frame_Width, Main_Screen_Height - VIEW_OFFSET -44);
        _searchPageContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _searchPageContainer.topBarHeight = 29;
        [self.view addSubview:_searchPageContainer.view];
        [_searchPageContainer didMoveToParentViewController:self];
    }
    return _searchPageContainer;
}
#pragma mark - View life cycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.searchPageContainer viewWillAppear:YES];
    for( UIViewController *viewController in self.searchPageContainer.viewControllers )
    {
        [viewController viewWillAppear:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadNavView];
    self.topHeaderHeight = 29;
    MMiaSearchGoodsViewController *goodsVc = [[MMiaSearchGoodsViewController alloc]initWithUserid:_userId];
    goodsVc.goodsKeyWord = _keyWord;
    goodsVc.delegate = self;
    goodsVc.title = @"商品";
    goodsVc.view.frame = CGRectMake(0, CGRectGetMinY(self.searchPageContainer.view.frame)+self.topHeaderHeight, App_Frame_Width, CGRectGetHeight(self.searchPageContainer.view.frame)-self.topHeaderHeight);
   // [MMiaLoadingView showLoadingForView:goodsVc.view];
   
    MMiaSearchShopViewController *shopVc = [[MMiaSearchShopViewController alloc]init];
    shopVc.userid = _userId;
    shopVc.shopKeyWord = _keyWord;
    shopVc.delegate = self;
    shopVc.title = @"商家";
    shopVc.view.frame = CGRectMake(0, CGRectGetMinY(self.searchPageContainer.view.frame)+self.topHeaderHeight, App_Frame_Width, CGRectGetHeight(self.searchPageContainer.view.frame)-self.topHeaderHeight);
    self.searchPageContainer.viewControllers = @[goodsVc,shopVc];

}
#pragma mark - loadUI
-(void)loadNavView
{
    [self setNaviBarViewBackgroundColor: UIColorFromRGB(0x393b49)];
    [self addNewBackBtnWithTarget:self selector:@selector(buttonClick:)];
    [self addNewRightBtnWithImage:[UIImage imageNamed:@"searchresultpage_searchbutton.png"] Target:self selector:@selector(buttonClick:)];
    _searchTextFiled=[[UITextField alloc]init];
    _searchTextFiled.frame = CGRectMake((CGRectGetWidth(self.navigationView.frame)-App_Frame_Width+100)/2, (kNavigationBarHeight-32)/2 + VIEW_OFFSET, App_Frame_Width-100, 32);
    _searchTextFiled.layer.cornerRadius = 15;
    _searchTextFiled.delegate=self;
    UIColor *placeHolerColcor=UIColorFromRGB(0x969696);
    _searchTextFiled.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"搜索你喜欢的商品或商家" attributes:@{NSForegroundColorAttributeName: placeHolerColcor}];
    _searchTextFiled.text = _keyWord;
    _searchTextFiled.font = [UIFont boldSystemFontOfSize:13];
    _searchTextFiled.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
    _searchTextFiled.textColor = UIColorFromRGB(0x969696);
    _searchTextFiled.backgroundColor=[UIColor whiteColor];
    _searchTextFiled.clearButtonMode=UITextFieldViewModeAlways;
     _searchTextFiled.leftViewMode=UITextFieldViewModeAlways;
    _searchTextFiled.returnKeyType= UIReturnKeySearch;
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0,0, 15, 15)];
    leftView.backgroundColor=[UIColor clearColor];
    _searchTextFiled.leftView = leftView;
    [self.navigationView addSubview:_searchTextFiled];
    
}
#pragma mark - btnClick
-(void)buttonClick:(UIButton *)button
{
    if (button.tag == 1003)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (button.tag == 1004)
    {
        [_searchTextFiled resignFirstResponder];
        [self doSearchClick];
    }
    
}


#pragma mark - searchClick
-(void)doSearchClick
{
    NSInteger newLength=[_searchTextFiled.text length];
    NSString *newStr;
    if (newLength!=0)
    {
        newStr=[_searchTextFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        newLength=newStr.length;
    }
    if (newLength==0)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入关键字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }

    if ([self.delegate respondsToSelector:@selector(clickSearchKeyWord:)])
    {
        [self.delegate clickSearchKeyWord:_searchTextFiled.text];
    }
    MMiaSearchGoodsViewController *goodsVc = [self.searchPageContainer.viewControllers objectAtIndex:0];
    if (goodsVc.isLoadding)
    {
        return;
    }
    goodsVc.isLoadding = YES;
    [MMiaLoadingView showLoadingForView:goodsVc.view];
    goodsVc.goodsKeyWord = _searchTextFiled.text;
    [goodsVc.goodsDataArr removeAllObjects];
    [goodsVc.collectionView reloadData];
    goodsVc.nodataView.hidden = YES;
    [goodsVc getGoodsDataByRequest:0];
    
    MMiaSearchShopViewController *shopVc = [self.searchPageContainer.viewControllers objectAtIndex:1];
   shopVc.isLoadding = YES;
    [MMiaLoadingView showLoadingForView:shopVc.view];
    shopVc.shopKeyWord = _searchTextFiled.text;
    [shopVc.shopArray removeAllObjects];
    [shopVc.tableView reloadData];
    shopVc.nodataView.hidden = YES;
    [shopVc getShopDataByRequest:0];

}


#pragma mark - TextFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger newLength=[textField.text length];
    NSString *newStr;
    if (newLength!=0)
    {
        newStr=[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        newLength=newStr.length;
    }
    if (newLength==0)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入关键字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    _searchTextFiled.text = textField.text;
    [self doSearchClick];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - MMiaSearchGoodsViewControllerDelegate
-(void)searchGoodsScrollViewDidScroll
{
    [_searchTextFiled resignFirstResponder];
}

-(void)viewController:(MMiaSearchGoodsViewController *)viewController didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem* item = [viewController.goodsDataArr objectAtIndex:indexPath.item];
    MMiaDetailGoodsViewController *detailGoodsVC=[[MMiaDetailGoodsViewController alloc]initWithTitle:item.title Id:item.aId goodsImage:item.pictureImageUrl Width:item.imageWidth Height:item.imageHeight price:item.imgPrice productId:item.magazineId];
    [self.navigationController pushViewController:detailGoodsVC animated:YES];
}

#pragma mark - MMiaSearchShopViewControllerDelegate
-(void)searchShopScrollViewDidScroll
{
    [_searchTextFiled resignFirstResponder]; 
}
-(void)viewController:(MMiaSearchShopViewController *)viewController didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     MagezineItem *item=[viewController.shopArray objectAtIndex:indexPath.row];
    MMiaConcernPersonHomeViewController *concernVC=[[MMiaConcernPersonHomeViewController alloc]initWithUserid:item.userId];
    concernVC.funsBlock=^(int follow){
        //        if (follow==1) {
        //            MagezineItem *newItem=item;
        //            newItem.likeNum=1;
        //            [self.shopArray replaceObjectAtIndex:indexPath.row withObject:newItem];
        //        }else if (follow==-1)
        //        {
        //            MagezineItem *newItem=item;
        //            newItem.likeNum=0;
        //            [self.shopArray replaceObjectAtIndex:indexPath.row withObject:newItem];
        //        }
        //        [self.tableView reloadData];
        if (viewController.isLoadding)
        {
            return ;
        }
        viewController.isLoadding = YES;
        viewController.isRefresh = YES;
        [MMiaLoadingView showLoadingForView:viewController.view];
        [viewController getShopDataByRequest:0];
    };
    [self.navigationController pushViewController:concernVC animated:YES];
}

-(void)doLogin
{
           MMIALoginViewController* loginVC = [[MMIALoginViewController alloc] init];
           [loginVC setTarget:self withSuccessAction:@selector(logonSuccess) withRegisterAction:@selector(registerSuccess)];
           [self.navigationController pushViewController:loginVC animated:YES];
   
            return;
    
}

-(void)logonSuccess
{
    [self.navigationController popViewControllerAnimated:YES];
     MMiaSearchShopViewController *shopVc = [self.searchPageContainer.viewControllers objectAtIndex:1];
    if (shopVc.isLoadding)
    {
        return;
    }
    [shopVc.shopArray removeAllObjects];
    [shopVc.tableView reloadData];
    shopVc.isLoadding = YES;
    [MMiaLoadingView showLoadingForView:shopVc.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    int userId=[[defaults objectForKey:USER_ID]intValue];
    shopVc.userid=userId;
    shopVc.tableView.scrollEnabled=NO;
    [shopVc getShopDataByRequest:0];
    
}
-(void)registerSuccess
{
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController popViewControllerAnimated:YES];
     MMiaSearchShopViewController *shopVc = [self.searchPageContainer.viewControllers objectAtIndex:1];
    if (shopVc.isLoadding)
    {
        return;
    }
    [shopVc.shopArray removeAllObjects];
    [shopVc.tableView reloadData];
    shopVc.isLoadding = YES;
    [MMiaLoadingView showLoadingForView:shopVc.view];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    int userId=[[defaults objectForKey:USER_ID]intValue];
    shopVc.userid=userId;
    [shopVc getShopDataByRequest:0];
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
