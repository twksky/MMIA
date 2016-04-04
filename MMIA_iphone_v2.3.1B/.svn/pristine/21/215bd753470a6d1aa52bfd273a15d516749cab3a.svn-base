//
//  MMIAAboutPersonViewController.m
//  MMIA
//
//  Created by Free on 14-6-18.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMIAAboutPersonViewController.h"
#import "MMiaFunsViewController.h"
#import "MMiaConcernViewController.h"
#import "MMiaSetDataViewCell.h"

#define FUNS_VIEW_TAG     101
#define CONCERN_VIEW_TAG  102
#define SEX_LABEL_TAG    201
#define FANS_LABEL_TAG   202
#define CONCEN_LABEL_TAG 203

@interface MMIAAboutPersonViewController (){
    UIScrollView *_scrollView;
    LoginInfoItem *_loginItem;
}


@end

@implementation MMIAAboutPersonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithLoginItem:(LoginInfoItem *)loginItem
{
    self=[super init];
    if (self)
    {
        _loginItem=loginItem;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(getUserPersonalInfoRequest) name:Change_PersonData object:nil];
    [self loadNavView];
    [self loadBgView];
}
#pragma mark -loadUI
- (void)loadNavView
{
    [self setTitleString:@"关于"];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height-1, self.navigationView.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xA6A6A6);
    [self.navigationView addSubview:lineView];
    
    [self addBackBtnWithTarget:self selector:@selector(btnClick:)];
}
- (void)loadBgView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, App_Frame_Width, Main_Screen_Height-20-44)];
    _scrollView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    _scrollView.bounces=NO;
    [self.view addSubview:_scrollView];
    
    MMIASetDataCellContentView *topView=[[MMIASetDataCellContentView alloc]init];
    topView.frame=CGRectMake(10, 10, App_Frame_Width-20, 60);
    [topView setNeedsDisplay];
    topView.backgroundColor=[UIColor clearColor];
    topView.cornerSize = CGSizeMake(3, 3);
    topView.rectCorner = UIRectCornerAllCorners;
    
    UIImageView  *headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    headImageView.layer.cornerRadius=20;
    headImageView.clipsToBounds=YES;
    if (self.headImage) {
        headImageView.image=self.headImage;
    }else{
        headImageView.image=[UIImage imageNamed:@"personal_03.png"];        }
    [topView addSubview:headImageView];
    UILabel *nikeLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 20, 180, 20)];
    NSString *nikeNameStr=_loginItem.nikeName;
    
    nikeLabel.text=nikeNameStr;
    [nikeLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [topView addSubview:nikeLabel];
    [_scrollView addSubview:topView];
    
    UIFont *labelFont=[UIFont systemFontOfSize:16];
    NSString *signatureStr=_loginItem.signature;
    if (signatureStr.length==0)
    {
        signatureStr=@"该用户暂无介绍...";
    }
    //计算高度设置高度
    CGFloat height=[signatureStr sizeWithFont:labelFont constrainedToSize:CGSizeMake(App_Frame_Width-40, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
    
     MMIASetDataCellContentView *contentBgview=[[MMIASetDataCellContentView alloc]init];
      contentBgview.frame=CGRectMake(10, 80, App_Frame_Width-20, 120+height+20);
    [contentBgview setNeedsDisplay];
    contentBgview.backgroundColor=[UIColor clearColor];
    contentBgview.cornerSize = CGSizeMake(3, 3);
     contentBgview.rectCorner = UIRectCornerAllCorners;
  
    
    NSArray *typeArr=[NSArray arrayWithObjects:@"性别",@"粉丝",@"关注", @"",nil];
    NSArray *contentArr=[NSArray arrayWithObjects:[NSNumber numberWithInt:_loginItem.sex],[NSNumber numberWithInt:_loginItem.fansNumber],[NSNumber numberWithInt:_loginItem.focusPersonNumber],signatureStr, nil];
  
    for (int i=0; i<contentArr.count; i++)
    {
        
        UIView *view=[[UIView alloc]init];
        view.frame=CGRectMake(0, 40*i, App_Frame_Width-20, 40);
        [view setNeedsDisplay];
        view.backgroundColor=[UIColor clearColor];
        view.tag=100+i;
       
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [view addGestureRecognizer:tap];
        
        UILabel *typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 20)];
        typeLabel.font=[UIFont systemFontOfSize:16];
        typeLabel.textAlignment=MMIATextAlignmentLeft;
        typeLabel.text=[typeArr objectAtIndex:i];
        [typeLabel setTextColor:[UIColor redColor]];
        [view addSubview:typeLabel];
        UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(200, 10, 85, 20)];
        contentLabel.font=[UIFont systemFontOfSize:16];
        contentLabel.textAlignment=MMIATextAlignmentRight;
        contentLabel.tag=SEX_LABEL_TAG+i;
        if (i==0)
        {
          if ([[contentArr objectAtIndex:i]intValue]==0)
            {
                contentLabel.text=@"男";
            }else if ([[contentArr objectAtIndex:i]intValue]==1)
            {
               contentLabel.text=@"女";
            }else
            {
                contentLabel.text=@"";
            }
        }else if (i==contentArr.count-1)
        {
            
          contentLabel.text=[contentArr objectAtIndex:i];
        }
        else
        {
            contentLabel.text=[[contentArr objectAtIndex:i]stringValue];
       }
        if (i==contentArr.count-1)
        {
            if (_loginItem.signature.length==0)
            {
                contentLabel.text=signatureStr;
                contentLabel.textColor=UIColorFromRGB(0xBCBCBC);
            }
            view.frame=CGRectMake(0,  40*i, App_Frame_Width-20, height+20);
            typeLabel.hidden=YES;
            contentLabel.frame=CGRectMake(10, 5, CGRectGetWidth(view.frame)-20, CGRectGetHeight(view.frame)-10);
            contentLabel.numberOfLines=0;
            contentLabel.textAlignment=MMIATextAlignmentLeft;
        }else
        {
            UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetHeight(view.frame)-1, CGRectGetWidth(view.frame)-10, 1)];
            lineLabel.backgroundColor=UIColorFromRGB(0xE1E1E1);
            [view addSubview:lineLabel];
            
        }
       
        [view addSubview:contentLabel];
        [contentBgview addSubview:view];
        
    }
    _scrollView.contentSize=CGSizeMake(App_Frame_Width, CGRectGetMaxY(contentBgview.frame)+5);
    [_scrollView addSubview:contentBgview];
    
   
//    MMIASetDataCellContentView *lastView=[[MMIASetDataCellContentView alloc]init];
//   lastView.frame=CGRectMake(10,200, App_Frame_Width-20, 40);
//    [lastView setNeedsDisplay];
//    lastView.backgroundColor=[UIColor clearColor];
//    lastView.cornerSize = CGSizeMake(3, 3);
//    lastView.rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
//    UILabel *lastLabel=[[UILabel alloc]initWithFrame:CGRectMake(10,5, CGRectGetWidth(lastView.frame)-20, 30)];
//    lastLabel.text=_loginItem.signature;
//    
//    //计算高度设置高度
//    CGFloat height=[_loginItem.signature sizeWithFont:lastLabel.font constrainedToSize:CGSizeMake(CGRectGetWidth(lastView.frame)-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
//    lastView.frame=CGRectMake(10, 200, App_Frame_Width-20, height+30);
//    lastLabel.frame=CGRectMake(10, 5, CGRectGetWidth(lastView.frame)-20, height+20);
//    lastLabel.numberOfLines=0;
//    [lastView addSubview:lastLabel];
//    [_bgView addSubview:lastView];

    
}
#pragma mark -buttonClick
-(void)btnClick:(UIButton *)button
{
    if (button.tag==1001) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    UIView *view=tap.view;
    if (view.tag==FUNS_VIEW_TAG)
    {
        MMiaFunsViewController *funsVC=[[MMiaFunsViewController alloc]initWithUserId:self.userId];
        [self.navigationController pushViewController:funsVC animated:YES];
    }else if (view.tag==CONCERN_VIEW_TAG){
        MMiaConcernViewController *concernVC=[[MMiaConcernViewController alloc]initWithUserId:self.userId];
        [self.navigationController pushViewController:concernVC animated:YES];
    }
    
}
#pragma mark-sendRequest
-(void)getUserPersonalInfoRequest
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
    if (!userTicket)
    {
        userTicket=@"";
    }
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:self.userId],@"userid",userTicket,@"ticket", nil];
    
    [appDelegate.mmiaDataEngine startAsyncRequestWithUrl:MMia_GET_PERSONAL_INFO_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        if ([jsonDict[@"result"]intValue]==0) {
           
            
            UILabel *fansLabel=(UILabel *)[_scrollView viewWithTag:FANS_LABEL_TAG];
            fansLabel.text=[NSString stringWithFormat:@"%d",[jsonDict[@"fansNumber"]intValue]];
            UILabel *foucusLabel=(UILabel *)[_scrollView viewWithTag:CONCEN_LABEL_TAG];
            foucusLabel.text=[NSString stringWithFormat:@"%d",[jsonDict[@"focusPersonNumber"]intValue]];
            
            
        }else{
            
        }
        
    }errorHandler:^(NSError *error){
        
        
    }];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Change_PersonData object:nil];
    
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
