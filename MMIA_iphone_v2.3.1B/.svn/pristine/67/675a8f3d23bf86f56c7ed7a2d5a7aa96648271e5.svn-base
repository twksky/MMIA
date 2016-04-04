//
//  MMIANewMagezineController.m
//  MMIA
//
//  Created by Jack on 15/1/20.
//  Copyright (c) 2015年 com.zixun. All rights reserved.
//

#import "MMIANewMagezineController.h"
#import "MMIToast.h"

@interface MMIANewMagezineController ()
@property (nonatomic, assign)int userId;
@property (nonatomic, retain)NSString* ticket;
@property (nonatomic, assign)NSInteger magazineId;
@property (nonatomic, retain)NSData* imageData;
@property (nonatomic, assign)NSInteger imageId;
@property (nonatomic, retain)UITextField* magezinNameView;
@property (nonatomic, retain)NSString* magazineName;
@end

@implementation MMIANewMagezineController

- (id)initWithShare:(int)userId ticket:(NSString*)ticket magazineId:(NSInteger)magazineId imageData:(NSData*)imageData imageId:(NSInteger)imageId;{
    self=[super init];
    if (self)
    {
        self.userId = userId;
        self.magazineId = magazineId;
        self.ticket = ticket;
        self.magazineId = magazineId;
        self.imageData = imageData;
        self.imageId = imageId;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0xf2 / 255.0 green:0xf2 / 255.0 blue:0xf2 /255.0 alpha:1];
    [self initContentView];
}

-(void)initNewNavigationView
{
    [super initNewNavigationView];
    [self setNaviBarViewBackgroundColor: UIColorFromRGB(0x393b49)];
    [self addNewBackBtnWithTarget:self selector:@selector(backButClick:)];
    UIImage* image = [UIImage imageNamed:@"recievespecialpage_confirmbutton.png"];
    [self addNewRightBtnWithImage:image Target:self selector:@selector(submitButClick:)];
     }

-(void)backButClick:(id)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submitButClick:(id)button{
    self.magazineName = self.magezinNameView.text;
    if (nil == self.magazineName || [self.magazineName isEqualToString:@""])
    {
       [MMIToast showWithText:@"请输入专题名称" topOffset:Main_Screen_Height-20 image:nil];
    }else
    {
    [self.navigationController popViewControllerAnimated:YES];
    [self getUploadData];
    }
}

-(void)initContentView
{
    self.magezinNameView = [[UITextField alloc] init];
    self.magezinNameView.frame = CGRectMake(19, self.navigationView.bounds.size.height + 39, self.view.bounds.size.width - 38 , 37);
    self.magezinNameView.layer.borderWidth = 1;
    self.magezinNameView.layer.borderColor = [UIColor colorWithRed:0xd2 / 255.0 green:0xd2 / 255.0 blue:0xd2 / 255.0 alpha:1].CGColor;
    self.magezinNameView.layer.cornerRadius = 2.5;
    UIColor *placeHolerColcor=UIColorFromRGB(0x969696);
    self.magezinNameView.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"输入专题名称" attributes:@{NSForegroundColorAttributeName: placeHolerColcor}];
     self.magezinNameView.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10,10)];
    leftView.backgroundColor = [UIColor clearColor];
    self.magezinNameView.leftView = leftView;
    self.magezinNameView.leftViewMode = UITextFieldViewModeAlways;
    self.magezinNameView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.magezinNameView];
}

-(void)getUploadData
{

    UIButton *sureButton=(UIButton *)[self.navigationView viewWithTag:1002];
    [sureButton setEnabled:NO];
    NSString *pictureDataString=[self.imageData base64Encoding];
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
         }
         else
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
    NSMutableDictionary *infoDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:self.userId],@"userid",self.ticket,@"ticket",[NSNumber numberWithLong:self.magazineId],@"magazineId",imagePath,@"imgPath",[NSNumber numberWithLong:self.imageId],@"imgId" ,self.magazineName,@"magazineName",nil];
    
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
             
             if( [self.delegate respondsToSelector:@selector(reloadUserAllMagazineData:)] )
             {
                 [self.delegate reloadUserAllMagazineData:self];
             }
             
             [MMIToast showWithText:@"收藏成功" topOffset:Main_Screen_Height-20 image:nil];
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

@end
