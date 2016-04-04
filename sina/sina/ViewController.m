//
//  ViewController.m
//  sina
//
//  Created by twksky on 15/3/29.
//  Copyright (c) 2015年 twksky. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    b.frame = CGRectMake(100, 100, 60, 40);
    b.backgroundColor = [UIColor blackColor];
    [b addTarget:self action:@selector(c) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)c{
    NSLog(@"sina");
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://www.sina.com";
    request.scope = @"all";
    [WeiboSDK sendRequest:request];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
