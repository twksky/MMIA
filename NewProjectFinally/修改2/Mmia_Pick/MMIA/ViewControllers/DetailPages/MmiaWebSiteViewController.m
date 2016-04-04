//
//  MmiaWebSiteViewController.m
//  MMIA
//
//  Created by lixiao on 15/6/12.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "MmiaWebSiteViewController.h"

@interface MmiaWebSiteViewController (){
    NSString   *_webStr;
    UIWebView  *_webView;
}

@end

@implementation MmiaWebSiteViewController

- (id)initWithWebStr:(NSString *)webStr
{
    self = [super init];
    if (self)
    {
        _webStr = webStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addBackBtnWithTarget:self selector:@selector(buttonClick:)];
  
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, VIEW_OFFSET + kNavigationBarHeight, App_Frame_Width, App_Frame_Height - VIEW_OFFSET - kNavigationBarHeight)];
    _webView.scalesPageToFit = YES;
    _webView.backgroundColor = [UIColor clearColor];
    
    if (![_webStr hasPrefix:@"http://"])
    {
        _webStr = [NSString stringWithFormat:@"http://%@", _webStr];
    }
    NSURL *webUrl = [NSURL URLWithString:_webStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:webUrl];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}

- (void)buttonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
