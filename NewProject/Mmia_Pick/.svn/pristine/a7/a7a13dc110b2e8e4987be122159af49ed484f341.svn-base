//
//  MmiaDetailsCollectionViewController.m
//  MMIA
//
//  Created by twksky on 15/5/20.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaDetailsCollectionViewController.h"
#import "DetailsCell1.h"/*品牌详情页*/
#import "DetailsCell2.h"/*单品详情页*/
#import "WebViewController.h"
#import "MmiaPaperResponseModel.h"
#import "MmiaPublicResponseModel.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "MmiaBrandViewController.h"
#import "WeiboSDK.h"

#import "BrandIntroduceDetailCell.h"
#import "BrandEntryDetailCell.h"
#import "ProductInfoDetailCell.h"

@interface MmiaDetailsCollectionViewController ()
@property ( nonatomic , strong ) DetailsCell2 *cell2;
@property ( nonatomic , strong ) DetailsCell1 *cell1;
@end

@implementation MmiaDetailsCollectionViewController

//static NSString * const reuseIdentifier = @"Cell";

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if( self = [super initWithCollectionViewLayout:layout] )
    {
    }
    return self;
}
/*
// TODO:滚到相应的位置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //    注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailsCell1" bundle:nil]forCellWithReuseIdentifier:@"cell1"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailsCell2" bundle:nil]forCellWithReuseIdentifier:@"cell2"];
    // Do any additional setup after loading the view.
    
    [self.collectionView registerClass:[BrandIntroduceDetailCell class]
        forCellWithReuseIdentifier:BrandIntroduceDetailCellIdentifier];
    [self.collectionView registerClass:[BrandEntryDetailCell class]
        forCellWithReuseIdentifier:BrandEntryDetailCellIdentifier];
    [self.collectionView registerClass:[ProductInfoDetailCell class]
        forCellWithReuseIdentifier:ProductInfoDetailCellIdentifier];
    
    //滑动效果（最多只能滑动一个页面）
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    //
//    self.navigationController.navigationBarHidden = NO;
    [self addBackBtnWithTarget:self selector:@selector(back:)];

}

-(void)back:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)setDataArry:(NSArray *)dataArry
{
    if( ![_dataArry isEqualToArray:dataArry] )
    {
        _dataArry = dataArry;
        
        [self.collectionView reloadData];
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataArry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *singCellName = @"cell2";
    static NSString *brandCellName = @"cell1";
    id item = self.dataArry[indexPath.row];
    if ([item isKindOfClass:[MmiaPaperBrandModel class]])
    {
//        _cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:brandCellName forIndexPath:indexPath];
//        _cell1.brandCoolectionView.contentOffset = CGPointMake(0, 0);
//                //代理传参
//        _cell1.brandModel = self.dataArry[indexPath.row];
//        [_cell1 initWithTarget:self];
//        return _cell1;
        
        ProductInfoDetailCell* infoCell = [collectionView dequeueReusableCellWithReuseIdentifier:ProductInfoDetailCellIdentifier forIndexPath:indexPath];
        
        return infoCell;
    }
    else if([item isKindOfClass:[MmiaPaperProductListModel class]])
    {
//        _cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:singCellName forIndexPath:indexPath];
//        _cell2.singleCollectionView.contentOffset = CGPointMake(0, 0);
//            //代理传参
//        [_cell2 initWithTarget:self];
//        _cell2.productModel = self.dataArry[indexPath.row];
//        return _cell2;
        
        BrandIntroduceDetailCell* brandCell = [collectionView dequeueReusableCellWithReuseIdentifier:BrandIntroduceDetailCellIdentifier forIndexPath:indexPath];
        
        return brandCell;
    }
    return nil;
}



#pragma mark _btnClick 分享

-(void)QQShare{
    NSLog(@"QQ分享");
    
    
}
-(void)WBShare:(WBMessageObject *)message{
    if ([WeiboSDK isWeiboAppInstalled]) {
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        authRequest.redirectURI = kRedirectURI;
        authRequest.scope = @"all";
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
        request.userInfo = @{@"ShareMessageFrom": @"MmiaDetailsCollectionViewController",
                             @"Other_Info_1": [NSNumber numberWithInt:123],
                             @"Other_Info_2": @[@"obj1", @"obj2"],
                             @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
        //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
        [WeiboSDK sendRequest:request];
        
        NSLog(@"微博分享");
    }else{
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装新浪微博客户端再进行分享" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [aler show];
    }
}

-(void)FriendShare{
    NSLog(@"朋友圈分享");
    //:1
//    [self changeScene:1];
//    [self sendLinkContent];
}

-(void)WXShare{
    NSLog(@"微信好友分享");
    //:0
}

-(void)pushWebView:(UIButton *)btn{
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.url = btn.titleLabel.text;
    [self presentViewController:webVC animated:YES completion:nil];
    //官方网站链接跳转
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
