//
//  MMiaInningMagezineViewController.m
//  MMIA
//
//  Created by lixiao on 14-9-23.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaInningMagezineViewController.h"
#import "MMiaFunsTableViewCell.h"
#import "MagezineItem.h"
#import "MJRefresh.h"
#import "MMiaErrorTipView.h"
#import "MMIToast.h"
#import "MMiaDetailSpecialViewController.h"
#import "MMiaCreateMagazineViewController.h"
#import "MyCustomTabBarMainVIew.h"


#define TITLE_TEXTFILED_TAG        100
#define PRICE_TEXTFILED_TAG        102
#define DESCRIPTION_TEXTFILED_TAG  103
#define LINK_TEXTFILED_TAG         104
#define CREATE_VIEW_TAG             105
#define HEAD_IMAGEVIEW_TAG         106
@interface MMiaInningMagezineViewController (){
    UIView *_bgView;
    BOOL      _isLoadding;
    BOOL      _isRefresh;
    BOOL      _showErrTipView;
    NSInteger _downNum;
    UIImage  *_image;
    NSIndexPath *_oldIndexPath;
    NSInteger        _imgId;

}
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,retain)UITableView    *tableView;

@end

@implementation MMiaInningMagezineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initEditUIWithTitleName:(NSString *)titleName andEditTextImage:(NSString *)editImage andTextFieldTag:(NSInteger)textFieldTag andFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 3.0f;
    view.layer.borderColor = [UIColorFromRGB(0xEAEAEA) CGColor];
    view.layer.shadowOffset = CGSizeMake(0, 1);
    view.layer.shadowColor = [UIColorFromRGB(0x000000) CGColor];
    view.layer.shadowOpacity = 0.5;
    
    //添加输入视图
    [self initializeTextFieldWithFrame:CGRectMake(20, (frame.size.height-30)/2.0f, frame.size.width-20, 30) andTag:textFieldTag andPlaceholder:titleName  andSecureTextEntry:NO andSuperView:view];
    
    [_bgView addSubview:view];
}
#pragma marks-textFiledInit
- (void)initializeTextFieldWithFrame:(CGRect)rect andTag:(NSInteger)tag andPlaceholder:(NSString *)placeholder andSecureTextEntry:(BOOL)secureTextEntry andSuperView:(UIView *)superView
{
    UITextField *textField = [[UITextField alloc]initWithFrame:rect];
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate=self;
    if (tag!=0) {
        textField.tag=tag;
    }
    if (placeholder!=nil) {
        textField.placeholder=placeholder;
    }
    if (secureTextEntry) {
        textField.secureTextEntry=secureTextEntry;
        
    }
    textField.clearButtonMode=UITextFieldViewModeAlways;
    textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [superView addSubview:textField];
    
}
-(id)initWithImage:(UIImage *)image imgId:(NSInteger)imgId
{
    self=[super init];
    if (self)
    {
        _image=image;
        _imgId=imgId;
    }
    return self;
}

-(UITableView *)tableView
{
    if( !_tableView)
    {
        UIView *view=(UIView *)[_bgView viewWithTag:CREATE_VIEW_TAG];
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(_bgView.bounds)-CGRectGetMaxY(view.frame))];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor=[UIColor clearColor];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_bgView addSubview:_tableView];
        
    }
    return _tableView;
}


-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:YES];

}
-(void)hideCenterTababar:(NSNotification *)notification
{
    MyCustomTabBarMainVIew *mainView=(MyCustomTabBarMainVIew *)notification.object;
    [mainView dismissTabBarMainView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray=[[NSMutableArray alloc]init];
    _oldIndexPath=[[NSIndexPath alloc]init];
    NSIndexPath *tempIndexPath=[NSIndexPath indexPathForItem:0 inSection:1];
    _oldIndexPath=tempIndexPath;
  
     NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(reloadMagezineRequest) name:Change_MagezineData object:nil];
    [self loadNavView];
    [self loadBgView];
    _isLoadding = YES;
    [self addRefreshHeader];
    [self getUserAllMagazineDataStart:0];
}

#pragma mark -loadUI
- (void)loadNavView
{
    [self setTitleString:@"选择专题"];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height-1, self.navigationView.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xA6A6A6);
    [self.navigationView addSubview:lineView];
    
    [self addBackBtnWithTarget:self selector:@selector(btnClick:)];
    [self addRightBtnWithTarget:self selector:@selector(btnClick:)];
    UIButton *rightButton=(UIButton *)[self.view viewWithTag:1002];
    [rightButton setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
    UIImage *rightButtonImage=[UIImage imageNamed:@"btn_sure.png"];
    rightButton.frame=CGRectMake(App_Frame_Width-rightButtonImage.size.width-10, (44-rightButtonImage.size.height)/2 + VIEW_OFFSET, rightButtonImage.size.width, rightButtonImage.size.height);
    [rightButton setBackgroundImage:rightButtonImage forState:UIControlStateNormal];

    
}
- (void)loadBgView
{
    //背景视图
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, App_Frame_Width, Main_Screen_Height-20-44)];
    _bgView.backgroundColor = UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_bgView];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    imageView.clipsToBounds=YES;
    imageView.layer.cornerRadius=4.0;
    imageView.tag=HEAD_IMAGEVIEW_TAG;
  
    imageView.image = _image;
   
    [_bgView addSubview:imageView];
    
     [self initEditUIWithTitleName:@"输入标题" andEditTextImage:@"login_ico_activation" andTextFieldTag:TITLE_TEXTFILED_TAG andFrame:CGRectMake(80, 30,App_Frame_Width-80-10 ,40)];
     UITextField *titleTextFiled=(UITextField *)[_bgView viewWithTag:TITLE_TEXTFILED_TAG];
    if ([[[UIDevice currentDevice] systemVersion] intValue] ==8)
    {
         [titleTextFiled addTarget:self action:@selector(passcodeChanged:) forControlEvents:UIControlEventEditingChanged];
    }
 
    [self initEditUIWithTitleName:@"输入描述" andEditTextImage:@"login_ico_activation" andTextFieldTag:DESCRIPTION_TEXTFILED_TAG andFrame:CGRectMake(10, 80,App_Frame_Width-20 ,40)];
    UITextField *descriptionTextFiled=(UITextField *)[_bgView viewWithTag:DESCRIPTION_TEXTFILED_TAG];
    if ([[[UIDevice currentDevice] systemVersion] intValue] ==8)
    {
        [descriptionTextFiled addTarget:self action:@selector(passcodeChanged:) forControlEvents:UIControlEventEditingChanged];
    }
   
    [self initEditUIWithTitleName:@"输入价格" andEditTextImage:@"login_ico_activation" andTextFieldTag:PRICE_TEXTFILED_TAG andFrame:CGRectMake(10, 130,App_Frame_Width-20 ,40)];
    UITextField *priceTextFiled=(UITextField *)[_bgView viewWithTag:PRICE_TEXTFILED_TAG];
    priceTextFiled.keyboardType=  UIKeyboardTypeNumbersAndPunctuation;
    //priceTextFiled.keyboardType=UIKeyboardTypeNumberPad;
     [self initEditUIWithTitleName:@"输入链接" andEditTextImage:@"login_ico_activation" andTextFieldTag:LINK_TEXTFILED_TAG andFrame:CGRectMake(10, 180,App_Frame_Width-20 ,40)];

    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 230, App_Frame_Width, 30)];
    view.backgroundColor=[UIColor blackColor];
    [_bgView addSubview:view];
    UILabel *chooseLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, CGRectGetHeight(view.frame))];
    chooseLabel.text=@"选择专题";
    chooseLabel.backgroundColor=[UIColor clearColor];
    [chooseLabel setTextColor:[UIColor whiteColor]];
    chooseLabel.textAlignment=MMIATextAlignmentLeft;
    [view addSubview:chooseLabel];
    
    UIView *creatView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), App_Frame_Width, 60)];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [creatView addGestureRecognizer:tap];
    creatView.backgroundColor=[UIColor whiteColor];
    creatView.tag=CREATE_VIEW_TAG;
    [_bgView addSubview:creatView];
    
    UIImage *creatImage=[UIImage imageNamed:@"creat_magezine.png"];
    UIImageView *creatImageView=[[UIImageView alloc]initWithImage:creatImage];
    creatImageView.frame=CGRectMake(10,( CGRectGetHeight(creatView.frame)-creatImage.size.height)/2, creatImage.size.width, creatImage.size.height);
    [creatView addSubview:creatImageView];
    UILabel *creatlabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(creatImageView.frame)+10, (CGRectGetHeight(creatView.frame)-20)/2, 100, 20)];
    creatlabel.textAlignment=MMIATextAlignmentLeft;
    creatlabel.text=@"新建专题";
    [creatView addSubview:creatlabel];
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 59, App_Frame_Width,1)];
    lineLabel.backgroundColor=[UIColor lightGrayColor];
   // [creatView addSubview:lineLabel];
    
}

#pragma mark - sendRequest

-(void)getUploadData
{
    UIImageView *imageView = (UIImageView *)[_bgView viewWithTag:HEAD_IMAGEVIEW_TAG];
    if (_oldIndexPath.section==1)
    {
        [MMIToast showWithText:@"请选择专题" topOffset:Main_Screen_Height-20 image:nil];
        return;
    }
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
             _downNum = [jsonDict[@"num"] intValue];

             if( _isRefresh )
             {
                 [self.dataArray removeAllObjects];
             }

         NSArray *dataArray=[jsonDict objectForKey:@"data"];
         for (NSDictionary *dict in dataArray)
         {
             MagezineItem *item=[[MagezineItem alloc]init];
             item.aId=[[dict objectForKey:@"id"]intValue];
             item.pictureImageUrl=[dict objectForKey:@"imgUrl"];
             //用来判断是否公开
             item.type=0;
             item.magazineId=[[dict objectForKey:@"isPulic"]intValue];
             item.title=[dict objectForKey:@"title"];
             [self.dataArray addObject:item];
         }
          [self refreshMagezineListPage];
      }else
      {
          [self netWorkError:nil];
      }
     }errorHandler:^(NSError *error){
          [self netWorkError:error];
     }];
    
}

-(void)getsharePictureToMagazineRequest:(NSString *)imagePath
{
    [self resignAllResponder];
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
    UITextField *nameTextFiled=(UITextField *)[_bgView viewWithTag:TITLE_TEXTFILED_TAG];
    UITextField *descriptionTexFiled=(UITextField *)[_bgView viewWithTag:DESCRIPTION_TEXTFILED_TAG];
     UITextField *pricrTexFiled=(UITextField *)[_bgView viewWithTag:PRICE_TEXTFILED_TAG];
     UITextField *linkTexFiled=(UITextField *)[_bgView viewWithTag:LINK_TEXTFILED_TAG];
       if (nameTextFiled.text.length==0)
    {

        nameTextFiled.text=@"";
    }
    if (descriptionTexFiled.text.length==0)
    {
        descriptionTexFiled.text=@"";
       
    }
    if (linkTexFiled.text.length==0)
    {
        linkTexFiled.text=@"";

    }
    if (!imagePath) {
        imagePath=@"";
    }
        MagezineItem *item=[self.dataArray objectAtIndex:_oldIndexPath.row];
       NSMutableDictionary *infoDict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userid",userTicket,@"ticket",nameTextFiled.text,@"name",descriptionTexFiled.text,@"description",[NSNumber numberWithLong:item.aId],@"magazineId",linkTexFiled.text,@"link",imagePath,@"imgPath",[NSNumber numberWithLong:_imgId],@"imgId" ,nil];
    if (pricrTexFiled.text.length==0)
    {
        
        pricrTexFiled.text=@"";
    }
    
    [infoDict setObject:pricrTexFiled.text forKey:@"price"];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_PICTURE_TOMAGEZINE_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict)
     {
         UIButton *sureButton=(UIButton*)[self.navigationView viewWithTag:1002];
         [sureButton setEnabled:YES];
        if ([jsonDict[@"result"]intValue]==0)
        {
            NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:Ining_MagezineData object:nil];
            
            [MMIToast showWithText:@"收进专题成功" topOffset:Main_Screen_Height-20 image:nil];
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
            MMiaDetailSpecialViewController *devc=[[MMiaDetailSpecialViewController alloc]initWithTitle:item.title MagazineId:item.aId UserId:userId isAttention:item.likeNum];
            
            [self.navigationController pushViewController:devc animated:YES];
             */
            return;
           
        }else
        {
          [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
        }
    }errorHandler:^(NSError *error)
    {
        UIButton *sureButton=(UIButton*)[self.navigationView viewWithTag:1002];
        [sureButton setEnabled:YES];
      [MMIToast showWithText:@"分享失败" topOffset:Main_Screen_Height-20 image:nil];
    }];
    
}

#pragma mark -nitification
-(void)reloadMagezineRequest
{
    if (_isLoadding)
    {
        return;
    }
    _isLoadding = YES;
    _isRefresh=YES;
    [self getUserAllMagazineDataStart:0];
}

- (void)refreshMagezineListPage
{
    if( _showErrTipView )
    {
        [MMiaErrorTipView hideErrorTipForView:self.tableView];
    }
    if( _isLoadding )
    {
        _isLoadding = NO;
        [MMiaLoadingView hideLoadingForView:self.view];
    }
    if( _isRefresh )
    {
        [_tableView headerEndRefreshing];
        _isRefresh = NO;
    }
    else
    {
        [_tableView footerEndRefreshing];
    }
    [self.tableView reloadData];
    
    if( _downNum >= Request_Data_Count )
    {
        [self addRefreshFooter];
    }
    else
    {
        [self removeRefreshFooter];
    }
}

- (void)netWorkError:(NSError *)error
{
    if( _isLoadding )
    {
        _isLoadding = NO;
        [MMiaLoadingView hideLoadingForView:self.view];
    }
    if( _isRefresh )
    {
        [_tableView headerEndRefreshing];
        _isRefresh = NO;
    }
    else
    {
        [_tableView footerEndRefreshing];
    }
    if( self.dataArray.count == 0 )
    {
        CGFloat errTipY = (CGRectGetHeight(self.tableView.bounds) - 125)/2;
        CGFloat errTipX = CGRectGetWidth(self.tableView.bounds) / 2;
        [MMiaErrorTipView showErrorTipForView:self.tableView center:CGPointMake(errTipX, errTipY) error:error delegate:self];
        _showErrTipView = YES;
    }
    else
    {
        [MMiaErrorTipView showErrorTipForErroe:error];
        [MMiaErrorTipView hideErrorTipForView:self.tableView];
        _showErrTipView = NO;
    }
}


#pragma mark - add下拉上拉刷新

- (void)addRefreshHeader
{
    __block MMiaInningMagezineViewController* inMagezineVC = self;
    [self.tableView addHeaderWithCallback:^{
        if( inMagezineVC->_isLoadding )
            return;
        
        if( inMagezineVC->_showErrTipView )
        {
            [MMiaErrorTipView hideErrorTipForView:inMagezineVC.tableView];
        }
        inMagezineVC->_isRefresh = YES;
        inMagezineVC->_isLoadding = YES;
        [MMiaLoadingView showLoadingForView:inMagezineVC.view];
        [inMagezineVC getUserAllMagazineDataStart:0];
    }];
}
- (void)addRefreshFooter
{
    __block MMiaInningMagezineViewController* inMagezineVC = self;
    [self.tableView addFooterWithCallback:^{
        if( inMagezineVC->_isLoadding )
            return;
        inMagezineVC->_isRefresh = NO;
        inMagezineVC->_isLoadding = YES;
        [inMagezineVC getUserAllMagazineDataStart:inMagezineVC.dataArray.count];
    }];
}

- (void)removeRefreshFooter
{
    if( ![_tableView isFooterHidden])
    {
        [_tableView removeFooter];
    }
}


#pragma mark -btnClick
-(void)btnClick:(UIButton *)button
{
    if (button.tag==1001)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (button.tag==1002)
    {
        [self resignAllResponder];
        [self getUploadData];
    }
}
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    MMiaCreateMagazineViewController *creatVC=[[MMiaCreateMagazineViewController alloc]init];
    [self.navigationController pushViewController:creatVC animated:YES];
}


- (void)passcodeChanged:(id)sender{
     UITextField *titleTextFiled=(UITextField *)[_bgView viewWithTag:TITLE_TEXTFILED_TAG];
    UITextField *descriptionTextFiled=(UITextField *)[_bgView viewWithTag:DESCRIPTION_TEXTFILED_TAG];
    NSString *text=titleTextFiled.text;
    NSString *descriptionText=descriptionTextFiled.text;
    if ([text length] > 50)
    {
        text = [text substringToIndex:50];
        titleTextFiled.text = text;
    }
    
    if ([descriptionText length]>70)
    {
        descriptionText = [descriptionText substringToIndex:70];
        descriptionTextFiled.text = descriptionText;
    }
    
}
#pragma mark- textFiledDelegate
-(void)resignAllResponder
{
    UITextField *titleTextFiled=(UITextField *)[_bgView viewWithTag:TITLE_TEXTFILED_TAG];
    [titleTextFiled resignFirstResponder];
    UITextField *priceTextFiled=(UITextField *)[_bgView viewWithTag:PRICE_TEXTFILED_TAG];
    [priceTextFiled resignFirstResponder];
    UITextField *descriptionTextFiled=(UITextField *)[_bgView viewWithTag:DESCRIPTION_TEXTFILED_TAG];
    [descriptionTextFiled resignFirstResponder];
    UITextField *linkTextFiled=(UITextField *)[_bgView viewWithTag:LINK_TEXTFILED_TAG];
    [linkTextFiled resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resignAllResponder];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField.tag==LINK_TEXTFILED_TAG) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, -40, self.view.frame.size.width, self.view.frame.size.height)];
        }];
        
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==LINK_TEXTFILED_TAG) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }];
        
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
     NSString *temp = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag==TITLE_TEXTFILED_TAG)
    {
        if (temp.length>=50 &&  range.length!=1)
        {
             textField.text = [temp substringToIndex:50];
           
            return NO;
        }
    }
    if (textField.tag==DESCRIPTION_TEXTFILED_TAG)
    {
        if (temp.length>=70 && ![string isEqualToString:@""])
        {
            textField.text = [temp substringToIndex:70];
            return NO;
        }
    }
    return YES;
}


#pragma mark -tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MMiaMagezineListCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil)
    {
        cell=[[MMiaMagezineListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.contentView.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    MagezineItem *item=[self.dataArray objectAtIndex:indexPath.row];
    if (item.magazineId==1)
    {
        cell.isPublicImageView.hidden=YES;
    }else
    {
        cell.isPublicImageView.hidden=NO;
    }
   
    [cell.magezineImageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl] placeholderImage:[UIImage imageNamed:@"item_big_icon.jpg"]];
    
    cell.titleLabel.text=item.title;
    if (item.type==0)
    {
        [cell.selectImageView setImage:[UIImage imageNamed:@"personal_11.png"]];
    }else
    {
      [cell.selectImageView setImage:[UIImage imageNamed:@"personal_10.png"]];
    }
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (_oldIndexPath.section==1)
    {
        MMiaMagezineListCell *newCell = (MMiaMagezineListCell *)[tableView cellForRowAtIndexPath:
                                                                 indexPath];
        MagezineItem *item=[self.dataArray objectAtIndex:indexPath.row];
        MagezineItem *newItem=[[MagezineItem alloc]init];
        newItem=item;
        newItem.type=1;
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:newItem];
        [newCell.selectImageView setImage:[UIImage imageNamed:@"personal_10.png"]];
        _oldIndexPath=indexPath;
    }else{
    
        NSInteger newRow = [indexPath row];
        NSInteger oldRow = [_oldIndexPath row];
       if (newRow != oldRow)
    {
        MMiaMagezineListCell *newCell = (MMiaMagezineListCell *)[tableView cellForRowAtIndexPath:
                                                                 indexPath];
        MagezineItem *item=[self.dataArray objectAtIndex:indexPath.row];
        MagezineItem *newItem=[[MagezineItem alloc]init];
        newItem=item;
        newItem.type=1;
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:newItem];
        [newCell.selectImageView setImage:[UIImage imageNamed:@"personal_10.png"]];
        
        
       MMiaMagezineListCell *oldCell = (MMiaMagezineListCell *)[tableView cellForRowAtIndexPath:
                                    _oldIndexPath];
        
        MagezineItem *item2=[self.dataArray objectAtIndex:_oldIndexPath.row];
        MagezineItem *oldItem=[[MagezineItem alloc]init];
        oldItem=item2;
        oldItem.type=0;
        [self.dataArray replaceObjectAtIndex:_oldIndexPath.row withObject:oldItem];
        [oldCell.selectImageView setImage:[UIImage imageNamed:@"personal_11.png"]];
        _oldIndexPath = indexPath;
    }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<=0)
    {
        scrollView.contentOffset=CGPointZero;
    }
}

#pragma mark -MMiaErrorTipViewDelegate

- (void)onErrorTipViewRefreshBtnClicked:(MMiaErrorTipView* )sender
{
    _showErrTipView = NO;
    [MMiaErrorTipView hideErrorTipForView:self.tableView];
    _isLoadding = YES;
    [MMiaLoadingView showLoadingForView:self.view];
    
    [self getUserAllMagazineDataStart:0];
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
