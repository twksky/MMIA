//
//  BrandDetailSingelPageViewController.m
//  MMIA
//
//  Created by twksky on 15/6/2.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "BrandDetailSingelPageViewController.h"
#import "DataController.h"
#import "DetailsCell1_Cell.h"
#import "WebViewController.h"

@interface BrandDetailSingelPageViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation BrandDetailSingelPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(QQShare) name:@"QQShare" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WBShare) name:@"WBShare" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(FriendShare) name:@"FriendShare" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WXShare) name:@"WXShare" object:nil];
    
    // Do any additional setup after loading the view from its nib.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor cyanColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailsCell1_Cell" bundle:nil]forCellWithReuseIdentifier:@"cell1_Cell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BrandHeader" bundle:nil] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:@"cell1_CellHeader"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"BrandFooter" bundle:nil] forSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" withReuseIdentifier:@"cell1_CellFooter"];
    [self.collectionView setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
}

// 设置每一组有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 1;
}

// 设置一共有多少个分组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

////设置头脚高。。。
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //先加载，定义高
    DataController *dataController = [DataController sharedSingle];
    CGFloat headerH = [dataController headHeightWithWeight:collectionView.frame.size.width];
    NSLog(@"%f",collectionView.frame.size.width);
    return CGSizeMake(collectionView.frame.size.width, headerH);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    //先加载，定义高
    DataController *dataController = [DataController sharedSingle];
    CGFloat footerH = [dataController footHeightWithWeight:collectionView.frame.size.width];
    return CGSizeMake(collectionView.frame.size.width, footerH);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind  isEqual: @"UICollectionElementKindSectionHeader"]) {
        _brandHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cell1_CellHeader" forIndexPath:indexPath];
        [_brandHeader initWithTarget:self];
        return _brandHeader;
    }
    else if ([kind  isEqual: @"UICollectionElementKindSectionFooter"]){
        _brandFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cell1_CellFooter" forIndexPath:indexPath];
        [_brandFooter initWithTarget:self];
        return _brandFooter;
    }
    return nil;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell1_Cell";
    DetailsCell1_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    NSLog(@"cell1___%ld,%ld",(long)indexPath.section,(long)indexPath.row);    
    return cell;
}

#pragma mark _btnClick 分享

-(void)QQShare{
    NSLog(@"QQ分享");
    
    
}
-(void)WBShare{
    NSLog(@"微博分享");
    
    
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


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"QQShare" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"WBShare" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FriendShare" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"WXShare" object:nil];
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
