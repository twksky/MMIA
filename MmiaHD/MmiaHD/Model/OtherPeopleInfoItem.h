//
//  OtherPeopleInfoItem.h
//  MmiaHD
//
//  Created by twksky on 15/4/14.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//他人界面的model，用于存放他人界面的数据

@interface OtherPeopleInfoItem : NSObject

@property (nonatomic, assign) NSInteger  userId;
@property (nonatomic, retain) NSString   *headImageUrl;
@property (nonatomic, retain) NSString   *nikeName;
@property (nonatomic, assign) NSInteger  sex;
@property (nonatomic, retain) NSString   *signature;
@property (nonatomic, retain) NSString   *email;
@property (nonatomic, assign) NSInteger  userType;
@property (nonatomic, assign) NSInteger  fansNumber;
@property (nonatomic, assign) NSInteger  focusPersonNumber;
@property (nonatomic, assign) NSInteger  isAttention;
@property (nonatomic, retain) UIImage    *headImage;

@property(nonatomic, retain) NSString    *website;
@property(nonatomic, retain) NSString    *homepage;
@property(nonatomic, retain) NSString    *industry;
@property(nonatomic, retain) NSString    *workUnit;

+(OtherPeopleInfoItem *)sharedOtherPeopleInfoItem;


@end
