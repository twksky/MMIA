//
//  DetailsCell1.h
//  MMIA
//
//  Created by twksky on 15/5/15.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandHeader.h"
#import "BrandFooter.h"


@interface DetailsCell1 : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *brandCoolectionView;
@property (weak, nonatomic) BrandHeader *brandHeader;
@property (weak, nonatomic) BrandFooter *brandFooter;
@property ( nonatomic , strong ) id target;
-(void)initWithTarget:(id)target;
@end
