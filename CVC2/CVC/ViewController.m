//
//  ViewController.m
//  CVC
//
//  Created by twksky on 15/5/15.
//  Copyright (c) 2015年 twksky. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *CV = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
    layout.itemSize = self.view.bounds.size;
//    layout.itemSize = CGSizeMake(320, 568);
//    [layout setMinimumLineSpacing:20];
//    [layout setMinimumInteritemSpacing:20];
    self.navigationController.navigationBarHidden = YES;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 20);
    CV.delegate = self;
    CV.dataSource = self;
    [self.view addSubview:CV];
    [CV registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil]forCellWithReuseIdentifier:@"cell"];
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

// 设置每一组有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 1;
}

// 设置一共有多少个分组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];

//    cell.backgroundColor = [UIColor grayColor];
    return cell;
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
