//
//  WebViewController.m
//  MMIA
//
//  Created by twksky on 15/5/28.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *web = [[UIWebView alloc]initWithFrame:self.view.bounds];
    if ([[_url substringToIndex:7]isEqualToString:@"http://"]) {
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
        [web loadRequest:request];
    }else{
        NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",_url]]];
        [web loadRequest:request];
    }
    [self.view addSubview:web];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
