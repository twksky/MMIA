//
//  MmiaDetailsCell2_Layout.m
//  MMIA
//
//  Created by twksky on 15/5/15.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaDetailsCell2_Layout.h"
#import "DataController.h"

@implementation MmiaDetailsCell2_Layout

-(void)awakeFromNib{
    DataController *data = [[DataController alloc]init];
    self.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [data singelCellHeightWithWeight:[UIScreen mainScreen].bounds.size.width]);

    self.sectionInset = UIEdgeInsetsMake(0, -74, 0, 0);
    
////    self.minimumInteritemSpacing = 10.0f;
////    self.minimumLineSpacing = 4.0f;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;

}



@end
