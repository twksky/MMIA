//
//  MMiaCompanyDataSetViewController.m
//  MMIA
//
//  Created by lixiao on 14-9-9.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MMiaCompanyDataSetViewController.h"
#import "MMiaCommonUtil.h"
#import "MMIToast.h"
#import "MMiaSetDataViewCell.h"
#import "MMiaTextPromptAlertView.h"
#import "MMIProcessView.h"


#define HEAD_IMAGEVIEW_TAG 100
#define COMPANY_NAME_TAG   101
#define COMPANY_INDUSTRY_TAG   102
#define COMPANY_WEBSITE_TAG   103
#define COMPANY_HOMEPAGE_TAG   104
#define COMPANY_DSCRIPTION_TAG   105
#define COMPANY_DSCRIPTION_VIEW_TAG         205
#define LOGE_VIEW_OFFSET 250
#define PROCESS_VIEW_TAG     106


@interface MMiaCompanyDataSetViewController (){
    UIScrollView *_scrollView;
    NSString *_description;
    UIImagePickerController *_ipc;
    NSString *_tempHomePage;
}
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) LoginInfoItem  *loginItem;

@end

@implementation MMiaCompanyDataSetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithLoginItem:(LoginInfoItem *)item
{
    self = [super init];
    if (self)
    {
        _loginItem = item;
    }
    return self;
}

-(id)initWithNikeName:(NSString *)nikeName Industry:(NSString *)industry  Website:(NSString *)website Homepage:(NSString *)homepage description:(NSString *)description
{
    self=[super init];
    if (self)
    {
      _description=description;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tempHomePage=[[NSString alloc]init];
    _tempHomePage=self.loginItem.homepage;
    _ipc=[[UIImagePickerController alloc]init];
    _ipc.delegate=self;
    _ipc.allowsEditing=YES;
    [self loadNavView];
    [self loadBgview];
   
}

#pragma mark -loadUI
- (void)loadNavView
{
    [self setTitleString:@"资料设置"];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationView.frame.size.height-1, self.navigationView.frame.size.width, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xA6A6A6);
    [self.navigationView addSubview:lineView];

    [self addBackBtnWithTarget:self selector:@selector(btnClick:)];
    [self addRightBtnWithTarget:self selector:@selector(btnClick:)];
    UIButton *rightButton=(UIButton *)[self.view viewWithTag:1002];
    [rightButton setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
    UIImage *rightButtonImage=[UIImage imageNamed:@"login_16.png"];
    rightButton.frame=CGRectMake(App_Frame_Width-rightButtonImage.size.width-10, (44-rightButtonImage.size.height)/2 + VIEW_OFFSET, rightButtonImage.size.width, rightButtonImage.size.height);
    //rightButton.frame.size=CGSizeMake(CGRectGetWidth(rightButton.frame), CGRectGetHeight(rightButton.frame));
    rightButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_16.png"]];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
}
-(void)loadBgview{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, App_Frame_Width, Main_Screen_Height-20-44)];
    _scrollView.bounces=NO;
      _scrollView.contentSize=CGSizeMake(App_Frame_Width, Main_Screen_Height-20-44);
   _scrollView.backgroundColor=UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_scrollView];
  
   MMIASetDataCellContentView *headView=[[MMIASetDataCellContentView alloc]init];
    
    headView.frame=CGRectMake(10,10, App_Frame_Width-20, 40);
    [headView setNeedsDisplay];
     headView.backgroundColor=[UIColor clearColor];
    headView.cornerSize = CGSizeMake(3, 3);
   
    headView.rectCorner = UIRectCornerAllCorners;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [headView addGestureRecognizer:tap];
   
    UIImageView  *headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
    headImageView.userInteractionEnabled=YES;
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 15;
    headImageView.tag=HEAD_IMAGEVIEW_TAG;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:self.loginItem.headImageUrl] placeholderImage:[UIImage imageNamed:@"default_company.png"]];
    [headView addSubview:headImageView];
    UILabel *headLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 150, 20)];
    headLabel.text=@"更换logo";
    [headLabel setFont:[UIFont systemFontOfSize:16]];
    [headView addSubview:headLabel];
    [_scrollView addSubview:headView];
    
    
    UIView *middleView=[[UIView alloc]initWithFrame:CGRectMake(10, 60, App_Frame_Width-20, 200)];
    middleView.backgroundColor=[UIColor whiteColor];
   self.dataArray=[[NSMutableArray alloc]initWithObjects:@"企业名称",@"所属行业",@"企业官网",@"企业主页",nil];
    NSArray *detailArr=[NSArray arrayWithObjects:self.loginItem.nikeName,self.loginItem.industry,self.loginItem.website,self.loginItem.homepage, nil];
    
    for (int i=0; i<self.dataArray.count; i++) {
        MMIASetDataCellContentView *cellView=[[ MMIASetDataCellContentView alloc]init];
        cellView.frame=CGRectMake(0, 40*i, App_Frame_Width-20, 40);
        [cellView setNeedsDisplay];
        cellView.backgroundColor=[UIColor clearColor];
        cellView.cornerSize = CGSizeMake(3, 3);
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10,10, 70, 20)];
       
        label.text=[self.dataArray objectAtIndex:i];
        [label setFont:[UIFont systemFontOfSize:16]];
        [cellView addSubview:label];
       
        UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(100, 3, 190,27)];
        
       // [textView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
        textView.font=[UIFont systemFontOfSize:16];
        if (i==2)
        {
            textView.scrollEnabled=YES;
        }else
        {
            textView.scrollEnabled=NO;
        }
        if (i==self.dataArray.count-1)
        {
            textView.text=[NSString stringWithFormat:@"www.mmia.com/ \r\n %@",self.loginItem.homepage];
           
            textView.textColor=[UIColor lightGrayColor];
        }else
        {
          textView.text=[detailArr objectAtIndex:i];
        }
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentTapClick:)];
        [textView addGestureRecognizer:tap];
        textView.editable=NO;
       
        textView.tag=COMPANY_NAME_TAG+i;
        [textView setFont:[UIFont systemFontOfSize:15]];
        
        if (i==0)
        {
            cellView.rectCorner=UIRectCornerTopLeft | UIRectCornerTopRight;
        }else if (i==self.dataArray.count-1)
        {
            cellView.frame=CGRectMake(0, 40*i, App_Frame_Width-20, 80) ;
            [cellView setNeedsDisplay];
            label.frame=CGRectMake(10, 5, 70, 70);
            textView.frame=CGRectMake(100, 5, 190, 70);
            cellView.rectCorner=UIRectCornerBottomLeft|UIRectCornerBottomRight;
        }else
        {
            cellView.rectCorner = UIRectCornerAllCorners;
           cellView.cornerSize = CGSizeMake(0, 0);
        }

        [cellView addSubview:textView];
        [middleView addSubview:cellView];
        
    }
    
    [_scrollView addSubview:middleView];
    
    
   MMIASetDataCellContentView *view=[[MMIASetDataCellContentView alloc]init];
    view.tag=COMPANY_DSCRIPTION_VIEW_TAG;
    [view setNeedsDisplay];
    view.cornerSize = CGSizeMake(3, 3);
    view.backgroundColor=[UIColor clearColor];
    view.rectCorner = UIRectCornerAllCorners;
    UILabel *titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 30)];
    titlelabel.font=[UIFont systemFontOfSize:16];
    titlelabel.text=@"企业介绍";
    [view addSubview:titlelabel];
  UILabel  *textView=[[ UILabel alloc]init];
    textView.userInteractionEnabled=YES;
    //textView.bounces=NO;
    textView.numberOfLines=0;
    textView.text=_description;
    textView.font=[UIFont systemFontOfSize:16];
    CGFloat height;
     height=[textView.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(190, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
    if (height<19)
    {
        height=20;
    }
     view.frame=CGRectMake(10, 270, App_Frame_Width-20, height+20);
    
    textView.frame=CGRectMake(100, 5,190, view.frame.size.height-10);
    textView.tag=COMPANY_DSCRIPTION_TAG;
    UITapGestureRecognizer *tap1=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentTapClick:)];
    [textView addGestureRecognizer:tap1];
    textView.font=[UIFont systemFontOfSize:16];
  // textView.editable=NO;
    textView.backgroundColor=[UIColor clearColor];
   [view addSubview:textView];
    [_scrollView addSubview:view];
    _scrollView.contentSize=CGSizeMake(App_Frame_Width, CGRectGetMaxY(view.frame)+5);
}

#pragma mark -btnClick
-(void)btnClick:(UIButton *)button
{
    if (button.tag==1001) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (button.tag==1002){
        [self sendImageRequest];
    }
}
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄照片",@"从图片库选择", nil];
    [sheet showInView:self.view];
}
-(void)contentTapClick:(UITapGestureRecognizer *)tap
{
    
    UITextView *contentTextView=(UITextView *)tap.view;
    if (tap.view.tag==COMPANY_INDUSTRY_TAG)
    {
        //MMiaMagezineTypeView *typeView=[[MMiaMagezineTypeView alloc]initWithFrame:self.view.bounds];
        MMiaCompanyTypeView *typeView=[[MMiaCompanyTypeView alloc]initWithFrame:self.view.bounds selctStr:self.loginItem.industry];
        typeView.delegate=self;
        [self.view addSubview:typeView];
        return;
    }
    if (contentTextView.tag==COMPANY_NAME_TAG+3 && self.loginItem.homepage.length!=0 &&[_tempHomePage isEqualToString:self.loginItem.homepage]==YES)
    {
        return;

    }
    NSArray *titleArr=[NSArray arrayWithObjects:@"企业名称",@"所属行业",@"企业官网",@"企业主页",@"企业介绍", nil];
    NSString *titleStr=[titleArr objectAtIndex:contentTextView.tag-COMPANY_NAME_TAG];
    UITextView *textView;
    MMiaTextPromptAlertView *alert = [MMiaTextPromptAlertView promptWithTitle:titleStr message:nil textView:&textView block:^(MMiaTextPromptAlertView *alert){
        
        [alert.textView resignFirstResponder];
        [alert removeFromSuperview];
        return YES;
    }];
    if (contentTextView.tag==COMPANY_NAME_TAG)
    {
        [alert setMaxLength:20];
    }else if (contentTextView.tag==COMPANY_DSCRIPTION_TAG)
    {
        [alert setMaxLength:138];
    }else
    {
        [alert setMaxLength:1000];
    }
    [alert setCancelButtonWithTitle:@"退出" block:nil];
    [alert addButtonWithTitle:@"保存" block:^{
        NSString *str=textView.text;
        if (contentTextView.tag==COMPANY_NAME_TAG)
        {
//            if (textView.text.length>8)
//            {
//                 str=[NSString stringWithFormat:@"%@...",[textView.text substringToIndex:8]];
//               
//
//            }
             contentTextView.text=str;
        }else if (contentTextView.tag==COMPANY_HOMEPAGE_TAG)
        {
            str=[NSString stringWithFormat:@"www.mmia.com/ \r\n %@",textView.text];
            contentTextView.text=str;

        }else if (contentTextView.tag==COMPANY_DSCRIPTION_TAG)
        {
            MMIASetDataCellContentView *view=(MMIASetDataCellContentView *)[_scrollView viewWithTag:COMPANY_DSCRIPTION_VIEW_TAG];
            [view setNeedsDisplay];
            view.backgroundColor=[UIColor clearColor];
            view.cornerSize = CGSizeMake(3, 3);
            view.rectCorner = UIRectCornerAllCorners;
            UILabel *descriptionLabel=(UILabel *)[_scrollView viewWithTag:COMPANY_DSCRIPTION_TAG];
            str=[NSString stringWithFormat:@"%@",textView.text];
            CGFloat height=[str sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(190, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
            if (height<19)
            {
                height=20;
            }
            view.frame=CGRectMake(10, 270, App_Frame_Width-20, height+20);
            
            descriptionLabel.frame=CGRectMake(100, 5,190, view.frame.size.height-10);
             descriptionLabel.text=str;
             _scrollView.contentSize=CGSizeMake(App_Frame_Width, CGRectGetMaxY(view.frame)+5);
        }else
        {
          contentTextView.text=str;  
        }
       
        
        if (contentTextView.tag==COMPANY_NAME_TAG)
        {
            self.loginItem.nikeName = textView.text;
            
        }else if (contentTextView.tag==COMPANY_WEBSITE_TAG){
            self.loginItem.website=textView.text;
        }else if (contentTextView.tag==COMPANY_HOMEPAGE_TAG)
        {
            _tempHomePage=textView.text;
            
        }else
        {
            _description=textView.text;
        }
        
    }];
    [self.view addSubview:alert];
    [alert show];
    
   
}
#pragma mark -sendRequest
//判断网址是否正确
-(BOOL)isWebsite:(NSString *)str
{
    NSString *urlPattern =@"(http://|Http:|//|https://|www\\.|WWW\\.|Www\\.)+([a-zA-Z0-9\\._\\\\/~%-+&#?!=()@:])*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlPattern];
    BOOL isMatch = [pred evaluateWithObject:str];
   
    return isMatch;
}
-(void)sendDataRequest
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    int userId=[[defaults objectForKey:USER_ID]intValue];
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
    if (!userTicket)
    {
        userTicket=@"";
    }
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]initWithObjectsAndKeys:userTicket,@"ticket",[NSNumber numberWithInt:userId],@"companyid",self.loginItem.nikeName,@"companyName",self.loginItem.industry,@"industry",self.loginItem.website,@"website",_tempHomePage,@"homepage",_description,@"introduce", nil];
    UIButton *saveButton=(UIButton *)[self.navigationView viewWithTag:1002];
  
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    MMIProcessView *processView=( MMIProcessView *)[self.view viewWithTag:PROCESS_VIEW_TAG];  
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_MODIFY_COMPANY_INFO_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
          [saveButton setEnabled:YES];
        
        if ([jsonDict[@"result"]intValue]==0) {
            NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
            self.loginItem.homepage = _tempHomePage;
            [nc postNotificationName:Change_PersonData object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            [self show_check_phone_info:@"资料设置成功" image:nil];

        }else
        {
            [self show_check_phone_info:jsonDict[@"message"] image:nil];

        }
        [processView dismiss];
        
    }errorHandler:^(NSError *error){
          [saveButton setEnabled:YES];
        
        if ([app.mmiaDataEngine isReachable]==NO)
        {
            [self show_check_phone_info:@"没有网络连接" image:nil];
        }else
        {
            [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
            
        }
         [processView dismiss];

    }];
    
}
-(void)sendImageRequest
{
    if (self.loginItem.nikeName.length==0)
    {
        [self show_check_phone_info:@"企业名称不能为空" image:nil];
        return;
    }
    if (self.loginItem.industry.length==0)
    {
        [self show_check_phone_info:@"所属行业不能为空" image:nil];
        return;
    }
    if (self.loginItem.website.length>500)
    {
        [self show_check_phone_info:@"官网地址太长了！" image:nil];
        return;
    }
    
    if ([self isWebsite:self.loginItem.website]==NO)
    {
        [self show_check_phone_info:@"请输入正确的网址" image:nil];
        return;
        
    }
    if (_tempHomePage.length>0)
    {
        if (_tempHomePage.length<3 || _tempHomePage.length>20 ||[self haveNumberAndCharater:_tempHomePage]==NO )
        {
            [self show_check_phone_info:@"企业主页为3-20个字母、数字" image:nil];
            return;
            
        }
        
    }
    UIImageView *headImageView=(UIImageView *)[_scrollView viewWithTag:HEAD_IMAGEVIEW_TAG];
    NSData *mydata=UIImageJPEGRepresentation(headImageView.image , 1);
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
    NSString *pictureDataString=[mydata base64Encoding];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userid",userTicket,@"ticket",pictureDataString,@"imageStream", nil];
    
     UIButton *saveButton=(UIButton *)[self.navigationView viewWithTag:1002];
    [saveButton setEnabled:NO];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_UPLOAD_HEADERPICTURE_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict)
     {
         if ([jsonDict[@"result"]intValue]==0) {
             [self sendDataRequest];
             
         }else{
             [self show_check_phone_info:@"资料设置失败" image:nil];

         }
         
     }errorHandler:^(NSError *error){
         
           [saveButton setEnabled:YES];
         if ([app.mmiaDataEngine isReachable]==NO)
         {
             [self show_check_phone_info:@"没有网络连接" image:nil];
         }else
         {
             [self show_check_phone_info:@"网络不给力，请稍后重试" image:nil];
             
         }
         
         
     }];
    
    
    
}
-(BOOL)haveNumberAndCharater:(NSString *)str
{
    NSInteger length = [str length];
    for (int i=0; i<length; i++)
    {
        char perChar=[str characterAtIndex:i];
        if (!((perChar>64 && perChar<91) || (perChar>96 && perChar<123) ||( perChar>47 && perChar<58)))
        {
            return NO;
        }
            }
    
    return YES;

}

#pragma marks-alertView
- (void) show_check_phone_info:(NSString *)_str image:(NSString *)_img{
    //[MMIToast showWithText:_str topOffset:kTipsTopOffset];
    [MMIToast showWithText:_str topOffset:Main_Screen_Height-20 image:_img];
    
}




#pragma mark -KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UITextView *textView=object;
    CGFloat topCorrect=[textView bounds].size.height-[textView contentSize].height;
    textView.contentOffset=(CGPoint){.x =0, .y = -topCorrect/2};
}

#pragma mark -UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        _ipc.sourceType=UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:_ipc animated:YES completion:^{
            BOOL isCameraValid = YES;
            if (iOS7)
            {
                AVAuthorizationStatus authStatus=[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus !=AVAuthorizationStatusAuthorized)
                {
                    isCameraValid=NO;
                }
            }
            if (isCameraValid==NO)
            {
                UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"请在iPhone的“设置-隐私-相机”选项中，允许广而告之访问你的相机。" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
            }
            
            
        }];
    }
    if (buttonIndex==1) {
        _ipc.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_ipc animated:YES completion:nil];
    }
    
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    UIImageView *headImageView=(UIImageView *)[_scrollView viewWithTag:HEAD_IMAGEVIEW_TAG];
    headImageView.image=image;
    // image = [image imageByScalingAndCroppingForSize:CGSizeMake(400, 400)];
  
//     NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//      NSString* documentsDirectory = [paths objectAtIndex:0];
//    NSData *imageData= UIImageJPEGRepresentation(image, 1.0);
//    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"headImage.jpg"];
//    [imageData writeToFile:fullPathToFile atomically:YES];
    
    if ([picker respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else if ([picker respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([picker respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else if ([picker respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [_ipc dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - MMiaMagezineTypeViewDelegate
-(void)sendMMiaMagezineType:(NSString *)magazineType
{
    UITextView *textView=(UITextView *)[_scrollView viewWithTag:COMPANY_INDUSTRY_TAG];
    self.loginItem.industry=magazineType;
    textView.text=magazineType;
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
