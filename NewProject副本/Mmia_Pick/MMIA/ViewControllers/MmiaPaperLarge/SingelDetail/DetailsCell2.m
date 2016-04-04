//
//  DetailsCell2.m
//  MMIA
//
//  Created by twksky on 15/5/15.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "DetailsCell2.h"
#import "DataController.h"
#import "DetailsCell2_Cell.h"

@implementation DetailsCell2

- (void)awakeFromNib {
    // Initialization code
    _singleCollectionView.delegate = self;
    _singleCollectionView.dataSource = self;
    _singleCollectionView.backgroundColor = [UIColor cyanColor];
    [_singleCollectionView registerNib:[UINib nibWithNibName:@"DetailsCell2_Cell" bundle:nil]forCellWithReuseIdentifier:@"cell2_Cell"];
    [_singleCollectionView registerClass:[ShareView class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" withReuseIdentifier:@"Share"];
    [_singleCollectionView registerNib:[UINib nibWithNibName:@"SingelHeader" bundle:nil] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:@"cell2_CellHeader"];
    
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

////设置头脚高。。。**
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //先加载，定义高
    DataController *dataController = [DataController sharedSingle];
    CGFloat headerH = [dataController singelHeadHeightWithWeight:collectionView.frame.size.width];
    return CGSizeMake(collectionView.frame.size.width, headerH);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 40);
}


//设置组头，组脚分享view

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind  isEqual: @"UICollectionElementKindSectionHeader"]) {
        _singelHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cell2_CellHeader" forIndexPath:indexPath];
        [_singelHeader initWithTarget:_target];
        return _singelHeader;
    }
    else if ([kind  isEqual: @"UICollectionElementKindSectionFooter"]){
        _shareView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Share" forIndexPath:indexPath];
        return _shareView;
    }
    return nil;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell2_Cell";
    DetailsCell2_Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    NSLog(@"cell2___%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    return cell;
}

-(void)initWithTarget:(id)target{
    _target = target;
}


@end
