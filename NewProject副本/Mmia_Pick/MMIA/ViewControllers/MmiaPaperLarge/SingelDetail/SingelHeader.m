//
//  SingelHeader.m
//  MMIA
//
//  Created by twksky on 15/6/2.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "SingelHeader.h"
#import "DataController.h"

#define H1 _brandLogoBtn.frame.size.height
#define H2 _singelName.frame.size.height
#define H3 _singelDescription.frame.size.height
#define SingelHeaderGap 10
#define BrandLogoBtnWidth 50
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation SingelHeader

- (void)awakeFromNib {
    // Initialization code
    DataController *data = [DataController sharedSingle];
    
    //品牌logo按钮。可以跳转到平拍列表页
    _brandLogoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _brandLogoBtn.frame = CGRectMake(SingelHeaderGap, SingelHeaderGap, BrandLogoBtnWidth, BrandLogoBtnWidth);
    [_brandLogoBtn addTarget:_target action:@selector(pushBrand:) forControlEvents:UIControlEventTouchUpInside];
    _brandLogoBtn.backgroundColor = [UIColor redColor];
    [_brandLogoBtn setImage:[UIImage imageNamed:data.brandLogoBtnImageName] forState:UIControlStateNormal];
    [self addSubview:_brandLogoBtn];
    
    //单品名字
    _singelName = [[UILabel alloc]init];
    _singelName.font = [UIFont systemFontOfSize:15];
    _singelName.textColor = ColorWithHexRGB(0x999999);
    _singelName.text = data.singelNameText;
    [_singelName setNumberOfLines:0];
    CGSize singelNameSize = CGSizeMake(ScreenWidth-SingelHeaderGap-SingelHeaderGap, MAXFLOAT);
    CGRect singelNameRect = [_singelName.text boundingRectWithSize:singelNameSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_singelName.font} context:nil];
    [_singelName setFrame:CGRectMake(SingelHeaderGap, SingelHeaderGap+H1+SingelHeaderGap, ScreenWidth-SingelHeaderGap-SingelHeaderGap, singelNameRect.size.height)];
    [self addSubview:_singelName];
    
    
    //单品描述
    _singelDescription = [[UILabel alloc]init];
    _singelDescription.font = [UIFont systemFontOfSize:10];
    _singelDescription.textColor = ColorWithHexRGB(0x999999);
    _singelDescription.text = data.singelDescriptionText;
    [_singelDescription setNumberOfLines:0];
    CGSize singelDescriptionSize = CGSizeMake(ScreenWidth-SingelHeaderGap-SingelHeaderGap, MAXFLOAT);
    CGRect singelDescriptionRect = [_singelDescription.text boundingRectWithSize:singelDescriptionSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_singelDescription.font} context:nil];
    [_singelDescription setFrame:CGRectMake(SingelHeaderGap, SingelHeaderGap+H1+SingelHeaderGap+H2+5, ScreenWidth-SingelHeaderGap-SingelHeaderGap, singelDescriptionRect.size.height)];
    [self addSubview:_singelDescription];
        
}

-(void)initWithTarget:(id)target{
    NSLog(@"?");
    _target = target;
}

@end
