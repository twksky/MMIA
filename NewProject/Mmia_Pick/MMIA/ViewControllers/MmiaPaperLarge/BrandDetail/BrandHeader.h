//
//  BrandHeader.h
//  MMIA
//
//  Created by twksky on 15/5/27.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MmiaPaperResponseModel.h"
@class DataController;

@interface BrandHeader : UICollectionReusableView
@property ( nonatomic , strong ) IBOutlet UILabel *brandDescription;
@property ( nonatomic , strong ) IBOutlet UIView *lineView;
@property ( nonatomic , strong ) IBOutlet UILabel *officalWebsite;
@property ( nonatomic , strong ) IBOutlet UIButton *officalWebsiteName;
@property ( nonatomic , strong ) IBOutlet UILabel *title;
@property ( nonatomic , strong ) id target;
@property ( nonatomic  ) CGFloat  totalHeight;
@property ( nonatomic , strong ) MmiaPaperBrandModel *brandModel;
-(void)initWithTarget:(id)target;
@end
