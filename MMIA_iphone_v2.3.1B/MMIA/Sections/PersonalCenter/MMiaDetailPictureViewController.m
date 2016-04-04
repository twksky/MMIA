//
//  MMiaDetailPictureViewController.m
//  MMIA
//
//  Created by lixiao on 14-9-22.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaDetailPictureViewController.h"
#import "MMiaCommonUtil.h"
#import "MMIAPersonalHomePageViewController.h"
#import "MMiaConcernPersonHomeViewController.h"
#import "MMIToast.h"
#import "MMiaInningMagezineViewController.h"
#import "MMiaDetailSpecialViewController.h"
#import "MMIALoginViewController.h"
#import "MMiaSearchViewController.h"
#import "MMiaPopListView.h"
#import "MMIANewMagezineController.h"
#import "MagezineItem.h"

#define HEAD_IMAGEVIEW_TAG    100
#define NIKENAME_LABEL_TAG    101
#define Fresh_Button_Tag      102
#define IN_MAGEZINE_VIEW_TAG  103
#define Top_Back_Button       205
#define LIKE_BUTTON_TAG       202
#define Label_Button_Tag      300
#define Big_ImageView_Tag     206

@interface MMiaDetailPictureViewController () < MMiaPopListViewDelegate, MMIANewMagezineControllerDelegate >
{
    NSInteger  _id;
    UIScrollView *_scrlloView;
    BOOL       _isLike;
    NSString *_title;
    float   _width;
    float   _height;
    float   _price;
    int     _userId;
    NSInteger     _productId;
    NSString  *_imageUrl;
    
}
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,assign)CGFloat headerHeight;
@property(nonatomic,retain)NSMutableArray* magazineTypeArr;
@property(nonatomic,assign)NSInteger requestMagezineErrorCount;
@property(nonatomic,assign)NSInteger magazineIndex;
@property(nonatomic,retain)UIImageView *bigImageView;

@end

@implementation MMiaDetailPictureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithTitle:(NSString *)title Id:(NSInteger)id goodsImage:(NSString *)imageUrl Width:(float)width Height:(float)height price:(float)price productId:(NSInteger)productId
{
    self=[super init];
    if (self){
        _title = title;
        _id=id;
        _imageUrl = imageUrl;
        _width=width;
        _height=height;
        _price=price;
        //没有用
        _productId=productId;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:YES];
    if(self.magazineTypeArr.count == 0){
        [self getUserAllMagazineDataStart:0];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray=[[NSMutableArray alloc]init];
    [self loadBgView];
    [self creatViewWithTitleArr:nil DataDict:nil];
    [self getPicByIdData];
    self.magazineTypeArr = [[NSMutableArray alloc] init];
    [self getUserAllMagazineDataStart:0];
}
#pragma mark -loadUI
- (void)loadBgView
{
    //背景视图
    
    _scrlloView = [[UIScrollView alloc]initWithFrame:self.view.frame];
    _scrlloView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    _scrlloView.bounces = NO;
    _scrlloView.delegate = self;
     [self.view insertSubview:_scrlloView belowSubview:self.navigationView];
    UIImage *topBgImage;
    if (iOS7)
    {
        topBgImage = [UIImage imageNamed:@"commoditypage_topbar.png"];
    }else
    {
        topBgImage = [UIImage imageNamed:@"commoditypage_topbar_small.png"];
    }
    self.navigationView.backgroundColor = [UIColor colorWithPatternImage:topBgImage];
   
    UIImage *backImage = [UIImage imageNamed:@"commoditypage_backbutton.png"];
    UIButton *backButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 10+VIEW_OFFSET, backImage.size.width+20, backImage.size.height)];
    backButton.tag = Top_Back_Button;
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backButton];
    
    UIImage *collectionImage = [UIImage imageNamed:@"commoditypage_collectonbutton.png"];
    UIButton *collectionButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.navigationView.frame)-collectionImage.size.width-15, 10+VIEW_OFFSET, collectionImage.size.width+10, collectionImage.size.height)];
    [collectionButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    collectionButton.tag = IN_MAGEZINE_VIEW_TAG;
    [collectionButton setImage:collectionImage forState:UIControlStateNormal];
    [self.navigationView addSubview:collectionButton];
    
    UIImage *refreshImage = [UIImage imageNamed:@"commoditypage_refeshbutton.png"];
    UIButton *refreshButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(collectionButton.frame)-refreshImage.size.width-10, 10+VIEW_OFFSET, refreshImage.size.width+10, refreshImage.size.height)];
    refreshButton.tag = Fresh_Button_Tag;
    [refreshButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setImage:refreshImage forState:UIControlStateNormal];
    [self.navigationView addSubview:refreshButton];

}
-(void)creatViewWithTitleArr:(NSMutableArray *)titleArr DataDict:(NSMutableDictionary *)dataDict
{
    [_scrlloView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    float rate;
    if (_width!=0)
    {
        rate=App_Frame_Width/_width;
    }
    
    _bigImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width,  _height*rate)];
    _bigImageView.tag=Big_ImageView_Tag;
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
    [_scrlloView addSubview:_bigImageView];
    
    
    UIImage *likeImage;
    if (_isLike)
    {
        likeImage = [UIImage imageNamed:@"commoditypage_likebuttonselected.png"];
    }else
    {
        likeImage = [UIImage imageNamed:@"commoditypage_likebutton.png"];
    }
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    likeButton.frame = CGRectMake(CGRectGetWidth(_bigImageView.frame)-likeImage.size.width-10, CGRectGetHeight(_bigImageView.frame)-likeImage.size.height-10, likeImage.size.width, likeImage.size.height);
    [likeButton setImage:likeImage forState:UIControlStateNormal];
    likeButton.tag = LIKE_BUTTON_TAG;
    [likeButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrlloView addSubview:likeButton];
    
    UIView *firstView = [[UIView alloc]init];
    firstView.backgroundColor = [UIColor whiteColor];
    [_scrlloView addSubview:firstView];
    
    
    UIFont *titleFont = [UIFont systemFontOfSize:13];
    CGFloat titleHeight = [_title sizeWithFont:titleFont constrainedToSize:CGSizeMake(App_Frame_Width-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, App_Frame_Width-20, titleHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = titleFont;
    [titleLabel setText:_title];
    [titleLabel setTextColor:UIColorFromRGB(0x404040)];
    titleLabel.numberOfLines = 0;
    [firstView addSubview:titleLabel];
    
    int row = 10,count = 0;
    int rowSpace = 10;
    CGFloat lastViewHeight;
    if (titleArr.count != 0)
    {
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetHeight(titleLabel.frame)+10+7.5, App_Frame_Width-20, 0.5)];
        lineLabel.backgroundColor = UIColorFromRGB(0xd9d9d9);
        [firstView addSubview:lineLabel];
        
        
        for (int i=0; i < titleArr.count; i++)
        {
            NSString *str = [titleArr objectAtIndex:i];
            CGFloat width = [str sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:NSLineBreakByWordWrapping].width+30;
            
            if (row+10+width > App_Frame_Width-10)
            {
                row = 10;
                count ++;
            }
            UIButton *labelButton = [[UIButton alloc]initWithFrame:CGRectMake(row, CGRectGetHeight(titleLabel.frame)+10+8+10+count*(20+rowSpace), width, 20)];
            labelButton.tag = Label_Button_Tag+i;
            UIImage *backImage = [UIImage imageNamed:@"commoditypage_tag.png"];
            backImage = [backImage stretchableImageWithLeftCapWidth:floorf(backImage.size.width/2) topCapHeight:floorf(backImage.size.height/2)];
            UIImage *highLightImage = [UIImage imageNamed:@"commoditypage_tagselected.png"];
            highLightImage = [highLightImage stretchableImageWithLeftCapWidth:floorf(highLightImage.size.width/2) topCapHeight:floorf(highLightImage.size.height/2)];
            [labelButton setBackgroundImage:backImage forState:UIControlStateNormal];
            [labelButton setBackgroundImage:highLightImage forState:UIControlStateHighlighted];
            [labelButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [labelButton setTitle:str forState:UIControlStateNormal];
            [labelButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
            [labelButton setTitleColor:UIColorFromRGB(0x6c6c6c) forState:UIControlStateNormal];
            [firstView addSubview:labelButton];
            row += 10 + width;
        }
        lastViewHeight = CGRectGetHeight(titleLabel.frame)+10+8+10+(count+1)*(20+rowSpace);
        
    }else
    {
        lastViewHeight = CGRectGetHeight(titleLabel.frame)+10+8;
    }
    firstView.frame = CGRectMake(0, _height*rate, App_Frame_Width, lastViewHeight);
    UILabel *lineLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lastViewHeight-0.5, App_Frame_Width, 0.5)];
    lineLabel2.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [firstView addSubview:lineLabel2];
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, _height*rate+lastViewHeight+5, App_Frame_Width, 40+20)];
    middleView.backgroundColor = [UIColor whiteColor];
    [_scrlloView addSubview:middleView];
    UILabel *lineLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width, 0.5)];
    lineLabel3.backgroundColor = UIColorFromRGB(0xe5e5e5);
    [firstView addSubview:lineLabel3];
    
    
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    headImageView.userInteractionEnabled=YES;
    headImageView.clipsToBounds=YES;
    headImageView.layer.cornerRadius=40/2;
    headImageView.tag=HEAD_IMAGEVIEW_TAG;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[dataDict objectForKey:@"userPictureUrl"]] placeholderImage:[UIImage imageNamed:@"personal_03.png"]];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [headImageView addGestureRecognizer:tap];
    [middleView addSubview:headImageView];
    
    
//    CGFloat nikeNameWidth = [ [dataDict objectForKey:@"nickName"] sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(MAXFLOAT, 40) lineBreakMode:NSLineBreakByWordWrapping].width;
    UILabel *nikeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+15+10, 10,176, 40)];
    [nikeNameLabel setText:[dataDict objectForKey:@"nickName"]];
    nikeNameLabel.textAlignment = MMIATextAlignmentLeft;
    [nikeNameLabel setTextColor:UIColorFromRGB(0x404040)];
    [nikeNameLabel setFont:[UIFont systemFontOfSize:16]];
    nikeNameLabel.tag = NIKENAME_LABEL_TAG;
    nikeNameLabel.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [nikeNameLabel addGestureRecognizer:tap2];
    [middleView addSubview:nikeNameLabel];
    UILabel *lineLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(middleView.frame)-0.5, App_Frame_Width, 0.5)];
    lineLabel4.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [middleView addSubview:lineLabel4];
    
    
    if ([[dataDict objectForKey:@"desc"]length] != 0)
    {
        UIView *descriptionView = [[UIView alloc]init];
        descriptionView.backgroundColor = [UIColor whiteColor];
        [_scrlloView addSubview:descriptionView];
        UILabel *lineLabel5 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width, 0.5)];
        lineLabel5.backgroundColor = UIColorFromRGB(0xe5e5e5);
        [middleView addSubview:lineLabel5];
        
        
        UILabel *descriptionLabel = [[UILabel alloc]init];
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.text = [dataDict objectForKey:@"desc"];
        [descriptionLabel setFont:[UIFont systemFontOfSize:11]];
        [descriptionLabel setTextColor:UIColorFromRGB(0x404040)];
        CGFloat descripHeight = [ [dataDict objectForKey:@"desc"] sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(App_Frame_Width-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
        //descriptionLabel.backgroundColor = [UIColor whiteColor];
        
        descriptionView.frame = CGRectMake(0, _height*rate+lastViewHeight+5+CGRectGetHeight(middleView.frame)+5, App_Frame_Width,  descripHeight+20);
        descriptionLabel.frame = CGRectMake(10, _height*rate+lastViewHeight+5+CGRectGetHeight(middleView.frame)+5+10, App_Frame_Width-20, descripHeight);
        
        [_scrlloView addSubview:descriptionLabel];
        self.headerHeight = _height*rate+lastViewHeight+5+CGRectGetHeight(middleView.frame)+5+descripHeight+20;
    }else
    {
        self.headerHeight  = _height*rate+lastViewHeight+5+CGRectGetHeight(middleView.frame);
    }
    _scrlloView.contentSize = CGSizeMake(App_Frame_Width, self.headerHeight);
}
#pragma mark-sendRequest
-(void)getPicByIdData
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
    int userId=[[defaults objectForKey:USER_ID]intValue];
    if (!userTicket)
    {
        userTicket=@"";
    }
    if (!userId)
    {
        userId=0;
    }
    NSDictionary *infoDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:_id],@"id",userTicket,@"ticket",[NSNumber numberWithInt:userId],@"userid", nil];
  AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_GETPICBYID_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        if ([jsonDict[@"result"]intValue]==0)
        {
            NSMutableArray *titleArr = [[NSMutableArray alloc]init];
            NSMutableDictionary *deDataDict = [[NSMutableDictionary alloc]init];
             NSDictionary *dataDict=[jsonDict objectForKey:@"data"];
            NSDictionary *pictureDict=[dataDict objectForKey:@"pictures"];
            if ([[pictureDict objectForKey:@"isLike"]intValue]==1)
            {
                _isLike=YES;
            }else
            {
                _isLike=NO;
            }
            if ([[pictureDict objectForKey:@"magazineName"]length]!=0)
            {
                [titleArr addObject:[pictureDict objectForKey:@"magazineName"]];
            }
            if ([[pictureDict objectForKey:@"brandName"]length]!=0)
            {
                [titleArr addObject:[pictureDict objectForKey:@"brandName"]];
            }
            if ([[pictureDict objectForKey:@"categoryName"]length]!=0)
            {
                [titleArr addObject:[pictureDict objectForKey:@"categoryName"]];
            }
            [deDataDict setObject:[pictureDict objectForKey:@"desc"] forKey:@"desc"];
            NSDictionary *userDict=[dataDict objectForKey:@"user"];
            
            [deDataDict setObject:[userDict objectForKey:@"userPictureUrl"] forKey:@"userPictureUrl"];
            [deDataDict setObject:[userDict objectForKey:@"nickName"] forKey:@"nickName"];
              _userId=[[userDict objectForKey:@"userId"]intValue];
            [self creatViewWithTitleArr:titleArr DataDict:deDataDict];
        }else
        {
             [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
        }
        
    }errorHandler:^(NSError *error){
        
    }];
}

//用户喜欢某个商品或者图片
-(void)addLikePicture
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
    int userId=[[defaults objectForKey:USER_ID]intValue];
    if (!userTicket)
    {
        userTicket=@"";
    }
    if (!userId)
    {
        userId=0;
    }
    NSDictionary *infoDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:_id],@"shareId",userTicket,@"ticket",[NSNumber numberWithInt:userId],@"userid", nil];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_ADDLIKE_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        
        UIButton *likeButton=(UIButton *)[_scrlloView viewWithTag:LIKE_BUTTON_TAG];
       likeButton.enabled=YES;
        if ([jsonDict[@"result"]intValue]==0)
        {
             [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
            _isLike=YES;

            UIImage *likeInImage=[UIImage imageNamed:@"commoditypage_likebuttonselected.png"];
            [likeButton setImage:likeInImage forState:UIControlStateNormal];
            NSDictionary *infoDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:1],Add_Like_Num, nil];
            NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:Change_LikeData object:nil userInfo:infoDict];
            
        }else
        {
            [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
        }
        
    }errorHandler:^(NSError *error){
        UIButton *likeButton=(UIButton *)[_scrlloView viewWithTag:LIKE_BUTTON_TAG];
        likeButton.enabled = YES;
        
        if ([app.mmiaDataEngine isReachable]==NO)
        {
            [MMIToast showWithText:@"没有网络连接" topOffset:Main_Screen_Height-20 image:nil];
            
        }else
        {
            [MMIToast showWithText:@"网络异常，请重试" topOffset:Main_Screen_Height-20 image:nil];
            
        }

    }];

}
//用户取消喜欢某个商品或者图片
-(void)deleteLikePicture
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
    int userId=[[defaults objectForKey:USER_ID]intValue];
    if (!userTicket)
    {
        userTicket=@"";
    }
    if (!userId)
    {
        userId=0;
    }
    NSDictionary *infoDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:_id],@"shareId",userTicket,@"ticket",[NSNumber numberWithInt:userId],@"userid", nil];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_DELETELIKE_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        UIButton *likeButton=(UIButton *)[_scrlloView viewWithTag:LIKE_BUTTON_TAG];
        likeButton.enabled = YES;
        if ([jsonDict[@"result"]intValue]==0) {
             [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
            _isLike=NO;
            UIImage *likeImage=[UIImage imageNamed:@"commoditypage_likebutton.png"];
            [likeButton setImage:likeImage forState:UIControlStateNormal];

            NSDictionary *infoDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:-1],Add_Like_Num, nil];
            NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:Change_LikeData object:nil userInfo:infoDict];
        }else
        {
            [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
            likeButton.enabled = YES;
        }
        
    }errorHandler:^(NSError *error){
        UIButton *likeButton=(UIButton *)[_scrlloView viewWithTag:LIKE_BUTTON_TAG];
        likeButton.enabled = YES;
        
        if ([app.mmiaDataEngine isReachable]==NO)
        {
            [MMIToast showWithText:@"没有网络连接" topOffset:Main_Screen_Height-20 image:nil];
            
        }else
        {
            [MMIToast showWithText:@"网络异常，请重试" topOffset:Main_Screen_Height-20 image:nil];
            
        }
  
    }];

}


#pragma mark -btnClick
-(void)btnClick:(UIButton *)button
{
    if (button.tag==Top_Back_Button)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (button.tag == LIKE_BUTTON_TAG)
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        BOOL islogin=[defaults boolForKey:USER_IS_LOGIN];
        if (!islogin)
        {
            MMIALoginViewController* loginVC = [[MMIALoginViewController alloc] init];
            [loginVC setTarget:self withSuccessAction:@selector(logonSuccess) withRegisterAction:@selector(registerSuccess)];
            [self.navigationController pushViewController:loginVC animated:YES];
            
            return;
        }
        
        if (_isLike==YES)
        {
            [self deleteLikePicture];
        }else
        {
            [self addLikePicture];
        }
        button.enabled = NO;
    }
    if (button.tag == IN_MAGEZINE_VIEW_TAG)
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        BOOL islogin=[defaults boolForKey:USER_IS_LOGIN];
        if (!islogin)
        {
            MMIALoginViewController* loginVC = [[MMIALoginViewController alloc] init];
            [loginVC setTarget:self withSuccessAction:@selector(logonSuccess) withRegisterAction:@selector(registerSuccess)];
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
        }


        MMiaPopListView* popListView = [[MMiaPopListView alloc] initWithTitle:@"选择要加入的专题" dataArray:self.magazineTypeArr isRound:YES];
        [popListView showInSuperView:self.view animated:YES];
        popListView.delegate = self;
        popListView.frame = CGRectMake(0, 0 , self.view.bounds.size.width, self.view.bounds.size.height );
        /*

        UIImageView *imageView=(UIImageView *)[_scrlloView viewWithTag:Big_ImageView_Tag];
        MMiaInningMagezineViewController *inMagezineVC=[[MMiaInningMagezineViewController alloc]initWithImage:imageView.image imgId:_productId];
        inMagezineVC.delegate=self.delegate;
        inMagezineVC.isLikeOrShareVC=YES;
        [self.navigationController pushViewController:inMagezineVC animated:YES];
         */
    }
    if (button.tag == Fresh_Button_Tag)
    {
        [self getPicByIdData];
    }
    //标签
    if (button.tag >= Label_Button_Tag)
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        int userId=[[defaults objectForKey:USER_ID]intValue];
        MMiaSearchViewController *searchVc = [[MMiaSearchViewController alloc]initWithUserid:userId keyword:button.titleLabel.text];
        [self.navigationController pushViewController:searchVc animated:YES];

    }

}
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    UIView *view=tap.view;
    if (view.tag==HEAD_IMAGEVIEW_TAG ||view.tag==NIKENAME_LABEL_TAG) {
        NSArray *viewControllers=self.navigationController.viewControllers;
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        int userId=[[defaults objectForKey:USER_ID]intValue];
        for (UIViewController *vc in viewControllers)
        {
            if ([vc isKindOfClass:[MMIAPersonalHomePageViewController class]] && userId==_userId)
            {
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
    }
    
        MMiaConcernPersonHomeViewController *concernVC=[[MMiaConcernPersonHomeViewController alloc]initWithUserid:_userId];
        [self.navigationController pushViewController:concernVC animated:YES];
}
        
-(void)logonSuccess
{
    [self getPicByIdData];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)registerSuccess
{
      [self getPicByIdData];
   [self.navigationController popViewControllerAnimated:NO];
     [self.navigationController popViewControllerAnimated:YES];
}
//最后的点击
-(void)lastTapClick:(UITapGestureRecognizer *)tap
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    BOOL islogin=[defaults boolForKey:USER_IS_LOGIN];
    if (!islogin)
    {
        MMIALoginViewController* loginVC = [[MMIALoginViewController alloc] init];
        [loginVC setTarget:self withSuccessAction:@selector(logonSuccess) withRegisterAction:@selector(registerSuccess)];
        [self.navigationController pushViewController:loginVC animated:YES];
        
        return;
    }
    
    UIImageView *imageView=(UIImageView *)tap.view;
    if (_isLike==YES)
    {
        [self deleteLikePicture];
    }else
    {
        [self addLikePicture];
    }
    imageView.userInteractionEnabled=NO;
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error!=nil) {
        [MMIToast showWithText:@"收藏失败" topOffset:Main_Screen_Height-20 image:nil];
    }else
    {
       [MMIToast showWithText:@"收藏成功" topOffset:Main_Screen_Height-20 image:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MMIANewMagezineControllerDelegate

- (void)reloadUserAllMagazineData:(MMIANewMagezineController *)viewController
{
    [self getUserAllMagazineDataStart:0];
}

#pragma mark -MMiaPopListViewDelegate

-(void)popListView:(MMiaPopListView *)popListView didSelectedIndex:(NSInteger)aIndex
{
    if(aIndex == -1)
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        int userId=[[defaults objectForKey:USER_ID]intValue];
        NSString *userTicket=[defaults objectForKey:USER_TICKET];
        UIImageView *imageView=(UIImageView *)[_bigImageView viewWithTag:Big_ImageView_Tag];
        UIButton *sureButton=(UIButton *)[self.navigationView viewWithTag:1002];
        [sureButton setEnabled:NO];
        NSData *mydata=UIImageJPEGRepresentation(imageView.image , 1);
        if (!userTicket)
        {
            userTicket=@"";
        }
        if (!userId)
        {
            userId=0;
        }
        
        MMIANewMagezineController* newMagezineVC = [[MMIANewMagezineController alloc] initWithShare:userId ticket:userTicket magazineId:0 imageData:mydata imageId:_productId];
        newMagezineVC.delegate = self;
        [self.navigationController pushViewController:newMagezineVC animated:YES];
    }else
    {
        self.magazineIndex = aIndex;
        [self getUploadData];
    }

}
//请求专题类型列表
-(void)getUserAllMagazineDataStart:(NSInteger)start
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    int userId=[[defaults objectForKey:USER_ID]intValue];
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
    if (!userTicket)
    {
        userTicket=@"";
    }
    if (!userId)
    {
        userId=0;
    }
    NSDictionary *infoDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userid",userTicket,@"ticket",[NSNumber numberWithLong:start],@"start",[NSNumber numberWithInt:Request_Data_Count],@"size", nil];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_GET_USERALLMAGEZINE_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict)
     {
         if ([[jsonDict objectForKey:@"result"]intValue]==0)
         {
             [self.magazineTypeArr removeAllObjects];
             NSArray *dataArray=[jsonDict objectForKey:@"data"];
             for (NSDictionary *dict in dataArray)
             {
                 MagezineItem *item=[[MagezineItem alloc]init];
                 item.aId=[[dict objectForKey:@"id"]intValue];
                 item.title=[dict objectForKey:@"title"];
                 [self.dataArray addObject:item];
                 [self.magazineTypeArr addObject:item];
             }
             
         }else
         {
             
         }
     }errorHandler:^(NSError *error){
         if (self.requestMagezineErrorCount < 3) {
             self.requestMagezineErrorCount++;
             [self getUserAllMagazineDataStart:0];
         }
     }];
    
}

//请求接口收进专题
#pragma mark - sendRequest

-(void)getUploadData
{
    UIImageView *imageView=(UIImageView *)[_bigImageView viewWithTag:Big_ImageView_Tag];
    UIButton *sureButton=(UIButton *)[self.navigationView viewWithTag:1002];
    [sureButton setEnabled:NO];
    NSData *mydata=UIImageJPEGRepresentation(imageView.image , 1);
    NSString *pictureDataString=[mydata base64Encoding];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
    int userId=[[defaults objectForKey:USER_ID]intValue];
    if (!userTicket)
    {
        userTicket=@"";
    }
    if (!userId)
    {
        userId=0;
    }
    NSDictionary *infoDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userid",userTicket,@"ticket",pictureDataString,@"imageStream", nil];
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_upload_PIC_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict)
     {
         
         if ([jsonDict[@"result"]intValue]==0)
         {
             //_imagePath=jsonDict[@"imgPath"];
             [self getsharePictureToMagazineRequest:jsonDict[@"imgPath"]];
             
             
         }else
         {
             [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
         }
     }errorHandler:^(NSError *error)
     {
         [MMIToast showWithText:@"分享图片失败" topOffset:Main_Screen_Height-20 image:nil];
     }];
    
}

-(void)getsharePictureToMagazineRequest:(NSString *)imagePath
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    int userId=[[defaults objectForKey:USER_ID]intValue];
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
    if (!userTicket)
    {
        userTicket=@"";
    }
    if (!userId)
    {
        userId=0;
    }
    if (!imagePath) {
        imagePath=@"";
    }
    MagezineItem *item=self.magazineTypeArr[self.magazineIndex];
    NSMutableDictionary *infoDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userid",userTicket,@"ticket",[NSNumber numberWithLong:item.aId],@"magazineId",imagePath,@"imgPath",[NSNumber numberWithLong:_productId],@"imgId" ,nil];
    
    //    [infoDict setObject:pricrTexFiled.text forKey:@"price"];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_PICTURE_TOMAGEZINE_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict)
     {
         UIButton *sureButton=(UIButton*)[self.navigationView viewWithTag:1002];
         [sureButton setEnabled:YES];
         if ([jsonDict[@"result"]intValue]==0)
         {
             NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
             [nc postNotificationName:Ining_MagezineData object:nil];
             
             [MMIToast showWithText:@"收藏成功" topOffset:Main_Screen_Height-20 image:nil];
             /*
             [self.delegate returnDelegateWithTitle:item.title MagazineId:item.aId UserId:userId];
             
             NSArray *controllers=self.navigationController.viewControllers;
             for (UIViewController *vc in controllers)
             {
                 if ([vc isKindOfClass:[MMiaDetailSpecialViewController class]])
                 {
                     [self.navigationController popToViewController:vc animated:YES];
                     return ;
                     
                 }
             }
              */
             //             MMiaDetailSpecialViewController *devc=[[MMiaDetailSpecialViewController alloc]initWithTitle:item.title MagazineId:item.aId UserId:userId];
             //             devc.isNotEdit=NO;
             //             [self.navigationController pushViewController:devc animated:YES];
             return;
             
         }else
         {
             [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
         }
     }errorHandler:^(NSError *error)
     {
         UIButton *sureButton=(UIButton*)[self.navigationView viewWithTag:1002];
         [sureButton setEnabled:YES];
         [MMIToast showWithText:@"收藏失败" topOffset:Main_Screen_Height-20 image:nil];
     }];
    
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
