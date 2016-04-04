//
//  BrandFooter.m
//  MMIA
//
//  Created by yhx on 15/5/28.
//   Copyright (c) 2015年 yhx. All rights reserved.
//

#import "BrandFooter.h"


@interface BrandFooter ()

//@property (strong, nonatomic) IBOutlet UIView  *lineView;
//@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
//@property (strong, nonatomic) IBOutlet UILabel *shopAddress;
//@property (strong, nonatomic) IBOutlet UIView  *nextLineView;
//@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
//@property (strong, nonatomic) IBOutlet UILabel *phoneNumber;
//@property (strong, nonatomic) IBOutlet UIView  *lastLineView;
//@property (strong, nonatomic) IBOutlet UIView  *shareView;
@property (strong, nonatomic) UIView*  shopAddressView;
@property (strong, nonatomic) UILabel* addressName;
@property (strong, nonatomic) UILabel* phoneLabel;
@property (strong, nonatomic) UIView  *shareView;

@end

@implementation BrandFooter

- (void)awakeFromNib
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView* line = [self lineView];
        [self.shopAddressView addSubview:line];
        self.shopAddressView.hidden = YES;
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.shopAddressView);
            make.left.equalTo(self.shopAddressView.mas_left).offset(KProductDetailPicture_LeftMargin);
            make.right.equalTo(self.shopAddressView.mas_right).offset(-KProductDetailPicture_LeftMargin);
            make.height.equalTo(@(KProductHeader_TextLineHeight));
        }];
        [self addSubview:self.shareView];
    }
    return self;
}

- (UIView *)shopAddressView
{
    if( !_shopAddressView )
    {
        //lx change
        //_shopAddressView = [[UIView alloc] initWithFrame:self.frame];
        UIImage *goodImage = [UIImage imageNamed:@"点赞.png"];
        _shopAddressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height - goodImage.size.height - 20)];
        //lx end
        _shopAddressView.backgroundColor = UIColorClear;
        [self addSubview:_shopAddressView];
        
//        [_shopAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
//               make.edges.equalTo(self);
//        }];
    }
    return _shopAddressView;
}

//lx add 增加分享view
- (UIView *)shareView
{
    if (!_shareView)
    {
         UIImage *goodImage = [UIImage imageNamed:@"点赞.png"];
        _shareView = [[UIView alloc]init];
        _shareView.frame = CGRectMake(0, self.height - goodImage.size.height - 20, self.width, goodImage.size.height + 20);
        _shareView.backgroundColor = [UIColor clearColor];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.width - 20, 0.5)];
        lineView.backgroundColor = ColorWithHexRGB(0x999999);
        [_shareView addSubview:lineView];
        
        //点赞button
        UIButton *goodButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, goodImage.size.width + 20, goodImage.size.height)];
        goodButton.tag = 200;
        [goodButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [goodButton setImage:goodImage forState:UIControlStateNormal];
        [_shareView addSubview:goodButton];
        
        //分享button
        UIImage *shareImage = [UIImage imageNamed:@"分享.png"];
        UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(goodButton.frame), 10, shareImage.size.width + 20, shareImage.size.height)];
        [shareButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        shareButton.tag = 201;
        [shareButton setImage:shareImage forState:UIControlStateNormal];
        [_shareView addSubview:shareButton];

    }
    return _shareView;
}

- (UIView *)lineView
{
    UIView* lineView = UIView.new;
    lineView.backgroundColor = ColorWithHexRGB(0x999999);
    
    return lineView;
}

- (UILabel *)addressName
{
    if( !_addressName )
    {
        _addressName = UILabel.new;
        _addressName.textColor = ColorWithHexRGB(0x999999);
        _addressName.font = UIFontSystem(KProductHeaderDescrib_FontOfSize);
        _addressName.textAlignment = MMIATextAlignmentLeft;
        _addressName.numberOfLines = 0;
        _addressName.text = @"门店地址";
        [self.shopAddressView addSubview:_addressName];
        
        [_addressName mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.shopAddressView.mas_top).offset(KProductDetailPicture_LeftMargin + KProductHeader_TextLineHeight);
            make.left.equalTo(self.shopAddressView.mas_left).offset(KProductDetailPicture_LeftMargin);
            make.right.equalTo(self.shopAddressView.mas_right).offset(-KProductDetailPicture_LeftMargin);
        }];
    }
    
    return _addressName;
}

- (UILabel *)shopAddressContent
{
    UILabel* _shopAddress = UILabel.new;
    _shopAddress.textColor = ColorWithHexRGB(0x999999);
    _shopAddress.font = UIFontSystem(KProductHeaderTitle_FontOfSize);
    _shopAddress.textAlignment = MMIATextAlignmentLeft;
    _shopAddress.numberOfLines = 0;
    
    return _shopAddress;
}

- (UILabel *)phoneLabel
{
    if( !_phoneLabel )
    {
        _phoneLabel = UILabel.new;
        _phoneLabel.textColor = ColorWithHexRGB(0x999999);
        _phoneLabel.font = UIFontSystem(KProductHeaderDescrib_FontOfSize);
        _phoneLabel.textAlignment = MMIATextAlignmentLeft;
        _phoneLabel.numberOfLines = 0;
        _phoneLabel.text = @"联系方式";
        [self.shopAddressView addSubview:_phoneLabel];
    }
    
    return _phoneLabel;
}

- (UILabel *)phoneNumber
{
    UILabel* _phoneNumber = UILabel.new;
    _phoneNumber.textColor = ColorWithHexRGB(0x999999);
    _phoneNumber.font = UIFontSystem(KProductHeaderTitle_FontOfSize);
    _phoneNumber.textAlignment = MMIATextAlignmentLeft;
    _phoneNumber.numberOfLines = 0;
    
    return _phoneNumber;
}

- (void)reloadBrandFooterWithModel:(MmiaPaperProductListModel *)model
{
    if( model.address.count > 0 )
    {
        self.shopAddressView.hidden = NO;
        // 地址
        UIView* aLastView = self.addressName;
        for( MmiaBrandAddressModel* addModel in model.address )
        {
            UILabel* addressContent = [self shopAddressContent];
            addressContent.text = addModel.name;
            [self.shopAddressView addSubview:addressContent];
            
            [addressContent mas_makeConstraints:^(MASConstraintMaker *make) {

                make.top.equalTo(aLastView ? aLastView.mas_bottom : @0).offset(KProductHeader_TextMargin);
                make.left.right.equalTo(self.addressName);
            }];
            
            aLastView = addressContent;
        }
        
        // nextLine
        UIView* nextLine = [self lineView];
        [self.shopAddressView addSubview:nextLine];
        
        [nextLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(aLastView.mas_bottom).offset(KProductDetailPicture_LeftMargin);
            make.left.right.equalTo(aLastView);
            make.height.equalTo(@(KProductHeader_TextLineHeight));
        }];
        
        // 联系方式
        UIView* pLastView = self.phoneLabel;
        [pLastView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(nextLine.mas_bottom).offset(KProductDetailPicture_LeftMargin);
            make.left.right.equalTo(nextLine);
        }];
        for( MmiaBrandAddressModel* addModel in model.address )
        {
            UILabel* phoneNumber = [self phoneNumber];
            phoneNumber.text = addModel.name;
            [self.shopAddressView addSubview:phoneNumber];
            
            [phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(aLastView ? pLastView.mas_bottom : @0).offset(KProductHeader_TextMargin);
                make.left.right.equalTo(self.phoneLabel);
            }];
            
            pLastView = phoneNumber;
        }
    }
    
    UIImage *goodImage = [UIImage imageNamed:@"点赞.png"];
    self.shareView.frame = CGRectMake(0, self.height - goodImage.size.height - 20, self.width, goodImage.size.height + 20);
}

#pragma mark - ** 分享button点击事件

- (void)buttonClick:(UIButton *)button
{
    if (self.ClickGoodOrShareButton)
    {
        self.ClickGoodOrShareButton(button);
    }
}

@end
