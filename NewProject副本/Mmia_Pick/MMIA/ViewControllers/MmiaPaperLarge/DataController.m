//
//  DataController.m
//  MMIA
//
//  Created by twksky on 15/5/29.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "DataController.h"
#import "BrandHeader.h"

#define header_H1 brandDescription.frame.size.height
#define header_H2 lineView.frame.size.height
#define header_H3 officalWebsite.frame.size.height
#define header_H4 officalWebsiteName.frame.size.height
#define header_H5 title.frame.size.height


#define footer_H1 lineView1.frame.size.height
#define footer_H2 shopAddress.frame.size.height
#define footer_H3 shopAddressName.frame.size.height
#define footer_H4 lineView2.frame.size.height
#define footer_H5 contactInformation.frame.size.height
#define footer_H6 phone.frame.size.height
#define footer_H7 mail.frame.size.height
#define footer_H8 shareView.frame.size.height

#define singelHeader_H1 brandLogoBtn.frame.size.height
#define singelHeader_H2 singelName.frame.size.height
#define singelHeader_H3 singelDescription.frame.size.height


@implementation DataController

static DataController *dataController = nil;
+(DataController *)sharedSingle{
    if (!dataController) {
        dataController = [[DataController alloc]init];
    }
    return dataController;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    if (dataController ==nil) {
        dataController = [super allocWithZone:zone];
    }
    return dataController;
}


//品牌详情页头的高度
-(CGFloat)headHeightWithWeight:(CGFloat)Weight{
    
    //品牌描述
    UILabel *brandDescription = [[UILabel alloc]init];
    brandDescription.Frame = CGRectMake(10, 10, Weight-20, 10);
    brandDescription.font = [UIFont systemFontOfSize:10];
    brandDescription.textColor = ColorWithHexRGB(0x666666);
    brandDescription.text = self.brandDescriptionText;
    [brandDescription setNumberOfLines:0];
    CGSize brandDescriptionSize = CGSizeMake(Weight-20, MAXFLOAT);
    CGRect brandDescriptionRect = [brandDescription.text boundingRectWithSize:brandDescriptionSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:brandDescription.font} context:nil];
    [brandDescription setFrame:brandDescriptionRect];
    
    //华丽分分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, brandDescription.frame.size.width, 20);
    
    //官网
    UILabel *officalWebsite = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, Weight, 10)];
    
    //官网的名字
    UIButton *officalWebsiteName = [UIButton buttonWithType:UIButtonTypeCustom];
    [officalWebsiteName setTitle:self.officalWebsiteNameText forState:UIControlStateNormal];
    [officalWebsiteName.titleLabel setFont:[UIFont systemFontOfSize:15]];
    
    CGSize officalWebsiteNamesiteSize = CGSizeMake(MAXFLOAT, 15);
    CGRect officalWebsiteNameRect = [officalWebsiteName.titleLabel.text boundingRectWithSize:officalWebsiteNamesiteSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:officalWebsiteName.titleLabel.font} context:nil];
    officalWebsiteName.frame = CGRectMake(10, 1,officalWebsiteNameRect.size.width, 15);
    
    //华丽的分割线2
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10, 1, lineView.frame.size.width, 1)];
    
    //标题
    UILabel *title = [[UILabel alloc]init];
    title.frame = CGRectMake(10, 10, Weight-20, 20);
    title.font = [UIFont systemFontOfSize:20];
    title.text = self.titleText;
    
    
    return 10+(header_H1)+(header_H2)+(header_H3)+8+(header_H4)+10+10+header_H5+10;
    
}

//品牌详情页尾的高度
-(CGFloat)footHeightWithWeight:(CGFloat)Weight{
    
    
    //最上层的分割线
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 1, 20)];
    
    //门店地址
    UILabel *shopAddress = [[UILabel alloc]initWithFrame:CGRectMake(10, 1, 1, 10)];
    
    //门店地址名字
    UILabel *shopAddressName = [[UILabel alloc]initWithFrame:CGRectMake(10, 1, 1, 20)];
    //    _shopAddressName.backgroundColor = [UIColor blackColor];
    shopAddressName.font = [UIFont systemFontOfSize:15];
    shopAddressName.text = self.shopAddressNameText;
    [shopAddressName setNumberOfLines:0];
    CGSize shopAddressNameSize = CGSizeMake(150, MAXFLOAT);
    CGRect shopAddressNameRect = [shopAddressName.text boundingRectWithSize:shopAddressNameSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:shopAddressName.font} context:nil];
    [shopAddressName setFrame:shopAddressNameRect];
    
    //中间分割线
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(10, 1, 1, 20)];
    
    
    //联系方式
    UILabel *contactInformation = [[UILabel alloc]initWithFrame:CGRectMake(10, 1, 1, 10)];
    contactInformation.font = [UIFont systemFontOfSize:10];
    contactInformation.text = @"联系方式";

    
    //phone联系方式
    UILabel *phone = [[UILabel alloc]initWithFrame:CGRectMake(10, 1, 1, 20)];
    phone.font = [UIFont systemFontOfSize:15];
    phone.text = self.phoneText;
    [phone setNumberOfLines:0];
    CGSize phoneSize = CGSizeMake(Weight, MAXFLOAT);
    CGRect phoneRect = [phone.text boundingRectWithSize:phoneSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:phone.font} context:nil];
    [phone setFrame:phoneRect];
    
    //email联系联系方式
    UILabel *mail = [[UILabel alloc]initWithFrame:CGRectMake(10, 1, 1, 20)];
    mail.font = [UIFont systemFontOfSize:15];
    mail.text = self.mailText;
    [mail setNumberOfLines:0];
    CGSize mailSize = CGSizeMake(Weight, MAXFLOAT);
    CGRect mailRect = [mail.text boundingRectWithSize:mailSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:mail.font} context:nil];
    [mail setFrame:mailRect];
    
    //分享
    UIView *shareView = [[UIView alloc]initWithFrame:CGRectMake(0, 1 , 1 , 40)];
    
//    NSLog(@"%f,%f,%f,%f,%f,%f,%f,%f",footer_H1,footer_H2,footer_H3,footer_H4,footer_H5,footer_H6,footer_H7,Weight);
    return footer_H1+footer_H2+10+footer_H3+footer_H4+10+footer_H5+10+footer_H6+24+footer_H7+10+footer_H8;
    
}

//单品详情页的头的高度
-(CGFloat)singelHeadHeightWithWeight:(CGFloat)Weight{
    //品牌logo按钮。可以跳转到平拍列表页
    UIButton *brandLogoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    brandLogoBtn.frame = CGRectMake(1, 1, 50, 50);
    
    //单品名字
    UILabel *singelName = [[UILabel alloc]init];
    singelName.font = [UIFont systemFontOfSize:15];
    singelName.text = self.singelNameText;
    [singelName setNumberOfLines:0];
    CGSize singelNameSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, MAXFLOAT);
    CGRect singelNameRect = [singelName.text boundingRectWithSize:singelNameSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:singelName.font} context:nil];
    [singelName setFrame:CGRectMake(1, 1, [UIScreen mainScreen].bounds.size.width-20, singelNameRect.size.height)];
    
    //单品描述
    UILabel *singelDescription = [[UILabel alloc]init];
    singelDescription.font = [UIFont systemFontOfSize:10];
    singelDescription.text = self.singelDescriptionText;
    [singelDescription setNumberOfLines:0];
    CGSize singelDescriptionSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, MAXFLOAT);
    CGRect singelDescriptionRect = [singelDescription.text boundingRectWithSize:singelDescriptionSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:singelDescription.font} context:nil];
    [singelDescription setFrame:CGRectMake(1, 1, [UIScreen mainScreen].bounds.size.width-20, singelDescriptionRect.size.height)];
    
    return 10 + singelHeader_H1 + 10 + singelHeader_H2 + 5 + singelHeader_H3 + 10;
}

-(CGFloat)brandCellHeightWithWeight:(CGFloat)Weight{
    CGFloat H = 0;
    
    for (int i = 0 ; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.brandCellImageName]];
        imageView.frame = CGRectMake(10, 0 + H, 1, 150 );
        
        UILabel *imageDescription = [[UILabel alloc]init];
        imageDescription.font = [UIFont systemFontOfSize:10];
        imageDescription.text = self.brandCellImageDescriptionText;
        [imageDescription setNumberOfLines:0];
        CGSize imageDescriptionSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, MAXFLOAT);
        CGRect imageDescriptionRect = [imageDescription.text boundingRectWithSize:imageDescriptionSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:imageDescription.font} context:nil];
        imageDescription.frame = CGRectMake(10 , imageView.frame.origin.y+imageView.frame.size.height+10, [UIScreen mainScreen].bounds.size.width-20, imageDescriptionRect.size.height);
        
        H = H +imageView.frame.size.height + 10 +imageDescription.frame.size.height + 10;
    }
    return H-10;
}

-(CGFloat)singelCellHeightWithWeight:(CGFloat)Weight{
    
    CGFloat H = 0;
    for (int i = 0 ; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.singelCellImageName]];
        imageView.frame = CGRectMake(10, 0 + H, 1, 150 );
        
        UILabel *imageDescription = [[UILabel alloc]init];
        imageDescription.font = [UIFont systemFontOfSize:10];
        imageDescription.text = self.singelCellImageDescriptionText;
        [imageDescription setNumberOfLines:0];
        CGSize imageDescriptionSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-20, MAXFLOAT);
        CGRect imageDescriptionRect = [imageDescription.text boundingRectWithSize:imageDescriptionSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:imageDescription.font} context:nil];
        imageDescription.frame = CGRectMake(10 , imageView.frame.origin.y+imageView.frame.size.height+10, [UIScreen mainScreen].bounds.size.width-20, imageDescriptionRect.size.height);
        
        H = H +imageView.frame.size.height + 10 +imageDescription.frame.size.height + 10;
    }
    return H;
}


-(NSString *)brandDescriptionText{
    return @"关于品牌的描述，吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦";
}

-(NSString *)officalWebsiteNameText{
    return @"www.baidu.com";
}

-(NSString *)titleText{
    return @"标题";
}

-(NSString *)shopAddressNameText{
    return @"北京西城区金融街国际企业大厦,北京西城区金融街国际企业大厦";
}

-(NSString *)phoneText{
    return @"010-12345678";
}

-(NSString *)mailText{
    return @"HR@mmia.com";
}

-(NSString *)brandLogoBtnImageName{
    return @"photo3,jpg";
}

-(NSString *)singelNameText{
    return @"福特野马哈哈哈啊好";
}

-(NSString *)singelDescriptionText{
    return @"【快速消灭打嗝五秘法】 打嗝是一件非常令人尴尬的事，别担心，以后不用再烦恼了，上秘招！1.喝一大口醋（红白皆可），立竿见影。2.深吸一口气，憋住，弯腰90度，缓慢呼气，重复10—15次。3.用干净的勺子把舌头压住，几分钟后打嗝会停。4.快速喝下一大杯温水。5.抱双膝并压迫胸部。转走试试吧";
}

-(NSString *)brandCellImageName{
    return @"photo1.jpg";
}

-(NSString *)brandCellImageDescriptionText{
    return @"我是上面图片的描述:吧啦吧啦吧啦，吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦，吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦吧啦，吧啦吧啦吧啦吧啦吧啦吧啦！";
}

-(NSString *)singelCellImageName{
    return @"photo3.jpg";
}

-(NSString *)singelCellImageDescriptionText{
    return @"我是单品页面的图片描述，！！！！我是单品页面的图片描述，！！！！我是单品页面的图片描述，！！！！我是单品页面的图片描述，！！！！我是单品页面的图片描述，！！！！我是单品页面的图片描述，！！！！我是单品页面的图片描述，！！！！我是单品页面的图片描述，！！！！我是单品页面的图片描述，！！！！我是单品页面的图片描述，！！！！我是单品页面的图片描述，！！！！我是单品页面的图片描述，！！！！";
}


@end



