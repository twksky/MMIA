//
//  MMiaAboutCompanyViewController.m
//  MMIA
//
//  Created by lixiao on 14-9-19.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaAboutCompanyViewController.h"
#import "MMiaFunsViewController.h"
#import "MMiaConcernViewController.h"
#import "MMiaSetDataViewCell.h"

#define FUNS_VIEW_TAG     100
#define CONCERN_VIEW_TAG  101
#define FUNS_LABEL_TAG    200
#define CONCERN_LABEL_TAG 201

@interface MMiaAboutCompanyViewController (){
    UIScrollView *_scroollView;
   // UIView *_bgView;
    NSString  *_nikeName;
    int       _funsNum;
    int       _focusPersonNum;
    NSString  *_signature;
    NSString  *_website;
    NSString  *_homePage;
    NSString  *_industry;
    LoginInfoItem *_loginItem;

}

@end

@implementation MMiaAboutCompanyViewController

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
    _scroollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, App_Frame_Width, Main_Screen_Height-20-44)];
    _scroollView.bounces=NO;
    _scroollView.contentSize=CGSizeMake(App_Frame_Width, Main_Screen_Height-20-44);
    _scroollView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_scroollView];
    
    MMIASetDataCellContentView *topView=[[ MMIASetDataCellContentView alloc]init];
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
    NSString *nikeNameStr=_loginItem.workUnit;
    
    [nikeLabel setFont:[UIFont boldSystemFontOfSize:16]];

    nikeLabel.text=nikeNameStr;
    [topView addSubview:nikeLabel];
    [_scroollView addSubview:topView];
    NSString *signatureStr=_loginItem.signature;
    if (signatureStr.length==0)
    {
        signatureStr=@"该企业暂无介绍...";
    }
  //关于高度
    CGFloat height1=[signatureStr sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(CGRectGetWidth(topView.frame)-20, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
   
    MMIASetDataCellContentView *lastBigView=[[MMIASetDataCellContentView alloc]init];
    [lastBigView setNeedsDisplay];
    lastBigView.backgroundColor=[UIColor clearColor];
    lastBigView.cornerSize = CGSizeMake(3, 3);
    lastBigView.rectCorner = UIRectCornerAllCorners;
    lastBigView.frame=CGRectMake(10, 80, App_Frame_Width-20, 160+height1+20);
    [_scroollView addSubview:lastBigView];
     NSArray *typeArr=[NSArray arrayWithObjects:@"粉丝",@"关注",@"",@"",@"", nil];
    NSString *fanStr=[NSString stringWithFormat:@"%d",_loginItem.fansNumber];
    NSString *concernStr=[NSString stringWithFormat:@"%d",_loginItem.focusPersonNumber];
    
    //关于
    
    NSArray *contentArr=[NSArray arrayWithObjects:fanStr,concernStr,_loginItem.signature,_loginItem.website,_loginItem.homepage ,nil];
    for (int i=0; i<typeArr.count; i++)
    {
        UIView *view=[[UIView alloc]init];
        if (i==0 || i==1)
        {
             view.frame=CGRectMake(0, 40*i, App_Frame_Width-20, 40);
        }else if (i==2)
        {
            view.frame=CGRectMake(0, 40*i, App_Frame_Width-20, 20+height1);
        }else
        {
            view.frame=CGRectMake(0, 80+20+height1+40*(i-3), App_Frame_Width-20, 40);
        }
        view.tag=FUNS_VIEW_TAG+i;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            [view addGestureRecognizer:tap];
      
        UILabel *typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 20)];
        typeLabel.font=[UIFont systemFontOfSize:16];
        typeLabel.text=[typeArr objectAtIndex:i];
        [typeLabel setTextColor:[UIColor redColor]];
        [view addSubview:typeLabel];
        UILabel *contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(200, 10, 80, 20)];
        contentLabel.font=[UIFont systemFontOfSize:16];
        [contentLabel setTextColor:[UIColor blackColor]];
        contentLabel.tag=FUNS_LABEL_TAG+i;
        contentLabel.numberOfLines=0;
       contentLabel.text=[contentArr objectAtIndex:i];
        contentLabel.textAlignment=MMIATextAlignmentRight;
        [view addSubview:contentLabel];
        if (i==2)
        {
            if (contentLabel.text.length==0)
            {
                contentLabel.text=@"该企业暂无介绍...";
                contentLabel.textColor=UIColorFromRGB(0xBCBCBC);
            }
           
        }else if (i==3)
        {
            if (contentLabel.text.length==0)
            {
                contentLabel.text=@"该企业暂无官网...";
                contentLabel.textColor=UIColorFromRGB(0xBCBCBC);
            }
           
        }

        if (i>1)
        {
            typeLabel.hidden=YES;
            contentLabel.frame=CGRectMake(10, 5, CGRectGetWidth(view.frame)-20, CGRectGetHeight(view.frame)-10);
            contentLabel.textAlignment=MMIATextAlignmentLeft;
            
        }
        if (i!=typeArr.count-1)
        {
            UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetHeight(view.frame)-1, CGRectGetWidth(view.frame)-10, 1)];
            lineLabel.backgroundColor=UIColorFromRGB(0xE1E1E1);
            [view addSubview:lineLabel];
            
        }else
        {
            //处理文字显示
            if (contentLabel.text.length==0)
            {
                contentLabel.text=@"该企业暂无主页地址...";
                contentLabel.textColor=UIColorFromRGB(0xBCBCBC);
            }else
            {
            contentLabel.text=[NSString stringWithFormat:@"www.mmia.com/%@",contentLabel.text];
            NSMutableAttributedString *attributedText=[[NSMutableAttributedString alloc]initWithAttributedString:contentLabel.attributedText];
            [attributedText setAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]} range:[contentLabel.text rangeOfString:@"www.mmia.com/"]];
            contentLabel.attributedText=attributedText;
            }
        }
        
        [lastBigView addSubview:view];

    }
 
    
    _scroollView.contentSize=CGSizeMake(App_Frame_Width, CGRectGetMaxY(lastBigView.frame)+5);
    
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
            
            
            UILabel *funsLabel=(UILabel *)[_scroollView viewWithTag:FUNS_LABEL_TAG];
            funsLabel.text=[NSString stringWithFormat:@"%d",[jsonDict[@"fansNumber"]intValue]];
            UILabel *concernLabel=(UILabel *)[_scroollView viewWithTag:CONCERN_LABEL_TAG];
            concernLabel.text=[NSString stringWithFormat:@"%d",[jsonDict[@"focusPersonNumber"]intValue]];
            
            
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
