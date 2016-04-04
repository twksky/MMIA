//
//  MMiaFunsTableViewCell.m
//  MMIA
//
//  Created by lixiao on 14-9-17.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaFunsTableViewCell.h"

@implementation MMiaFunsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.contentView.backgroundColor=[UIColor whiteColor];
//        self.contentView.layer.cornerRadius=5.0;
//        self.contentView.layer.borderColor=[UIColorFromRGB(0xE1E1E1)CGColor];
//        self.contentView.layer.borderWidth=1.0;
   }
    return self;
}
    
- (UIImageView *)headImageView
{
    if( !_headImageView )
    {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.backgroundColor = [UIColor clearColor];
        _headImageView.frame=CGRectMake(10, 7.5, 45, 45);
        [self.contentView addSubview:_headImageView];
    }
    return _headImageView;
}
- (UILabel *)titleLable
{
    if( !_titleLable )
    {
        _titleLable = [[UILabel alloc] init];
        _titleLable.frame=CGRectMake(60, 0, 120, 30);
        _titleLable.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
        _titleLable.textAlignment = MMIATextAlignmentLeft;
        
        [self.contentView addSubview:_titleLable];
    }
    return _titleLable;
}
-(UILabel *)subTitleLabel
{
    if( !_subTitleLabel )
    {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.frame=CGRectMake(60, 30, 120, 15);
        _subTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.textColor = [UIColor darkGrayColor];
        _subTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
        _subTitleLabel.textAlignment = MMIATextAlignmentLeft;
        
        [self.contentView addSubview:_subTitleLabel];
    }
    return _subTitleLabel;
}
-(UIButton *)concernButton
{
    if (!_concernButton)
    {
       
        UIImage *image=[UIImage imageNamed:@"attentionsmall_quxiao.png"];
         _concernButton=[[UIButton alloc]init];
        _concernButton.backgroundColor=[UIColor clearColor];
        _concernButton.layer.cornerRadius=4.0;
       
       // _concernButton.layer.borderWidth=1;
       // _concernButton.layer.borderColor=[UIColorFromRGB(0xCE212A)CGColor];
        _concernButton.frame=CGRectMake(300-image.size.width-7, (60-image.size.height)/2, image.size.width, image.size.height);
        
        [self.contentView addSubview:_concernButton];
        
    }
    return _concernButton;
}
-(UIView *)lineView
{
    if (!_lineView)
    {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor = UIColorFromRGB(0xd3d3d3);
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end

@implementation MMiaMagezineListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIImage *image=[UIImage imageNamed:@"lock_icon.png"];
        self.isPublicImageView=[[UIImageView alloc]initWithImage:image];
        self.isPublicImageView.frame=CGRectMake(10, (60-image.size.height)/2, image.size.width, image.size.height);
        self.isPublicImageView.image=image;
        [self.contentView addSubview:self.isPublicImageView];
        
        
        self.magezineImageView=[[UIImageView alloc]initWithFrame:CGRectMake(image.size.width+20, 10, 40, 40)];
        [self.contentView addSubview:self.magezineImageView];
      
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.magezineImageView.frame)+10, (60-20)/2, 150, 20)];
        self.titleLabel.contentMode= UIViewContentModeCenter;
        self.titleLabel.textColor=[UIColor blackColor];
        [self.contentView addSubview: self.titleLabel];
        
        
        UIImage *image2=[UIImage imageNamed:@"personal_11.png"];
        self.selectImageView=[[UIImageView alloc]initWithImage:image2];
        self.selectImageView.frame=CGRectMake(App_Frame_Width-10-image2.size.width, (60-image2.size.height)/2, image2.size.width, image2.size.height);
        [self.contentView addSubview:self.selectImageView];
   

         }
    return self;

}



@end
