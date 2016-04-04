//
//  MmiaBaseViewController.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-3-27.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaBaseViewController.h"
#import "UIViewController+StackViewController.h"
#import "MmiaCategoryViewController.h"
#import "MmiaSearchListViewController.h"
#import "MmiaLoginViewController.h"
#import "MmiaPersonalHomeViewController.h"

@interface MmiaBaseViewController () <UITextFieldDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) UITextField*         searchTextFiled;
@property (nonatomic, strong) UIPopoverController* categoryPopoverController;
@property (nonatomic, strong) UIPopoverController* searchPopoverController;

- (void)searchHistoryWriteToFile;
- (void)showSearchPopoverController;

@end

@implementation MmiaBaseViewController

#pragma mark - getter functions

- (UIPopoverController *)categoryPopoverController
{
    if( !_categoryPopoverController )
    {
        // CategoryViewController
        NSMutableArray* categoryArr = [NSKeyedUnarchiver unarchiveObjectWithFile:[GlobalFunction directoryPathWithFileName:CATEGROY_KEY]];
        
        MmiaCategoryViewController* categoryViewController = [[MmiaCategoryViewController alloc] init];
        categoryViewController.dataArray = categoryArr                                                                                                                 ;
        
        // UINavigationController
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:categoryViewController];
        [navigation.navigationBar setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          UIFontSystem(14), NSFontAttributeName,
          [UIColor blackColor], NSForegroundColorAttributeName, nil]];
        
        // UIPopoverController
        _categoryPopoverController = [[UIPopoverController alloc] initWithContentViewController:navigation];
    }
    return _categoryPopoverController;
}

- (UIPopoverController *)searchPopoverController
{
    if( !_searchPopoverController )
    {
        NSMutableArray* historyArr = [NSMutableArray arrayWithContentsOfFile:[GlobalFunction directoryPathWithFileName:SEARCH_HISTORY_KEY]];
        NSMutableArray* searchHotArr = [NSKeyedUnarchiver unarchiveObjectWithFile:[GlobalFunction directoryPathWithFileName:SEARCH_HOT_KEY]];
        
        MmiaSearchListViewController* searchVC = [[MmiaSearchListViewController alloc] init];
        searchVC.historyArray = historyArr;
        searchVC.hotArray = searchHotArr;
        
        _searchPopoverController = [[UIPopoverController alloc] initWithContentViewController:searchVC];
        _searchPopoverController.delegate = self;
        _searchPopoverController.passthroughViews = @[self.searchTextFiled];
    }
    return _searchPopoverController;
}

#pragma mark - View life cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addSearchButtonWithTarget:self];
    [self addLeftButtonItemsWithTarget:self selector1:@selector(backToMainButtonClick:) selector2:@selector(categoryButtonClick:) selector3:@selector(personalButtonClick:)];
}

- (void)layoutSubviews
{
    if( self.portrait )
    {
        // 竖屏
        self.searchTextFiled.left = App_Portrait_Frame_Width - 370;
    }
    else
    {
        // 横屏
        self.searchTextFiled.left = (App_Landscape_Frame_Width - self.searchTextFiled.width)/2;
    }
    // PopoverController根据搜索框的中心点偏移
    if( self.searchPopoverController.popoverVisible )
    {
        CGRect rect = CGRectMake(self.searchTextFiled.centerX, 0, 0, 0);
        [self.searchPopoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

/**
 * 设置navigationbar搜索框
 */
- (void)addSearchButtonWithTarget:(id)target
{
    /*
     UISearchBar* _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(App_Frame_Width - 320, (kNavigationBarHeight - 30)/2, 280, 30)];
     _searchBar.delegate = self;
     _searchBar.placeholder = @"搜索...";
     [_searchBar setImage:UIImageNamed(@"search_icon.png") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
     _searchBar.tintColor = [UIColor grayColor];
     _searchBar.backgroundColor = [UIColor redColor];
     */
    
    _searchTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(App_Frame_Width - 370, (kNavigationBarHeight - 31)/2, 350, 31)];
    _searchTextFiled.layer.cornerRadius = 15;
    UIColor* placeHolderColcor = [UIColor lightGrayColor];
    _searchTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索..." attributes:@{NSForegroundColorAttributeName : placeHolderColcor}];
    _searchTextFiled.font = UIFontSystem(16);
    _searchTextFiled.textColor = ColorWithHexRGB(0x595959);
    _searchTextFiled.backgroundColor = [UIColor whiteColor];
    _searchTextFiled.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    _searchTextFiled.clearButtonMode = UITextFieldViewModeAlways;
    _searchTextFiled.returnKeyType = UIReturnKeySearch;
    _searchTextFiled.tintColor = [UIColor grayColor];
    _searchTextFiled.delegate = target;
    
    UIView* myLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, _searchTextFiled.height)];
    myLeftView.backgroundColor = UIColorClear;
    
    UIImageView* searchImageView = UIImageViewNamed(@"search_icon.png");
    searchImageView.frame = CGRectMake(10, (myLeftView.height - 25)/2, 25, 25);
    [myLeftView addSubview:searchImageView];
    
    _searchTextFiled.leftView = myLeftView;
    _searchTextFiled.leftViewMode = UITextFieldViewModeAlways;
    
    [self.navigationController.navigationBar addSubview:_searchTextFiled];
}

/**
 * 设置navigationbar左边按钮
 */
- (void)addLeftButtonItemsWithTarget:(id)target selector1:(SEL)selector1 selector2:(SEL)selector2 selector3:(SEL)selector3
{
    UIButton* mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mainBtn.frame = CGRectMake(20, (kNavigationBarHeight - 31)/2, 31, 31);
    mainBtn.showsTouchWhenHighlighted = YES;
    mainBtn.tag = 12;
    [mainBtn setImage:[UIImage imageNamed:@"主页_icon.png"] forState:UIControlStateNormal];
    [mainBtn addTarget:target action:selector1 forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryBtn.frame = CGRectMake(mainBtn.right + 30, mainBtn.top, 31, 31);
    categoryBtn.showsTouchWhenHighlighted = YES;
    categoryBtn.tag = 13;
    [categoryBtn setImage:[UIImage imageNamed:@"列表_icon.png"] forState:UIControlStateNormal];
    [categoryBtn addTarget:target action:selector2 forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* personalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    personalBtn.frame = CGRectMake(categoryBtn.right + 30, mainBtn.top, 31, 31);
    personalBtn.showsTouchWhenHighlighted = YES;
    personalBtn.tag = 14;
    [personalBtn setImage:[UIImage imageNamed:@"个人中心_icon.png"] forState:UIControlStateNormal];
    [personalBtn addTarget:target action:selector3 forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.navigationBar addSubview:mainBtn];
    [self.navigationController.navigationBar addSubview:categoryBtn];
    [self.navigationController.navigationBar addSubview:personalBtn];
}

#pragma mark *返回首页按钮

- (void)backToMainButtonClick:(id)sender
{
    for( UIViewController* childViewController in self.childViewControllers )
    {
        [childViewController willMoveToParentViewController:nil];
        [childViewController removeFromParentViewController];
        [childViewController.view removeFromSuperview];
    }
    // TODO:半透明背景
//    [[self.view viewWithTag:11] removeFromSuperview];
}

#pragma mark *分类按钮

- (void)categoryButtonClick:(id)sender
{
    UINavigationController* nav = (UINavigationController *)self.categoryPopoverController.contentViewController;
    MmiaCategoryViewController* categoryVC;
    for( UIViewController* viewController in nav.viewControllers )
    {
        if( [viewController isKindOfClass:[MmiaCategoryViewController class]] )
        {
            categoryVC = (MmiaCategoryViewController *)viewController;
            break;
        }
    }
    if( categoryVC.dataArray.count <= 0 )
    {
        [[AppDelegate sharedAppDelegate] getCategroyDataForRequest];
        categoryVC.dataArray = [AppDelegate sharedAppDelegate].categoryArray;
    }

    CGRect rect = CGRectMake([sender centerX], 0, 0, 0);
    [self.categoryPopoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

#pragma mark *个人中心按钮

- (void)personalButtonClick:(id)sender
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
//    if( [defaults objectForKey:USER_IS_LOGIN] )
    if ([defaults boolForKey:USER_IS_LOGIN])
    {
//        [self registerSuccess];
    
        MmiaPersonalHomeViewController* personViewController = [[MmiaPersonalHomeViewController alloc] init];
        personViewController.view.frame = self.view.bounds;
        self.rightStackViewController = personViewController;
    }
    else
    {
        MmiaLoginViewController *login = [[MmiaLoginViewController alloc]init];
        login.view.frame = self.view.bounds;
        [login setTarget:self withSuccessAction:@selector(loginSuccess) withRegisterAction:@selector(registerSuccess)];
        //模态跳转的透明效果
//        if (iOS8Later)
//            login.modalPresentationStyle = UIModalPresentationOverFullScreen;
//        else
            login.modalPresentationStyle = UIModalPresentationFormSheet;

        [self presentViewController:login animated:YES completion:nil];
    }
}

- (void)click:(id)sender
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://www.mmia.com";
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

- (NSString *)didSeletedPopoverItem:(NSNotification *)notification
{
    NSDictionary* dict = [notification userInfo];
    id value = dict[SEARCH_SELITEM_KEY];
    
    NSString* textString;
    if( [value isKindOfClass:[MagazineItem class]] )
    {
        MagazineItem* item = value;
        textString = item.titleText;
    }
    else if( [value isString] )
    {
        textString = value;
    }
    MyNSLog( @"didSeletedPopoverItem = %@", textString );
    
    if( self.categoryPopoverController.popoverVisible )
    {
        [self.categoryPopoverController dismissPopoverAnimated:YES];
    }
    else if( self.searchPopoverController.popoverVisible )
    {
        self.searchTextFiled.text = textString;
        
        [self.searchPopoverController dismissPopoverAnimated:NO];
        [self.searchTextFiled resignFirstResponder];
        
        [self searchHistoryWriteToFile];
    }
    return textString;
}

#pragma mark *Notifications

- (void)createNotifications
{
    [DefaultNotificationCenter addObserver:self selector:@selector(backToMainButtonClick:) name:BackToMainView_Notification_Key object:nil];
    [DefaultNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)destroyNotifications
{
    [DefaultNotificationCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [DefaultNotificationCenter removeObserver:self name:BackToMainView_Notification_Key object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if( keyboardSize.height >= self.view.height && keyboardSize.width < self.view.height )
    {
        keyboardSize.height = keyboardSize.width;
    }
    
    CGSize popoverSize = KPopoverContentSize;
    if( popoverSize.height > (self.view.height - keyboardSize.height - 20) )
    {
        popoverSize = CGSizeMake(popoverSize.width, self.view.height - keyboardSize.height - 20);
    }
    
    MmiaSearchListViewController* searchVC = (MmiaSearchListViewController *)self.searchPopoverController.contentViewController;
    searchVC.preferredContentSizeForView  = popoverSize;
}

#pragma mark - Private

- (void)loginSuccess
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    MmiaPersonalHomeViewController* personViewController = [[MmiaPersonalHomeViewController alloc] init];
    personViewController.view.frame = self.view.bounds;
    self.rightStackViewController = personViewController;
}

- (void)registerSuccess
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self loginSuccess];

}

- (void)showSearchPopoverController
{
    MmiaSearchListViewController* searchVC = (MmiaSearchListViewController *)self.searchPopoverController.contentViewController;
    if( searchVC.hotArray.count <= 0 )
    {
        // 重新获取数据，本次内容为空下次点击会展示获取的数据
        [[AppDelegate sharedAppDelegate] getSearchHotDataForRequest];
        searchVC.hotArray = [AppDelegate sharedAppDelegate].searchHotArray;
    }
    
    NSMutableArray* historyArr = [NSMutableArray arrayWithContentsOfFile:[GlobalFunction directoryPathWithFileName:SEARCH_HISTORY_KEY]];
    searchVC.historyArray = historyArr;
    
    CGRect rect = CGRectMake(self.searchTextFiled.centerX, 0, 0, 0);
    [self.searchPopoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (void)searchHistoryWriteToFile
{
    NSString* historyPath = [GlobalFunction directoryPathWithFileName:SEARCH_HISTORY_KEY];
    
    NSArray* historyArr = [NSArray arrayWithContentsOfFile:historyPath];
    NSMutableArray* mutableHistoryArr = [NSMutableArray arrayWithArray:historyArr];
    
    NSString* targetStr = [self.searchTextFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    for( NSString* searchStr in mutableHistoryArr )
    {
        if( [searchStr isEqualToString:targetStr] )
        {
            [mutableHistoryArr removeObject:searchStr];
            
            break;
        }
    }
    [mutableHistoryArr insertObject:targetStr atIndex:0];
    
    // 搜索历史只存入10条内容
    if( mutableHistoryArr.count > 10 )
    {
        [mutableHistoryArr removeObjectsInRange:NSMakeRange(10, mutableHistoryArr.count - 10)];
    }
    
    [mutableHistoryArr writeToFile:historyPath atomically:YES];
}

#pragma mark - TextFiledDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchPopoverController dismissPopoverAnimated:YES];
    [textField resignFirstResponder];
    
    [self searchHistoryWriteToFile];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self showSearchPopoverController];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // TODO:搜索操作
    NSString* textStr = textField.text;
    MyNSLog( @"didEndtextField = %@", textStr );
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // TODO:更改TableView内容
    return YES;
}

#pragma mark - UIPopoverControllerDelegate

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    [self.searchTextFiled resignFirstResponder];
    
    return YES;
}

#pragma mark - UIViewControllerRotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

-(void)dealloc
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
