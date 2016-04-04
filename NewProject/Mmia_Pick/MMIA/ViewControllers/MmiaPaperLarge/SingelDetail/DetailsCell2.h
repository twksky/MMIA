//
//  DetailsCell2.h
//  MMIA
//
//  Created by twksky on 15/5/15.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareView.h"
#import "MmiaPublicResponseModel.h"
#import "ProductHeader.h"
#import "MmiaPublicResponseModel.h"//MmiaPaperProductListModel
#import "DetailsCell2_Cell.h"

@interface DetailsCell2 : UICollectionViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *singleCollectionView;
@property (weak, nonatomic) ShareView *shareView;
//@property (nonatomic, weak) SingelHeader *singelHeader;
@property (nonatomic, weak) ProductHeader *productHeader;
@property (nonatomic, strong) id target;
@property ( nonatomic , strong ) MmiaPaperProductListModel *productModel;
@property (weak, nonatomic) IBOutlet UILabel *navTitle;
@property ( nonatomic , strong ) DetailsCell2_Cell *cell;
-(void)initWithTarget:(id)target;

@end
