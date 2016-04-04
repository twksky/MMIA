//
//  SingelDetailSingelPageLayout.m
//  MMIA
//
//  Created by twksky on 15/6/3.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "SingelDetailSingelPageLayout.h"
#import "DataController.h"

@implementation SingelDetailSingelPageLayout

- (id)init
{
    if (!(self = [super init])) return nil;
    
    DataController *data = [[DataController alloc]init];
    self.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [data singelCellHeightWithWeight:[UIScreen mainScreen].bounds.size.width]);
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    //    self.minimumInteritemSpacing = 10.0f;
    //    self.minimumLineSpacing = 4.0f;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    return self;
}

@end
