//
//  ProductHeader.h
//  MMIA
//
//  Created by twksky on 15/6/8.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MmiaPublicResponseModel.h"

/*
 单品详情页的头，包含三个部分，品牌logo，单品名字，单品介绍
 */

@interface ProductHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *brandLogo;
@property (weak, nonatomic) IBOutlet UILabel *singelName;
@property (weak, nonatomic) IBOutlet UILabel *singelDescription;
@property ( nonatomic , strong ) id target;
@property ( nonatomic , strong ) MmiaPaperProductListModel *productModel;
-(void)initWithTarget:(id)target;

@end

