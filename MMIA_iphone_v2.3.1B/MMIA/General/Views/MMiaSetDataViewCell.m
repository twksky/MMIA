//
//  MMiaSetDataViewCell.m
//  MMIA
//
//  Created by lixiao on 14-6-19.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaSetDataViewCell.h"
#define HEAD_IMAGE_TAG 20



@implementation MMiaSetDataViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initview];
    }
    return self;
}
-(void)initview{
    //self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"personal_12.png"]];
    self.backgroundColor=[UIColor whiteColor];
    self.headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 30, 30)];
    //self.headImageView.image=[UIImage imageNamed:@"personal_03.png"];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImg:)];
    self.headImageView.userInteractionEnabled=YES;
    [self.headImageView addGestureRecognizer:tap];
    [self.contentView addSubview:self.headImageView];
    
    self.typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
    [self.contentView addSubview:self.typeLabel];
    self.typeLabel.font=[UIFont systemFontOfSize:14];
    self.detailTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(100, 5, 200, 30)];
    self.detailTextFiled.delegate=self;
    self.detailTextFiled.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.detailTextFiled];
    
    self.sexView=[[UIView alloc]initWithFrame:CGRectMake(100, 0, 200, 40)];
    self.manBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 12, 16, 16)];
    [self.manBtn setBackgroundImage:[UIImage imageNamed:@"personal_11.png"] forState:UIControlStateNormal];
   // [self.manBtn setBackgroundImage:[UIImage imageNamed:@"personal_10.png"] forState:UIControlStateHighlighted];
    [self.manBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *manLable=[[UILabel alloc]initWithFrame:CGRectMake(20, 5, 20, 30)];
    manLable.text=@"男";
    // manLable.font=[UIFont systemFontOfSize:14];
    
    self.womanBtn=[[UIButton alloc]initWithFrame:CGRectMake(100, 12, 16, 16)];
    [self.womanBtn setBackgroundImage:[UIImage imageNamed:@"personal_11.png"] forState:UIControlStateNormal];
    [self.womanBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //[self.womanBtn setBackgroundImage:[UIImage imageNamed:@"personal_10.png"] forState:UIControlStateHighlighted];
    UILabel *womanlabel=[[UILabel alloc]initWithFrame:CGRectMake(120,5, 20, 30)];
    womanlabel.text=@"女";
   // womanlabel.font=[UIFont systemFontOfSize:14];

    
    [self.sexView addSubview:self.manBtn];
    [self.sexView addSubview:manLable];
    [self.sexView addSubview:self.womanBtn];
    [self.sexView addSubview:womanlabel];
    [self.contentView addSubview:self.sexView];
    

    
}
-(void)buttonClick:(UIButton *)button{
    if (button==self.manBtn) {
       
        [self.manBtn setSelected:YES];
         [self.manBtn setBackgroundImage:[UIImage imageNamed:@"personal_10.png"] forState:UIControlStateNormal];
        [self.womanBtn setBackgroundImage:[UIImage imageNamed:@"personal_11.png"] forState:UIControlStateNormal];
        [self.womanBtn setSelected:NO];
        
    }
    if (button==self.womanBtn) {
        [self.womanBtn setSelected:YES];
        [self.womanBtn setBackgroundImage:[UIImage imageNamed:@"personal_10.png"] forState:UIControlStateNormal];
         [self.manBtn setBackgroundImage:[UIImage imageNamed:@"personal_11.png"] forState:UIControlStateNormal];
        [self.manBtn setSelected:NO];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   // [self.detailTextFiled resignFirstResponder];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)changeImg:(UITapGestureRecognizer *)tap{
    [self.cellDelegate changeImgIn:self.imageView];
       
    
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
