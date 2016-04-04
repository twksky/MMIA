//
//  MMiaDetailImgeViewController.m
//  MMIA
//
//  Created by lixiao on 14-7-4.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaDetailImgeViewController.h"


#define LEFT_BBI_TAG  10
static CGRect oldframe;
@interface MMiaDetailImgeViewController ()

@end

@implementation MMiaDetailImgeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   

    [self loadNavView];
    [self loadBgView];
    
    
}
#pragma marks -loadUI
-(void)loadNavView
{
    
    [self setTitle:@"你好"];
    [self addBackBtnWithTarget:self selector:@selector(btnClick:)];
       
     
    
}
- (void)loadBgView
{
    
    
    //背景视图
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, App_Frame_Width, App_Frame_Height-44)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
    
    _bigImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,0, 0)];
    _bigImageView.backgroundColor=[UIColor redColor];
    
    _bigImageView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_bigImageView addGestureRecognizer:tap];
    [_bgView addSubview:_bigImageView];
    _smallImageView=[[UIImageView alloc]init];
    
    [_bgView addSubview:_smallImageView];
   
   [self sendRequest];
    
    
}
#pragma mark - sendRequest
-(void)sendRequest
{
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:self.id,@"id", nil];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_IMAGES_DETAIL_URL param:param requestMethod:@"POST" completionHandler:^(NSDictionary *jsonObject){
        NSURL *url=[[NSURL alloc]init];
        NSData *data=[[NSData alloc]init];
        UIImage *image=[[UIImage alloc]init];
        CGFloat rate;
        if ([jsonObject[@"result"] intValue]==0) {
            NSDictionary *dataDict=jsonObject[@"data"];
            NSDictionary *picDict=[dataDict objectForKey:@"pictures"];
            //用户
            NSDictionary *userDict=[dataDict objectForKey:@"user"];
            NSArray *picArray=[picDict objectForKey:@"pictureUrls"];
           // NSString *descStr=[picDict objectForKey:@"desc"];
            for (NSString *str in picArray) {
                
                url=[NSURL URLWithString:str];
            }
            
            data=[NSData dataWithContentsOfURL:url];
            image=[UIImage imageWithData:data];
            if (image.size.width!=0) {
                rate=Main_Screen_Width/image.size.width;
            }
            _bigImageView.frame=CGRectMake(0, 0, Main_Screen_Width, image.size.height*rate);
            _bigImageView.image=image;
            _bigImage=image;
            NSString *userStr=[userDict objectForKey:@"userPictureUrl"];

            CGFloat height =_bgView.frame.size.height-_bigImageView.frame.size.height;
            _smallImageView.frame=CGRectMake(0, _bigImageView.frame.size.height, height, height);
            [_smallImageView sd_setImageWithURL:[NSURL URLWithString:userStr]];
            
        }
        
    }errorHandler:^(NSError *error){
        
    }];
}


#pragma mark - bttonClick
-(void)btnClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)tapClick:(UITapGestureRecognizer *)tap
{
       UIImageView *imageView1=(UIImageView *)tap.view;
    UIImage *image=imageView1.image;
    if (self.navigationController) {
       // self.navigationController.navigationBarHidden = YES;
        
    }
   
    //BOOL hidden=self.navigationView.hidden;
   // self.navigationView.hidden=!hidden;
    [UIApplication sharedApplication].statusBarHidden=YES;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
   
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    oldframe=[_bigImageView convertRect:_bigImageView.bounds toView:_bgView];
    backgroundView.alpha=0;
    backgroundView.backgroundColor=[UIColor lightGrayColor];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
   
    
    [window addSubview:backgroundView];
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,(Main_Screen_Height-oldframe.size.height)/2, Main_Screen_Width, oldframe.size.height);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];


    
}

-(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    [UIApplication sharedApplication].statusBarHidden=NO;
        [UIView animateWithDuration:0.3 animations:^{
            
    _bigImageView.frame=oldframe;
            NSLog(@"oldframe=%@",NSStringFromCGRect(oldframe));
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
     NSLog(@"_bgView.frameB=%@",NSStringFromCGRect(_bgView.frame));
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
