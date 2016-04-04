//
//  BrandHeader.m
//  MMIA
//
//  Created by twksky on 15/5/27.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "BrandHeader.h"

#define H1 self.brandDescription.frame.size.height
#define H2 self.lineView.frame.size.height
#define H3 self.officalWebsite.frame.size.height
#define H4 self.officalWebsiteName.frame.size.height
#define H5 self.title.frame.size.height
#define HeadGap 10
#define ScreenWidth [UIScreen mainScreen].bounds.size.width


@implementation BrandHeader


- (void)awakeFromNib {
    // Initialization code
    
//    [DataController headDatabrandDescription:self.brandDescription lineView:self.lineView officalWebsite:self.officalWebsite officalWebsiteName:_officalWebsiteName title:_title brandHeader:self totalHeight:self.totalHeight];

    //品牌描述
//    self.brandDescription.Frame = CGRectMake(Gap, Gap, self.frame.size.width-20, 1);
    
    self.brandDescription.font = [UIFont systemFontOfSize:10];
    self.brandDescription.textColor = ColorWithHexRGB(0x666666);
    self.brandDescription.text = self.brandModel.describe;
    [self.brandDescription setNumberOfLines:0];
    CGSize brandDescriptionSize = CGSizeMake(ScreenWidth-HeadGap-HeadGap, MAXFLOAT);
    CGRect brandDescriptionRect = [self.brandDescription.text boundingRectWithSize:brandDescriptionSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.brandDescription.font} context:nil];
    self.brandDescription.frame = CGRectMake(HeadGap, HeadGap, ScreenWidth-HeadGap-HeadGap, brandDescriptionRect.size.height);

    
    [self addSubview:self.brandDescription];
    
    //分割线
    self.lineView.frame = CGRectMake(0, H1-1, self.brandDescription.frame.size.width, 20);
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.lineView.frame.size.height/2, self.lineView.frame.size.width, 1)];
    line.backgroundColor = ColorWithHexRGB(0x666666);
    [self.lineView addSubview:line];
    [self.brandDescription addSubview:self.lineView];
    
    //官网
    self.officalWebsite.backgroundColor = [UIColor clearColor];
    self.officalWebsite.font = [UIFont systemFontOfSize:10];
    self.officalWebsite.textColor = ColorWithHexRGB(0x666666);
    self.officalWebsite.text = @"官方网站";
    [self.officalWebsite setNumberOfLines:0];
    [self.officalWebsite setFrame:CGRectMake(HeadGap, HeadGap+H1+H2, ScreenWidth-HeadGap-HeadGap, 10)];
    [self addSubview:self.officalWebsite];

    
    //官网的名字
    [self.officalWebsiteName setTitle:self.brandModel.officalWebsite forState:UIControlStateNormal];
    [self.officalWebsiteName setTitleColor:ColorWithHexRGB(0x666666) forState:UIControlStateNormal];
    [self.officalWebsiteName.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [self.officalWebsiteName addTarget:_target action:@selector(pushWebView:) forControlEvents:UIControlEventTouchUpInside];
    
    self.officalWebsiteName.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    CGSize officalWebsiteNamesiteSize = CGSizeMake(MAXFLOAT, 15);
    CGRect officalWebsiteNameRect = [self.officalWebsiteName.titleLabel.text boundingRectWithSize:officalWebsiteNamesiteSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.officalWebsiteName.titleLabel.font} context:nil];
    
    self.officalWebsiteName.frame = CGRectMake(HeadGap, HeadGap+H1+H2+H3+8,officalWebsiteNameRect.size.width, 15);
    
    [self addSubview:self.officalWebsiteName];
    
    //华丽的分割线2
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(HeadGap, (HeadGap+(H1)+(H2)+(H3)+8+(H4)+HeadGap), self.lineView.frame.size.width, 1)];
    line2.backgroundColor = ColorWithHexRGB(0x666666);
    [self addSubview:line2];
    
    
    //标题
    self.title.backgroundColor = [UIColor clearColor];
    self.title.font = [UIFont systemFontOfSize:20];
    self.title.textColor = ColorWithHexRGB(0x333333);
    self.title.text = self.brandModel.title;
    [self.title setNumberOfLines:1];
    [self.title setFrame:CGRectMake(HeadGap, HeadGap+(H1)+(H2)+(H3)+8+(H4)+HeadGap+HeadGap, ScreenWidth-HeadGap-HeadGap, 20)];
    self.title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.title];
    
    self.totalHeight = HeadGap+(H1)+(H2)+(H3)+8+(H4)+H5+HeadGap+HeadGap+HeadGap;
    
}

-(UILabel *)brandDescription{
    if (_brandDescription == nil) {
        _brandDescription = [[UILabel alloc]init];
    }

    return _brandDescription;
}

-(UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
    }
    return _lineView;
}

-(UILabel *)officalWebsite{
    if (_officalWebsite == nil) {
        _officalWebsite = [[UILabel alloc]init];
    }
    return _officalWebsite;
}

-(UIButton *)officalWebsiteName{
    if (_officalWebsiteName == nil) {
        _officalWebsiteName = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _officalWebsiteName;
}

-(UILabel *)title{
    if (_title == nil) {
        _title = [[UILabel alloc]init];
    }
    return _title;
}

-(void)initWithTarget:(id)target{
    _target = target;
}

@end
