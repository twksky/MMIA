//
//  MmiaDetailsCollectionViewController.m
//  MMIA
//
//  Created by twksky on 15/5/20.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaDetailsCollectionViewController.h"
#import "MmiaDetailsLayout.h"
#import "DetailsCell1.h"/*品牌详情页*/
#import "DetailsCell2.h"/*单品详情页*/

@interface MmiaDetailsCollectionViewController ()
@property ( nonatomic , strong ) DetailsCell2 *cell2;
@property ( nonatomic , strong ) DetailsCell1 *cell1;
@end

@implementation MmiaDetailsCollectionViewController

//static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册分享按钮点击事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(QQShare) name:@"QQShare" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WBShare) name:@"WBShare" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(FriendShare) name:@"FriendShare" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WXShare) name:@"WXShare" object:nil];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //    注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailsCell1" bundle:nil]forCellWithReuseIdentifier:@"cell1"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DetailsCell2" bundle:nil]forCellWithReuseIdentifier:@"cell2"];
    // Do any additional setup after loading the view.
    
    //滑动效果（最多只能滑动一个页面）
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;

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

//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 4;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *singCellName = @"cell2";
    static NSString *brandCellName = @"cell1";
#if 0
    _cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:singCellName forIndexPath:indexPath];
    _cell2.singleCollectionView.contentOffset = CGPointMake(0, 0);
#else
    
    if (indexPath.section == 0) {
        _cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:brandCellName forIndexPath:indexPath];
        _cell1.brandCoolectionView.contentOffset = CGPointMake(0, 0);
        return _cell1;
    }else{
        _cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:singCellName forIndexPath:indexPath];
        _cell2.singleCollectionView.contentOffset = CGPointMake(0, 0);
        return _cell2;
    }
    
#endif
    // Configure the cell
    
    
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

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


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"QQShare" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"WBShare" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FriendShare" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"WXShare" object:nil];
}

@end
