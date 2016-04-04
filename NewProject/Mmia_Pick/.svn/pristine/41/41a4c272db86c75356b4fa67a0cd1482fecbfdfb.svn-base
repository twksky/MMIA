//
//  BrandDetailSingelPageLayout.m
//  MMIA
//
//  Created by twksky on 15/6/2.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "BrandDetailSingelPageLayout.h"
#import "DataController.h"

@implementation BrandDetailSingelPageLayout

- (id)init
{
    if (!(self = [super init])) return nil;
    
    DataController *data = [[DataController alloc]init];
    self.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [data brandCellHeightWithWeight:[UIScreen mainScreen].bounds.size.width]);
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.minimumInteritemSpacing = 10.0f;
//    self.minimumLineSpacing = 4.0f;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    return self;
}

@end
