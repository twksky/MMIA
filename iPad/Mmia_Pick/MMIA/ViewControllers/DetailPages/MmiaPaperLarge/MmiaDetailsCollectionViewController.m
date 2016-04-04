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
#import "CeshiViewController.h"

@interface MmiaDetailsCollectionViewController ()
@property ( nonatomic , strong ) DetailsCell1 *cell1;
@property ( nonatomic , strong ) DetailsCell2 *cell2;
@end

@implementation MmiaDetailsCollectionViewController

//static NSString * const reuseIdentifier = @"Cell";

-(void)viewWillAppear:(BOOL)animated{


}


- (void)viewDidLoad {
    [super viewDidLoad];
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

    return 3;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell2";
    _cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    _cell2.collectionView2.contentOffset = CGPointMake(0, 0);
    
    return _cell2;
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

}
-(void)WXShare{
    NSLog(@"微信好友分享");

}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"QQShare" object:nil];
}

@end
