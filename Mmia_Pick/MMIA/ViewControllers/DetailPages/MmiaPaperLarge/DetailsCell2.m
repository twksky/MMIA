//
//  DetailsCell2.m
//  MMIA
//
//  Created by twksky on 15/5/15.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "DetailsCell2.h"
#import "DetailsCell2_Cell.h"

@implementation DetailsCell2

- (void)awakeFromNib {
    // Initialization code
    _collectionView2.delegate = self;
    _collectionView2.dataSource = self;
    _collectionView2.backgroundColor = [UIColor cyanColor];
    [_collectionView2 registerNib:[UINib nibWithNibName:@"DetailsCell2_Cell" bundle:nil]forCellWithReuseIdentifier:@"cell2_Cell"];
    [_collectionView2 registerClass:[ShareView class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" withReuseIdentifier:@"Share"];

}

// 设置每一组有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 8;
}

// 设置一共有多少个分组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

////设置脚高。。。*这段代码不执行T^T*
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForFooterInSection:(NSInteger)section
//{
//    return 40;
//}

//设置组脚，分享view
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    _footCell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Share" forIndexPath:indexPath];
    
    _shareView = [[ShareView alloc]init];
    [_footCell addSubview:_shareView];
    
    return _footCell;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell2_Cell";
    DetailsCell2_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor grayColor];
//    cell.frame = CGRectMake(0, 150*((indexPath.section)-1), 320, 120);
    NSLog(@"cell2___%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.row%2 == 0 ) {
        cell.label.text = [NSString stringWithFormat:@"图片——%ld——%ld",indexPath.section,indexPath.row];
    }else
        cell.label.text = [NSString stringWithFormat:@"文字——%ld——%ld",indexPath.section,indexPath.row];

    return cell;
}

@end
