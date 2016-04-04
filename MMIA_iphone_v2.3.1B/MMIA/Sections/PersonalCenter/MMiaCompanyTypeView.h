//
//  MMiaCompanyTypeView.h
//  MMIA
//
//  Created by lixiao on 14/11/6.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMiaCompanyTypeViewDelegate <NSObject>
-(void)sendMMiaMagezineType:(NSString *)magazineType;
@end

@interface MMiaCompanyTypeView : UIView<UITableViewDelegate,UITableViewDataSource,MMiaCompanyTypeViewDelegate>
@property(nonatomic,assign)id <MMiaCompanyTypeViewDelegate>delegate;
- (id)initWithFrame:(CGRect)frame selctStr:(NSString *)selectType;

@end
