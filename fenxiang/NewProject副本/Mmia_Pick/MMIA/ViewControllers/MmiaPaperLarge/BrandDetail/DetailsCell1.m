//
//  DetailsCell1.m
//  MMIA
//
//  Created by twksky on 15/5/15.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "DetailsCell1.h"
#import "DetailsCell1_Cell.h"


@implementation DetailsCell1

- (void)awakeFromNib {
    // Initialization code
    _brandCoolectionView.delegate = self;
    _brandCoolectionView.dataSource = self;
    _brandCoolectionView.backgroundColor = [UIColor cyanColor];
    [_brandCoolectionView registerNib:[UINib nibWithNibName:@"DetailsCell1_Cell" bundle:nil]forCellWithReuseIdentifier:@"cell1_Cell"];
//    [_brandCoolectionView registerClass:[BrandHeader class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" withReuseIdentifier:@"Share"];
    [_brandCoolectionView registerNib:[UINib nibWithNibName:@"BrandHeader" bundle:nil] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:@"cell1_CellHeader"];
    
    
}

// 设置每一组有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 2;
}

// 设置一共有多少个分组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

////设置脚高。。。*这段代码不执行T^T*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 300);
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(collectionView.bounds.size.width, 40);
//}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind  isEqual: @"UICollectionElementKindSectionHeader"]) {
        _brandHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cell1_CellHeader" forIndexPath:indexPath];
        return _brandHeader;
    }else
        return nil;
    
}

//设置组脚，分享view
//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Share" forIndexPath:indexPath];
//    
//    ShareView *shareView = [[ShareView alloc]init];
//    [reusableView addSubview:shareView];
//    
//    return reusableView;
//}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell1_Cell";
    DetailsCell1_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    NSLog(@"cell1___%ld,%ld",(long)indexPath.section,(long)indexPath.row);

    
    return cell;
}


@end
