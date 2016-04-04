//
//  ViewController.m
//  qqqqq
//
//  Created by twksky on 15/5/27.
//  Copyright (c) 2015年 twksky. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-100, 120)];
    
    _label.backgroundColor = [UIColor redColor];
    
    _label.font = [UIFont systemFontOfSize:20];
//    _label.adjustsFontSizeToFitWidth = YES;
    _label.text = @"12sdadascsadsakjdhsakdgsadsakhdsakjhdksajhdksjahdksahdksjlahdksjahdkjsahdjshadkjsahldjhsadjhsajdhsakjhdsa";
//    _label.lineBreakMode = UILineBreakModeCharacterWrap;UILineBreakModeCharacterWrap
//    CGSize labelsize = [_label.text sizeWithFont:_label.font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    
    CGSize size = CGSizeMake(300, MAXFLOAT);
    CGRect labelRect = [_label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_label.font} context:nil];
    
    [_label setFrame:labelRect];
    
    [_label setNumberOfLines:0];
    _cell = [[UIView alloc]initWithFrame:CGRectMake(50, 50, _label.frame.size.width+10, _label.frame.size.height+20)];
    _cell.backgroundColor = [UIColor yellowColor];
    [_cell addSubview:_label];
    [self.view addSubview:_cell];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, 400, 150, 50)];
    [btn addTarget:self action:@selector(tiao:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor greenColor];
//    btn.titleLabel.text = @"www.baidu.com";
    [btn setTitle:@"www.baidu.com" forState:UIControlStateNormal];
    [self.view addSubview:btn];
}


-(void)tiao:(UIButton *)btn{
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    if ([[btn.titleLabel.text substringToIndex:7]isEqualToString:@"http://"]) {
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:btn.titleLabel.text]];
        [web loadRequest:request];
    }else{
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",btn.titleLabel.text]]];
    [web loadRequest:request];
    }
//    web.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:web];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
