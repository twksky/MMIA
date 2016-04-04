//
//  DetailsCell1.m
//  MMIA
//
//  Created by twksky on 15/5/15.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "DetailsCell1.h"
#import "MmiaProductDetailModel.h"


@implementation DetailsCell1

- (void)awakeFromNib {
    // Initialization code
    _brandCoolectionView.delegate = self;
    _brandCoolectionView.dataSource = self;
    _brandCoolectionView.backgroundColor = [UIColor cyanColor];
    [_brandCoolectionView registerNib:[UINib nibWithNibName:@"DetailsCell1_Cell" bundle:nil]forCellWithReuseIdentifier:@"cell1_Cell"];

    [_brandCoolectionView registerNib:[UINib nibWithNibName:@"BrandHeader" bundle:nil] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:@"cell1_CellHeader"];
    
    [_brandCoolectionView registerNib:[UINib nibWithNibName:@"BrandFooter" bundle:nil] forSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" withReuseIdentifier:@"cell1_CellFooter"];
    [self getNavTitle];
}

-(void)getNavTitle
{
    _navTitle.text = self.brandModel.title;
    _navTitle.font = [UIFont systemFontOfSize:20];
    _navTitle.textColor = [UIColor blackColor];
}

-(void)initWithTarget:(id)target{
    _target = target;
}

// 设置每一组有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.brandModel.brandPictureList.count;
}

// 设置一共有多少个分组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

////设置头脚高。。。
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    CGFloat H1 = [GlobalFunction getTextSizeWithSystemFont:[UIFont systemFontOfSize:10] ConstrainedToSize:CGSizeMake(Main_Screen_Width-20, Main_Screen_Height) string:self.brandModel.describe].height;
    CGFloat H2 = [GlobalFunction getTextSizeWithSystemFont:[UIFont systemFontOfSize:10] ConstrainedToSize:CGSizeMake(Main_Screen_Width-20, Main_Screen_Height) string:self.brandModel.officalWebsite].height;
    CGFloat H3 = [GlobalFunction getTextSizeWithSystemFont:[UIFont systemFontOfSize:20] ConstrainedToSize:CGSizeMake(Main_Screen_Width-20, Main_Screen_Height) string:self.brandModel.title].height;
    
    CGSize size = CGSizeMake(Main_Screen_Width, 10+H1+20+10+8+H2+20+H3);
    return size;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
    CGSize size = CGSizeMake(Main_Screen_Width, 40+10+10+10);
    return size;
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind  isEqual: @"UICollectionElementKindSectionHeader"]) {
        self.brandHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cell1_CellHeader" forIndexPath:indexPath];
        [self.brandHeader initWithTarget:_target];
        self.brandHeader.brandModel = self.brandModel;
        return _brandHeader;
    }
    else if ([kind  isEqual: @"UICollectionElementKindSectionFooter"]){
        self.brandFooter = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cell1_CellFooter" forIndexPath:indexPath];
        [self.brandFooter initWithTarget:_target];
        self.brandFooter.brandModel = self.brandModel;
        return self.brandFooter;
    }
    return nil;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell1_Cell";
    self.brandCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    
    NSString *describe = ((MmiaProductPictureListModel*)self.brandModel.brandPictureList[indexPath.row]).describe;
    NSString* picUrl = ((MmiaProductPictureListModel*)self.brandModel.brandPictureList[indexPath.row]).picUrl;
    CGFloat H1 = [GlobalFunction getTextSizeWithSystemFont:[UIFont systemFontOfSize:10] ConstrainedToSize:CGSizeMake(Main_Screen_Width-20, Main_Screen_Height) string:describe].height;
    
    [self.brandCell.pic sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:nil];
    self.brandCell.describe.text =describe;
        self.brandCell.describe.font = [UIFont systemFontOfSize:10];
    self.brandCell.describe.textColor = ColorWithHexRGB(0x666666);
    [self.brandCell.describe setNumberOfLines:0];
    
    CGFloat H2 = 150;
    [_brandCell setHeight:H1+H2+10];
    return _brandCell;
    
}


@end
