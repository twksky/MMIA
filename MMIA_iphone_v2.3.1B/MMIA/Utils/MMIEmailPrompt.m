//
//  MMIEmailPrompt.m
//  MMIA
//
//  Created by Free on 14-6-14.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMIEmailPrompt.h"

@implementation MMIEmailPrompt

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius=4;
        self.layer.borderColor=[[UIColor lightGrayColor]CGColor];
        self.layer.borderWidth=2;
        self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.dataArray=[[NSMutableArray alloc]init];
       
        self.tableView.backgroundColor=[UIColor colorWithRed:(CGFloat)((0xF4F5F7>>16)/255.0f) \
                                                       green:(CGFloat)(((0xF4F5F7&0x00FF00)>>8)/255.0f)\
                                                        blue:(CGFloat)((0xF4F5F7&0xFF)/255.0f) \
                                                       alpha:1.0];
;
        //self.tableView.alpha=0.8;
        if (iOS7) {
            self.tableView.separatorInset=UIEdgeInsetsZero;
        }
        
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        //self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        [self addSubview:self.tableView];
        
        
    }
    return self;
}
-(void)reinitDataArray:(NSString *)str{
     self.dataArray=[[NSMutableArray alloc]initWithObjects:@"qq.com",@"163.com", @"126.com", @"139.com",@"yeah.com",@"gmail.com",@"sina.com",@"sohu.com",@"hotmail.com",@"yahoo.com",@"yahoo.com.cn",@"live.cn",@"foxmail.com",@"tom.com",nil];
    for (int i=0; i<self.dataArray.count; i++) {
        NSString *str1=[NSString stringWithFormat:@"%@%@",str,[self.dataArray objectAtIndex:i]];
        [self.dataArray replaceObjectAtIndex:i withObject:str1];
        
        
    }

    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.textLabel.textColor=[UIColor blackColor];
        cell.textLabel.textAlignment=MMIATextAlignmentLeft;
        cell.backgroundColor=[UIColor colorWithRed:(CGFloat)((0xF4F5F7>>16)/255.0f) \
                                             green:(CGFloat)(((0xF4F5F7&0x00FF00)>>8)/255.0f)\
                                              blue:(CGFloat)((0xF4F5F7&0xFF)/255.0f) \
                                             alpha:1.0];
;
       
        
    }
    cell.textLabel.text=[self.dataArray objectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    [self.emailDelegate sendSelectCellStr:[self.dataArray objectAtIndex:indexPath.row]];
   
    
    [UIView animateWithDuration:0.2 animations:^{
      self.hidden=YES;
    }];
    
    
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
