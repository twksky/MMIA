//
//  DetailsCell1.m
//  MMIA
//
//  Created by twksky on 15/5/15.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "DetailsCell1.h"
#import "DetailsCell1_Cell.h"
#import "DataController.h"


@implementation DetailsCell1

- (void)awakeFromNib {
    // Initialization code
    _brandCoolectionView.delegate = self;
    _brandCoolectionView.dataSource = self;
    _brandCoolectionView.backgroundColor = [UIColor cyanColor];
    [_brandCoolectionView registerNib:[UINib nibWithNibName:@"DetailsCell1_Cell" bundle:nil]forCellWithReuseIdentifier:@"cell1_Cell"];

    [_brandCoolectionView registerNib:[UINib nibWithNibName:@"BrandHeader" bundle:nil] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:@"cell1_CellHeader"];
    
    [_brandCoolectionView registerNib:[UINib nibWithNibName:@"BrandFooter" bundle:nil] forSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" withReuseIdentifier:@"cell1_CellFooter"];
}

-(void)initWithTarget:(id)target{
    _target = target;
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
        [_brandHeader initWithTarget:_target];
        return _brandHeader;
    }
    else if ([kind  isEqual: @"UICollectionElementKindSectionFooter"]){
        _brandFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cell1_CellFooter" forIndexPath:indexPath];
        [_brandFooter initWithTarget:_target];
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


@end
