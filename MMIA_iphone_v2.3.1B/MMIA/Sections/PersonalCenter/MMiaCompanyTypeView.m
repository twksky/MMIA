//
//  MMiaCompanyTypeView.m
//  MMIA
//
//  Created by lixiao on 14/11/6.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaCompanyTypeView.h"
#import "MMiaMagezineTypeCell.h"

#define SURE_BUTTON_TAG    100
#define CANCEL_BUTTON_TAG  101
@implementation MMiaCompanyTypeView{
    NSArray *_dataArray;
    UITableView *_tableView;
    int          _selectType;
}
- (id)initWithFrame:(CGRect)frame selctStr:(NSString *)selectType
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor colorWithWhite:0.0 alpha:0.4];
        _dataArray=[NSArray arrayWithObjects:@"家居",@"箱包",@"男装",@"女装",@"珠宝",@"美妆",@"运动",@"电器",@"母婴",@"食品",@"其它", nil];
        UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(10, (CGRectGetHeight(self.frame)-420)/2-15, App_Frame_Width-20, 35)];
        headView.backgroundColor=[UIColor blackColor];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 70, 35)];
        label.text=@"请选择";
        label.textAlignment=MMIATextAlignmentLeft;
        label.font=[UIFont systemFontOfSize:15];
        [label setTextColor:[UIColor whiteColor]];
        label.backgroundColor=[UIColor clearColor];
        [headView addSubview:label];
        [self addSubview:headView];
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(10, headView.frame.origin.y+35, App_Frame_Width-20,420)];
        _tableView.bounces=NO;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=UIColorFromRGB(0xE1E1E1);
        
        [self addSubview:_tableView];
        
        if (selectType==nil)
        {
            _selectType=100;
        }else
        {
            _selectType=[self selectMagezineType:selectType];
        }
    }
    return self;
}
-(int)selectMagezineType:(NSString *)selectStr
{
    
    for (int i=0; i<_dataArray.count; i++)
    {
        NSString *typeStr=[_dataArray objectAtIndex:i];
        if ([selectStr isEqualToString:typeStr])
        {
            return i;
        }
    }
    return 100;
}
#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35.0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMiaMagezineTypeCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[MMiaMagezineTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.typeLabel.text=[_dataArray objectAtIndex:indexPath.row];
    
    if (_selectType==indexPath.row)
    {
        cell.typeImageView.image=[UIImage imageNamed:@"personal_10.png"];
        [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition: UITableViewScrollPositionNone];
        
    }else
    {
        cell.typeImageView.image=[UIImage imageNamed:@"personal_11.png"];
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MMiaMagezineTypeCell *cell=(MMiaMagezineTypeCell *)[_tableView cellForRowAtIndexPath:indexPath];
    cell.typeImageView.image=[UIImage imageNamed:@"personal_10.png"];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MMiaMagezineTypeCell *cell=(MMiaMagezineTypeCell *)[_tableView cellForRowAtIndexPath:indexPath];
    cell.typeImageView.image=[UIImage imageNamed:@"personal_11.png"];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 35;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width-20, 35)];
    
    UIButton *cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 2, (300-15)/2, 30)];
    cancelButton.tag=CANCEL_BUTTON_TAG;
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.backgroundColor=[UIColor whiteColor];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelButton];
    
    //CGRectMake(5, 2, (300-15)/2, 30)
    UIButton *sureButton=[[UIButton alloc]initWithFrame:CGRectMake(App_Frame_Width-20-5-(300-15)/2, 2, (300-15)/2, 30)];
    sureButton.tag=SURE_BUTTON_TAG;
    sureButton.backgroundColor=[UIColor whiteColor];
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:sureButton];
    return view;
}
-(void)buttonClick:(UIButton *)button
{
    
    if (button.tag==CANCEL_BUTTON_TAG) {
        [UIView animateWithDuration:0.2 animations:^{
            [self removeFromSuperview];
        }];
    }else{
        NSIndexPath *indexPath=[_tableView indexPathForSelectedRow];
        MMiaMagezineTypeCell *cell=(MMiaMagezineTypeCell *)[_tableView cellForRowAtIndexPath:indexPath];
        [self.delegate sendMMiaMagezineType:cell.typeLabel.text];
        [UIView animateWithDuration:0.2 animations:^{
            [self removeFromSuperview];
        }];
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
