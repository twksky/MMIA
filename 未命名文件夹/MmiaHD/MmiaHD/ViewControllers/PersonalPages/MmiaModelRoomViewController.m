//
//  MmiaModelRoomViewController.m
//  MmiaHD
//
//  Created by lixiao on 15/4/3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaModelRoomViewController.h"

@interface MmiaModelRoomViewController ()<UIWebViewDelegate>{
    NSString    *_urlStr;
    UIWebView   *_webView;
}

@end

@implementation MmiaModelRoomViewController

#pragma mark - init

- (id)initWithUrlString:(NSString *)urlStr
{
    self = [super init];
    if (self)
    {
        _urlStr = urlStr;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView = [[UIWebView alloc]init];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.userInteractionEnabled = YES;
    [self.contentView addSubview:_webView];
    
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _webView.frame = self.contentView.bounds;
    
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
