//
//  ViewController.m
//  Block
//
//  Created by twksky on 15/6/11.
//  Copyright (c) 2015年 twksky. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

typedef NSString *(^myfun)(NSString *,NSString *,NSString *);
typedef NSString *(^stringfun1)(NSString *);
typedef void(^vfun)();


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    myfun m = ^(NSString *a,NSString *b,NSString *c){
        
        return [NSString stringWithFormat:@"%@%@,%@",a,b,c];
    };
    
//    (NSString *)(^fun2)(NSString *,NSString *) = ^(NSString *m,NSString *n){
//        return @"hah";
//    };
    
    vfun vf = ^{
        
    };
    
    void (^funfun)() = ^{
        NSLog(@"???");
    };
    NSString *(^stringfun)(NSString *) = ^NSString *(NSString *p){
        return p;
    };
    int(^sum)(int,int) = ^int(int a,int b){
        return a + b;
    };
    stringfun1 y = ^(NSString *c){
        return c;
    };
    int (^fun)() = ^(){
        NSLog(@".。,，,，");
        return 1;
    };
//    exception
    
//    funfun();
//    fun();
    
//    int (^block)() = ^int{
//        funfun();
//        return 90;
//    };
    
    
//    NSLog(@"%d",fun());
//    NSLog(@"%@",y(@"zou"));
//    NSLog(@"%@",m(@"haha",@",hehe",@",heihei!!!!!"));
//    NSLog(@"%d",sum(2,5));
    const int a = 1;
//    const int a = 5;
//    a = 5;
    int *P;
    P = (int *)&a;
    *P = 2;
    *(int *)&a = 3;
    int b = *(int *)&a;
    
    NSLog(@"%d",b);
    AppDelegate *app = [[AppDelegate alloc]init];
    [app loadInt:b];
    
    
//    @try{
//        [self setValue:@"s" forKey:@"s"];
//    }
//    @catch (NSException) {
//        NSLog(@"!!");
//    }
//    @finally{
//        NSLog(@"~~~");
//    }

    
    
    
    // Do any additional setup after loading the view, typically from a nib.
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
