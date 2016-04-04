//
//  ProductHeader.m
//  MMIA
//
//  Created by twksky on 15/6/8.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "ProductHeader.h"

#define H1 _brandLogo.frame.size.height
#define H2 _singelName.frame.size.height
#define H3 _singelDescription.frame.size.height
#define SingelHeaderGap 10
#define BrandLogoBtnWidth 50
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@implementation ProductHeader

- (void)awakeFromNib {
    // Initialization code
    //品牌logo按钮。可以跳转到品牌列表页
    
    
    UIButton* brandLogoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    brandLogoBtn.frame = CGRectMake(0, 0, BrandLogoBtnWidth, BrandLogoBtnWidth);
//    brandLogoBtn.backgroundColor = [UIColor yellowColor];
    [brandLogoBtn addTarget:self action:@selector(pushBrand:) forControlEvents:UIControlEventTouchUpInside];
    _brandLogo.userInteractionEnabled = YES;
    [_brandLogo addSubview:brandLogoBtn];
    
    
    //单品名字
    _singelName.font = [UIFont systemFontOfSize:15];
    _singelName.textColor = ColorWithHexRGB(0x999999);
//    _singelName.backgroundColor = [UIColor redColor];
    _singelName.text = self.productModel.title;
    [_singelName setNumberOfLines:0];
    CGSize singelNameSize = [GlobalFunction getTextSizeWithSystemFont:_singelName.font ConstrainedToSize:CGSizeMake(Main_Screen_Width-20, 1000) string:_productModel.title];
    
    [_singelName setFrame:CGRectMake(SingelHeaderGap, SingelHeaderGap+H1+SingelHeaderGap, ScreenWidth-SingelHeaderGap-SingelHeaderGap, singelNameSize.height)];
    
    
    //单品描述
    _singelDescription.font = [UIFont systemFontOfSize:10];
    _singelDescription.textColor = ColorWithHexRGB(0x999999);
//    _singelDescription.backgroundColor = [UIColor redColor];
    _singelDescription.text = self.productModel.describe;
    [_singelDescription setNumberOfLines:0];
    CGSize singelDescriptionSize = [GlobalFunction getTextSizeWithSystemFont:_singelDescription.font ConstrainedToSize:CGSizeMake(Main_Screen_Width-20, 1000) string:_productModel.describe];
    [_singelDescription setFrame:CGRectMake(SingelHeaderGap, SingelHeaderGap+H1+SingelHeaderGap+H2+5, Main_Screen_Width-20, singelDescriptionSize.height)];
    

}

-(void)pushBrand:(UIButton *)btn{
    [_target pushBrand:btn];
}


-(MmiaProductModel *)productModel{
    if (_productModel == nil) {
        _productModel = [[MmiaProductModel alloc]init];
    }
    return _productModel;
}

-(void)initWithTarget:(id)target{
    _target = target;
}

@end
