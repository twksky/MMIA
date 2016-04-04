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
    _singleCollectionView.delegate = self;
    _singleCollectionView.dataSource = self;
    _singleCollectionView.backgroundColor = [UIColor cyanColor];
    [_singleCollectionView registerNib:[UINib nibWithNibName:@"DetailsCell2_Cell" bundle:nil]forCellWithReuseIdentifier:@"cell2_Cell"];
    [_singleCollectionView registerClass:[ShareView class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" withReuseIdentifier:@"Share"];
    
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

////设置头脚高。。。**
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(collectionView.bounds.size.width, 70);
//}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 40);
}


//设置组脚，分享view
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    _shareView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Share" forIndexPath:indexPath];
    
    return _shareView;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell2_Cell";
    DetailsCell2_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    NSLog(@"cell2___%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.row%2 == 0 ) {
        cell.label.text = [NSString stringWithFormat:@"图片——%ld——%ld",indexPath.section,indexPath.row];
    }else
        cell.label.text = [NSString stringWithFormat:@"文字——%ld——%ld",indexPath.section,indexPath.row];

    return cell;
}

@end
