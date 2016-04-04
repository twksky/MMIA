//
//  CeshiViewController.m
//  MMIA
//
//  Created by twksky on 15/5/21.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "CeshiViewController.h"

@interface CeshiViewController ()

@end

@implementation CeshiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(dismiss) userInfo:nil repeats:YES];
}

-(void)dismiss{
    [self dismissViewControllerAnimated:NO completion:nil];
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
