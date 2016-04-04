//
//  BrandFooter.h
//  MMIA
//
//  Created by twksky on 15/5/28.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MmiaPaperResponseModel.h"

@interface BrandFooter : UICollectionReusableView

@property ( nonatomic , strong ) UIView *lineView1;
@property ( nonatomic , strong ) UILabel *shopAddress;
@property ( nonatomic , strong ) UILabel *shopAddressName;
@property ( nonatomic , strong ) UIView *lineView2;
@property ( nonatomic , strong ) UILabel *contactInformation;
@property ( nonatomic , strong ) UILabel *phone;
@property ( nonatomic , strong ) UILabel *mail;
@property ( nonatomic , strong ) UIView *shareView;
@property ( nonatomic , strong ) id target;
@property ( nonatomic , strong ) MmiaPaperBrandModel *brandModel;
-(void)initWithTarget:(id)target;

@end
