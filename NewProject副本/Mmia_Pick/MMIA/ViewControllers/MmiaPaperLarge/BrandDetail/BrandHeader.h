//
//  BrandHeader.h
//  MMIA
//
//  Created by twksky on 15/5/27.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataController.h"
@class DataController;

@interface BrandHeader : UICollectionReusableView
@property ( nonatomic , strong ) UILabel *brandDescription;
@property ( nonatomic , strong ) UIView *lineView;
@property ( nonatomic , strong ) UILabel *officalWebsite;
@property ( nonatomic , strong ) UIButton *officalWebsiteName;
@property ( nonatomic , strong ) UILabel *title;
@property ( nonatomic , strong ) id target;
@property ( nonatomic  ) CGFloat  totalHeight;
//@property ( nonatomic  ) DataController *dataController;
-(void)initWithTarget:(id)target;
@end
