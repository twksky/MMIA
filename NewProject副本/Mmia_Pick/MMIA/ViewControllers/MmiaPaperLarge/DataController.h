//
//  DataController.h
//  MMIA
//
//  Created by twksky on 15/5/29.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class BrandHeader;
@interface DataController : NSObject
//品牌页面Head，Foot
@property (copy, nonatomic) NSString *brandDescriptionText;
@property (copy, nonatomic) NSString *officalWebsiteNameText;
@property (copy, nonatomic) NSString *titleText;
@property (copy, nonatomic) NSString *shopAddressNameText;
@property (copy, nonatomic) NSString *phoneText;
@property (copy, nonatomic) NSString *mailText;
//单品页面Head
@property (copy, nonatomic) NSString *brandLogoBtnImageName;
@property (copy, nonatomic) NSString *singelNameText;
@property (copy, nonatomic) NSString *singelDescriptionText;

//品牌页面Cell
@property (copy, nonatomic) NSString *brandCellImageName;
@property (copy, nonatomic) NSString *brandCellImageDescriptionText;

//单品页面Cell
@property (copy, nonatomic) NSString *singelCellImageName;
@property (copy, nonatomic) NSString *singelCellImageDescriptionText;

+(DataController *)sharedSingle;
-(CGFloat)headHeightWithWeight:(CGFloat)Weight;//品牌详情页头的高度
-(CGFloat)footHeightWithWeight:(CGFloat)Weight;//品牌详情页尾的高度
-(CGFloat)singelHeadHeightWithWeight:(CGFloat)Weight;//单品详情页的头的高度

-(CGFloat)brandCellHeightWithWeight:(CGFloat)Weight;//品牌Cell的高
-(CGFloat)singelCellHeightWithWeight:(CGFloat)Weight;//单品Cell的高

@end

