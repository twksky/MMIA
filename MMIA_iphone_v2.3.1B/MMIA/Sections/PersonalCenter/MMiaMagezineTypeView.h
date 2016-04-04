//
//  MMiaMagezineTypeView.h
//  MMIA
//
//  Created by lixiao on 14-9-12.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MagezineTypeItem.h"

@class  MMiaMagezineTypeView;
@protocol MMiaMagezineTypeViewDelegate <NSObject>
-(void)sendMMiaMagezineType:(MMiaMagezineTypeView *)magazineTypeView;
@end

@interface MMiaMagezineTypeView : UIView<UITableViewDelegate,UITableViewDataSource,MMiaMagezineTypeViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic,retain)UIPickerView *pickView;
@property(nonatomic,assign)id <MMiaMagezineTypeViewDelegate>delegate;
@property(nonatomic,retain)MagezineTypeItem *item;

- (id)initWithFrame:(CGRect)frame selctStr:(NSString *)selectType;

@end
