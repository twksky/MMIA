//
//  BrandFooter.m
//  MMIA
//
//  Created by twksky on 15/5/28.
//   Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "BrandFooter.h"
#import "ShareView.h"
#import "DataController.h"

#define H1 _lineView1.frame.size.height
#define H2 _shopAddress.frame.size.height
#define H3 _shopAddressName.frame.size.height
#define H4 _lineView2.frame.size.height
#define H5 _contactInformation.frame.size.height
#define H6 _phone.frame.size.height
#define H7 _mail.frame.size.height
#define H8 _shareView.frame.size.height
#define FooterGap 10
#define ScreenWidth [UIScreen mainScreen].bounds.size.width


@implementation BrandFooter

- (void)awakeFromNib {
    // Initialization code
    
    DataController *data = [DataController sharedSingle];
    
     //最上层的分割线
    
    _lineView1 = [[UIView alloc]initWithFrame:CGRectMake(FooterGap, 0, ScreenWidth-FooterGap-FooterGap, 20)];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, _lineView1.frame.size.height/2, _lineView1.frame.size.width, 1)];
    line1.backgroundColor = ColorWithHexRGB(0x666666);
    [_lineView1 addSubview:line1];
    [self addSubview:_lineView1];

    
    //门店地址
    _shopAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, H1, ScreenWidth-FooterGap-FooterGap, 10)];
    _shopAddress.font = [UIFont systemFontOfSize:10];
    _shopAddress.textColor = ColorWithHexRGB(0x999999);
    _shopAddress.text = @"门店地址";
    [self addSubview:_shopAddress];
    
    
    //门店地址名字
    _shopAddressName = [[UILabel alloc]init];
//    _shopAddressName.backgroundColor = [UIColor blackColor];
    _shopAddressName.font = [UIFont systemFontOfSize:15];
    _shopAddressName.textColor = ColorWithHexRGB(0x999999);
    _shopAddressName.text = data.shopAddressNameText;
    [_shopAddressName setNumberOfLines:0];
    CGSize shopAddressNameSize = CGSizeMake(150, MAXFLOAT);
    CGRect shopAddressNameRect = [_shopAddressName.text boundingRectWithSize:shopAddressNameSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_shopAddressName.font} context:nil];
    [_shopAddressName setFrame:CGRectMake(FooterGap, H1+H2+FooterGap, 150, shopAddressNameRect.size.height)];
    [self addSubview:_shopAddressName];
    
    
    //中间分割线
    _lineView2 = [[UIView alloc]initWithFrame:CGRectMake(FooterGap, H1+H2+FooterGap+H3, ScreenWidth-FooterGap-FooterGap, 20)];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, _lineView2.frame.size.height/2, _lineView2.frame.size.width, 1)];
    line2.backgroundColor = ColorWithHexRGB(0x666666);
    [_lineView2 addSubview:line2];
    [self addSubview:_lineView2];
    
    //联系方式
    _contactInformation = [[UILabel alloc]initWithFrame:CGRectMake(FooterGap, H1+H2+FooterGap+H3+H4+FooterGap, ScreenWidth-FooterGap-FooterGap, 10)];
    _contactInformation.backgroundColor = [UIColor clearColor];
    _contactInformation.font = [UIFont systemFontOfSize:10];
    _contactInformation.textColor = ColorWithHexRGB(0x999999);
    _contactInformation.text = @"联系方式";
    
    //phone联系方式
    _phone = [[UILabel alloc]initWithFrame:CGRectMake(FooterGap, H1+H2+FooterGap+H3+H4+FooterGap+H5+FooterGap, ScreenWidth-FooterGap-FooterGap, 20)];
    _phone.backgroundColor = [UIColor clearColor];
    _phone.font = [UIFont systemFontOfSize:15];
    _phone.textColor = ColorWithHexRGB(0x999999);
    _phone.text = data.phoneText;
    [self addSubview:_phone];
    

    //email联系联系方式
    _mail = [[UILabel alloc]initWithFrame:CGRectMake(FooterGap, H1+H2+10+H3+H4+H5+10+H6+24, ScreenWidth-FooterGap-FooterGap, 20)];
    _mail.backgroundColor = [UIColor clearColor];
    _mail.font = [UIFont systemFontOfSize:15];
    _mail.textColor = ColorWithHexRGB(0x999999);
    _mail.text = data.mailText;
    [self addSubview:_mail];
    
    //分享
    _shareView = [[UIView alloc]initWithFrame:CGRectMake(0, H1+H2+FooterGap+H3+H4+FooterGap+H5+FooterGap+H6+24+H7+FooterGap , ScreenWidth , 40)];
    ShareView *share = [[ShareView alloc]initWithFrame:CGRectMake(0, 0, _shareView.frame.size.width, _shareView.frame.size.height)];
    [_shareView addSubview:share];
    [self addSubview:_shareView];
    
    _totalHeight = H1+H2+10+H3+H4+10+H5+10+H6+24+H7+10+H8;
    
//    _lineView1.backgroundColor = [UIColor redColor];
//    _shopAddress.backgroundColor = [UIColor orangeColor];
//    _shopAddressName.backgroundColor = [UIColor yellowColor];
//    _lineView2.backgroundColor = [UIColor greenColor];
//    _contactInformation.backgroundColor = [UIColor blueColor];
//    _phone.backgroundColor = [UIColor purpleColor];
//    _mail.backgroundColor = [UIColor blackColor];
}

-(void)initWithTarget:(id)target{
    _target = target;
}

@end
