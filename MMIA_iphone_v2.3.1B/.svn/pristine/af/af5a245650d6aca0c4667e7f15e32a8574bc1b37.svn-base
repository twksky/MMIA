//
//  MMiaMagezineTypeView.m
//  MMIA
//
//  Created by lixiao on 14-9-12.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaMagezineTypeView.h"
#import "MMiaMagezineTypeCell.h"

#define SURE_BUTTON_TAG    100
#define CANCEL_BUTTON_TAG  101
#define BgView_Height   250

@implementation MMiaMagezineTypeView{
    int          _selectType;
    NSArray *_firstArr;
    NSArray *_secondArr;
    UIView  *_bgView;
}
- (id)initWithFrame:(CGRect)frame selctStr:(NSString *)selectType
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.4];
        _firstArr=[[NSArray alloc]init];
        _secondArr=[[NSArray  alloc]init];
        _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-BgView_Height, CGRectGetWidth(self.frame), BgView_Height)];
        _bgView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_bgView];
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
         NSString *typePath = [documentsDirectory stringByAppendingPathComponent:@"magezineType.plist"];
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:typePath])
        {
           _firstArr = [NSArray arrayWithContentsOfFile:typePath];
            _secondArr=[[_firstArr objectAtIndex:0]objectForKey:@"cats"];
            self.item=[[MagezineTypeItem alloc]init];
            self.item.fistType=[[_firstArr objectAtIndex:0]objectForKey:@"name"];
            self.item.fistId=[[[_firstArr objectAtIndex:0]objectForKey:@"id"]intValue];
            self.item.secondType=[[_secondArr objectAtIndex:0]objectForKey:@"name"];
            self.item.secondId=[[[_secondArr objectAtIndex:0]objectForKey:@"id"]intValue];
        }
        self.pickView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 50,CGRectGetWidth(self.frame), 200)];
        self.pickView.backgroundColor=[UIColor clearColor];
        self.pickView.delegate=self;
        self.pickView.dataSource=self;
          self.pickView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
       self.pickView.showsSelectionIndicator = YES;
        [_bgView addSubview:self.pickView];
        

//        int row=[self selectMagezineType:selectType];
//        [self.pickView selectRow:row inComponent:0 animated:YES];
//        [self.pickView reloadComponent:1];
        
        UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40)];
        headView.backgroundColor=UIColorFromRGB(0xf4f4f4);
        [_bgView addSubview:headView];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, headView.frame.size.height-1, headView.frame.size.width, 1)];
        lineView.backgroundColor = UIColorFromRGB(0xd3d3d3);
        [headView addSubview:lineView];
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(_bgView.frame)-50)/2, 10,50, 20)];
        titleLabel.font=[UIFont systemFontOfSize:16];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.textColor=UIColorFromRGB(0xc3c3c3);
        titleLabel.text=@"请选择";
        [_bgView addSubview:titleLabel];
        UIButton *cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 40, 20)];
        cancelButton.tag=CANCEL_BUTTON_TAG;
        [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [cancelButton setTitleColor:UIColorFromRGB(0xce212a) forState:UIControlStateNormal];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_bgView addSubview:cancelButton];
        
        UIButton *sureButton=[[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(_bgView.frame)-50, 10, 40, 20)];
        sureButton.tag=SURE_BUTTON_TAG;
        [sureButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
         [sureButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [sureButton setTitleColor:UIColorFromRGB(0xce212a) forState:UIControlStateNormal];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_bgView addSubview:sureButton];
        
    }
    return self;
}
-(void)buttonClick:(UIButton *)button
{
    
    if (button.tag==CANCEL_BUTTON_TAG) {
        [UIView animateWithDuration:0.2 animations:^{
            [self removeFromSuperview];
        }];
    }else{
        if ([self.delegate respondsToSelector:@selector(sendMMiaMagezineType:)])
        {
            [self.delegate sendMMiaMagezineType:self];
        }
        [UIView animateWithDuration:0.2 animations:^{
            [self removeFromSuperview];
        }];
        
    }
}

-(int)selectMagezineType:(NSString *)selectStr
{
    
    for (int i=0; i<_secondArr.count; i++)
    {
        NSString *typeStr=[[_secondArr objectAtIndex:i]objectForKey:@"name"];
        if ([selectStr isEqualToString:typeStr])
        {
            return i;
        }
    }
    return 100;
}
#pragma mark -UIPickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0)
    {
        return _firstArr.count;
    }else
    {
        return _secondArr.count;
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *titleLabel=[[UILabel alloc]init];
    if (component==0)
    {
        titleLabel.frame=CGRectMake(0, 0, 180, 30);
        titleLabel.text=[[_firstArr objectAtIndex:row]objectForKey:@"name"];
        titleLabel.textAlignment=MMIATextAlignmentCenter;
        [titleLabel setFont:[UIFont systemFontOfSize:16]];
        titleLabel.backgroundColor=[UIColor clearColor];
    }else
    {
        titleLabel.frame=CGRectMake(0, 0, 100, 30);
        titleLabel.text=[[_secondArr objectAtIndex:row]objectForKey:@"name"];
        titleLabel.textAlignment=MMIATextAlignmentCenter;
        [titleLabel setFont:[UIFont systemFontOfSize:16]];
        titleLabel.backgroundColor=[UIColor clearColor];
    }
    return titleLabel;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_firstArr.count==0 ) {
        return;
    }
    if (component==0)
    {
        _secondArr=[[_firstArr objectAtIndex:row]objectForKey:@"cats"];
        self.item.fistType=[[_firstArr objectAtIndex:row]objectForKey:@"name"];
        self.item.fistId=[[[_firstArr objectAtIndex:row]objectForKey:@"id"]intValue];
        self.item.secondType=[[_secondArr objectAtIndex:0]objectForKey:@"name"];
        self.item.secondId=[[[_secondArr objectAtIndex:0]objectForKey:@"id"]intValue];
        [self.pickView selectRow:0 inComponent:1 animated:NO];
        [self.pickView reloadComponent:1];
    }else
    {
      self.item.secondType=[[_secondArr objectAtIndex:row]objectForKey:@"name"];
        self.item.secondId=[[[_secondArr objectAtIndex:row]objectForKey:@"id"]intValue];
    }
}
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
//    return 100;
//}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
