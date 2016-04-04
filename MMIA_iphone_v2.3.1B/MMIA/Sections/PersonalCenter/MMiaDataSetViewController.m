//
//  MMiaDataSetViewController.m
//  MMIA
//
//  Created by lixiao on 14-6-19.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MMiaDataSetViewController.h"
#import "MMiaTextPromptAlertView.h"
#import "MMiaCommonUtil.h"
#import "MMIToast.h"
#import "MMiaSetDataViewCell.h"
#import "MMIProcessView.h"

#define LEFT_BBI_TAG 101

#define Description_Label_TAG 100
#define Description_VIew_TAG  200
#define MAN_BUTON_TAG 102
#define WOMAN_BUTTON_TAG 103
#define HEAD_IMAGEVIEW_TAG 104
#define NIKENAME_TEXTFILED_TAG 105
#define PROCESS_VIEW_TAG     106
#define LOGE_VIEW_OFFSET 250

@interface MMiaDataSetViewController (){
  //  UIView *_bgView;
    UITableView *_tableView;
    UIImagePickerController *_ipc;
    UIScrollView *_scrollView;
    
}

@property(nonatomic,retain)NSMutableArray *dataArray;
@property (nonatomic, retain) LoginInfoItem *loginItem;

@end

@implementation MMiaDataSetViewController
    


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
    self=[super init];
    if (self)
    {
        _loginItem = item;
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
    rightButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_16.png"]];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
}
-(void)loadBgview{
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, App_Frame_Width, Main_Screen_Height-20-44)];
    _scrollView.contentSize=CGSizeMake(App_Frame_Width, Main_Screen_Height-20-44);
    _scrollView.bounces=NO;
     _scrollView.backgroundColor=UIColorFromRGB(0xE1E1E1);
    [self.view addSubview:_scrollView];
    NSArray *array1=[NSArray array];
    NSArray *array2=[NSArray arrayWithObjects:@"昵称",@"性别", nil];
    self.dataArray=[[NSMutableArray alloc]initWithObjects:array1,array2, nil];
    
   _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 10, App_Frame_Width, 130) style:UITableViewStylePlain];
   _tableView.delegate=self;
   _tableView.dataSource=self;
    _tableView.bounces=NO;
    _tableView.scrollEnabled=NO;
    _tableView.backgroundColor=[UIColor clearColor];
    if (iOS7) {
         _tableView.separatorInset=UIEdgeInsetsZero;
    }
   
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
   // _tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    [_scrollView addSubview:_tableView];
    
    
    
    MMIASetDataCellContentView *view=[[MMIASetDataCellContentView alloc]init];
    view.tag=Description_VIew_TAG;
    [view setNeedsDisplay];
    view.backgroundColor=[UIColor clearColor];
    view.cornerSize = CGSizeMake(3, 3);
    view.rectCorner = UIRectCornerAllCorners;
    UILabel *titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 30)];
    //16
    titlelabel.font=[UIFont systemFontOfSize:16];
    titlelabel.text=@"个人介绍";
    [view addSubview:titlelabel];
    UILabel *descripLabel=[[UILabel alloc]init];
    descripLabel.numberOfLines=0;
    descripLabel.backgroundColor=[UIColor clearColor];
    descripLabel.userInteractionEnabled=YES;
    [descripLabel setFont:[UIFont systemFontOfSize:16]];
    descripLabel.tag=Description_Label_TAG;
    descripLabel.text=self.loginItem.signature;
    CGFloat height;
      height=[descripLabel.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(190, MAXFLOAT) lineBreakMode: NSLineBreakByWordWrapping].height;
   
    if (height<19)
    {
        height=20;
    }
   
    view.frame=CGRectMake(10,150, App_Frame_Width-20, height+20);
    
    descripLabel.frame=CGRectMake(100, 5, 190, view.frame.size.height-10);
    descripLabel.textAlignment=MMIATextAlignmentLeft;
    
    [view addSubview:descripLabel];
   
   // view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"personal_09.png"]];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [view addGestureRecognizer:tap];
       [_scrollView addSubview:view];
    _scrollView.contentSize=CGSizeMake(App_Frame_Width, CGRectGetMaxY(view.frame)+5);
    
}


#pragma mark -button click
-(void)btnClick:(UIButton *)btn{
    if (btn.tag==1001) {
        
       [self.navigationController popViewControllerAnimated:YES];
    }else if (btn.tag==MAN_BUTON_TAG ){
        UIButton *womanbutton=(UIButton *)[_tableView viewWithTag:WOMAN_BUTTON_TAG];
        [womanbutton setSelected:NO];
        [btn setSelected:YES];
        
    }else if (btn.tag==WOMAN_BUTTON_TAG){
        UIButton *manButton=(UIButton *)[_tableView viewWithTag:MAN_BUTON_TAG];
        [manButton setSelected:NO];
        [btn setSelected:YES];
     
        
    }else if (btn.tag==1002){
          [self sendImageRequest];
        
        

    }
    }

-(void)tapClick:(UITapGestureRecognizer *)tap
{
    UITextView *textView;
    MMiaTextPromptAlertView *alert = [MMiaTextPromptAlertView promptWithTitle:@"个人介绍" message:nil textView:&textView block:^(MMiaTextPromptAlertView *alert){
       
        [alert.textView resignFirstResponder];
        [alert removeFromSuperview];
        return YES;
    }];
    [alert setMaxLength:138];
    [alert setCancelButtonWithTitle:@"退出" block:nil];
    [alert addButtonWithTitle:@"保存" block:^{
        MMIASetDataCellContentView *view=(MMIASetDataCellContentView *)[_scrollView viewWithTag:Description_VIew_TAG];
        [view setNeedsDisplay];
        view.backgroundColor=[UIColor clearColor];
        view.cornerSize = CGSizeMake(3, 3);
        view.rectCorner = UIRectCornerAllCorners;
        UILabel *descripLabel=(UILabel *)[_scrollView viewWithTag:Description_Label_TAG];
        self.loginItem.signature=textView.text;
        descripLabel.text=[NSString stringWithFormat:@"%@",textView.text];
        CGFloat height=[descripLabel.text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(190, 1000) lineBreakMode:NSLineBreakByWordWrapping].height;
        
        if (height<19)
        {
           
            height=20;
        }
        view.frame=CGRectMake(10,150, App_Frame_Width-20, height+20);
        descripLabel.frame=CGRectMake(100, 5, 190, view.frame.size.height-10);
        _scrollView.contentSize=CGSizeMake(App_Frame_Width, CGRectGetMaxY(view.frame)+5);
    }];
    [self.view addSubview:alert];
    [alert show];
}
//计算文字长度
-(int)lengthOfStr:(NSString *)str
{
    int length=0;
    for (int i=0; i<[str length]; i++)
    {
        int a=[str characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff)
        {
            length+=2;
        }else
        {
            length+=1;
        }
    }
    return length;
}


#pragma mark -sendRequest
-(void)sendModifyUserDataRequest
{
     UILabel *nikeNameLabel=(UILabel *)[_tableView viewWithTag:NIKENAME_TEXTFILED_TAG];
    
    int gender;
    UIButton *manButton=(UIButton *)[_tableView viewWithTag:MAN_BUTON_TAG];
    UIButton *womanbutton=(UIButton *)[_tableView viewWithTag:WOMAN_BUTTON_TAG];
    if (manButton.isSelected) {
        gender=0;
    }else if (womanbutton.isSelected){
        gender=1;
    }else
    {
        gender=2;
    }

    
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
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:userId],@"userid",userTicket,@"ticket",nikeNameLabel.text,@"nickname",[NSNumber numberWithInt:gender],@"gender",self.loginItem.signature,@"description", nil];
    MMIProcessView *processView=( MMIProcessView *)[self.view viewWithTag:PROCESS_VIEW_TAG];
    
    UIButton *saveButton=(UIButton *)[self.navigationView viewWithTag:1002];
    
    
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_MODIFY_PERSONAL_INFO_URL param:dict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
         [saveButton setEnabled:YES];
        
        if ([jsonDict[@"result"]intValue]==0) {
          NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:Change_PersonData object:nil];
             [self show_check_phone_info:@"资料设置成功" image:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
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
    UILabel *nikeNameLabel=(UILabel *)[_tableView viewWithTag:NIKENAME_TEXTFILED_TAG];
    
    //     UILabel *descripLabel=(UILabel *)[_bgView viewWithTag:Description_Label_TAG];
    if (nikeNameLabel.text.length==0)
    {
        [self show_check_phone_info:@"昵称不能为空" image:nil];
        return;
    }
    if ([self lengthOfStr:nikeNameLabel.text]>20 || [self lengthOfStr:nikeNameLabel.text]<5)
    {
        [self show_check_phone_info:@"昵称只支持5-20个字符，中英文、数字" image:nil];
        return;
    }
    MMIProcessView *processView=[[MMIProcessView alloc]initWithMessage:@"资料修改中,请稍后...." top:Main_Screen_Height-60];
    processView.tag=PROCESS_VIEW_TAG;
    [processView showInRootView:self.view];
    UIImageView *imgView=(UIImageView *)[_tableView viewWithTag:HEAD_IMAGEVIEW_TAG];
    NSData *mydata=UIImageJPEGRepresentation(imgView.image , 1);
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
        if ([jsonDict[@"result"]intValue]==0)
        {
           [self sendModifyUserDataRequest];
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


#pragma marks-alertView
- (void) show_check_phone_info:(NSString *)_str image:(NSString *)_img{
    //[MMIToast showWithText:_str topOffset:kTipsTopOffset];
    [MMIToast showWithText:_str topOffset:Main_Screen_Height-20 image:_img];
    
}

#pragma mark -tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
        return 2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return self.dataArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   MMiaSetDataViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (cell==nil) {
        cell=[[MMiaSetDataViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
       // cell.backgroundColor=[UIColor whiteColor];
        cell.backgroundColor=[UIColor clearColor];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.typeLabel.hidden=YES;
        cell.contentLabel.hidden=YES;
        cell.accessoryImageView.hidden=YES;
    }
    if (indexPath.section==0) {
      UIImageView  *headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
        headImageView.userInteractionEnabled=YES;
        headImageView.layer.masksToBounds = YES;
        headImageView.layer.cornerRadius = 15;
        headImageView.tag=HEAD_IMAGEVIEW_TAG;
        [headImageView sd_setImageWithURL:[NSURL URLWithString:self.loginItem.headImageUrl] placeholderImage:[UIImage imageNamed:@"personal_03.png"]];
        [cell.contentView addSubview:headImageView];
        UILabel *headLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 100, 20)];
        headLabel.font=[UIFont systemFontOfSize:16];
        headLabel.text=@"设置头像";
        [cell.lineContentView addSubview:headLabel];

    }else if (indexPath.section==1){
        
               if (indexPath.row==1) {
                   UILabel *typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
                    typeLabel.font=[UIFont systemFontOfSize:16];
                   typeLabel.textAlignment=MMIATextAlignmentLeft;
                   [cell.lineContentView addSubview:typeLabel];
                    typeLabel.text=[[self.dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
                   
                   UIButton *manBtn=[[UIButton alloc]initWithFrame:CGRectMake(100, 12, 16, 16)];
                   manBtn.tag=MAN_BUTON_TAG;
                   [manBtn setBackgroundImage:[UIImage imageNamed:@"personal_11.png"] forState:UIControlStateNormal];
                   [manBtn setBackgroundImage:[UIImage imageNamed:@"personal_10.png"] forState:UIControlStateSelected];
                   [manBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                 
                   [cell.lineContentView addSubview:manBtn];
                   UILabel *manLable=[[UILabel alloc]initWithFrame:CGRectMake(126, 5, 20, 30)];
                    manLable.font=[UIFont systemFontOfSize:16];
                   manLable.text=@"男";
                   // manLable.font=[UIFont systemFontOfSize:14];
                   [cell.lineContentView addSubview:manLable];
                 UIButton *womanBtn=[[UIButton alloc]initWithFrame:CGRectMake(196, 12, 16, 16)];
                   womanBtn.tag=WOMAN_BUTTON_TAG;
                   [womanBtn setBackgroundImage:[UIImage imageNamed:@"personal_11.png"] forState:UIControlStateNormal];
                    [womanBtn setBackgroundImage:[UIImage imageNamed:@"personal_10.png"] forState:UIControlStateSelected];
                    [womanBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                   [cell.lineContentView addSubview:womanBtn];
                   //[self.womanBtn setBackgroundImage:[UIImage imageNamed:@"personal_10.png"] forState:UIControlStateHighlighted];
                   UILabel *womanlabel=[[UILabel alloc]initWithFrame:CGRectMake(222,5, 20, 30)];
                    womanlabel.textAlignment=MMIATextAlignmentCenter;
                   womanlabel.font=[UIFont systemFontOfSize:16];
                   womanlabel.text=@"女";
                   [cell.lineContentView addSubview:womanlabel];
                   if (self.loginItem.sex == 0)
                   {
                       [manBtn setSelected:YES];
                   }else if (self.loginItem.sex == 1)
                   {
                       [womanBtn setSelected:YES];
                   }

               }else{
                   UILabel *typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
                   typeLabel.font=[UIFont systemFontOfSize:16];
                    typeLabel.textAlignment=MMIATextAlignmentLeft;
                   [cell.lineContentView addSubview:typeLabel];
                   typeLabel.text=[[self.dataArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
                   UILabel *nikeNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 5, 155, 30)];
                  nikeNameLabel.text=self.loginItem.nikeName;
                   nikeNameLabel.font=[UIFont systemFontOfSize:16];
                   nikeNameLabel.tag=NIKENAME_TEXTFILED_TAG;
                 nikeNameLabel.textAlignment=MMIATextAlignmentLeft;
                  [cell.lineContentView addSubview:nikeNameLabel];
               }
    
        
                }
     [cell resetSubViewWithSize:[tableView rectForRowAtIndexPath:indexPath].size withCellIndexPath:indexPath cellNumber:[self tableView:tableView numberOfRowsInSection:indexPath.section]];
   
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(10, 0, App_Frame_Width-20, 10)];
    if (section==0) {
        
        view.backgroundColor=[UIColor clearColor];
        
    }else{
        view.frame=CGRectMake(10, 0, 0, 0);
        view.hidden=YES;
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row==0) {
        
        [self changeImgIn];
    }
    if (indexPath.section==1 && indexPath.row==0)
    {
        UITextView *textView;
       
        MMiaTextPromptAlertView *alert = [MMiaTextPromptAlertView promptWithTitle:@"昵称" message:nil textView:&textView block:^(MMiaTextPromptAlertView *alert){
            //alert.textView.delegate=self;
            [alert.textView resignFirstResponder];
            [alert removeFromSuperview];
            
            return YES;
        }];
        [alert setMaxLength:1000];
        [alert setCancelButtonWithTitle:@"退出" block:nil];
        [alert addButtonWithTitle:@"保存" block:^{
            UILabel *nikeNameLabel=(UILabel *)[_tableView viewWithTag:NIKENAME_TEXTFILED_TAG];
            
            nikeNameLabel.text=textView.text;
        }];
        
        [self.view addSubview:alert];
        [alert show];
    }
}

#pragma mark - click headImageView
-(void)changeImgIn{
    
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄照片",@"从图片库选择", nil];
     [sheet showInView:self.view];

}
#pragma UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        _ipc.sourceType=UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_ipc animated:YES completion:^{
           BOOL isCameraValid = YES;
            if (iOS7)
            {
                AVAuthorizationStatus authStatus=[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                if (authStatus!=AVAuthorizationStatusAuthorized)
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
    UIImageView *imgView=(UIImageView *)[_tableView viewWithTag:HEAD_IMAGEVIEW_TAG];
    imgView.image=image;
   
  //  imgView.image=image;
//    
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* documentsDirectory = [paths objectAtIndex:0];
//    NSData *imageData= UIImageJPEGRepresentation(image, 1.0);
//    NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"headImage.jpg"];
//    [imageData writeToFile:fullPathToFile atomically:YES];
  
    
    
    if ([picker respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else if ([picker respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]){
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }

    //[picker dismissViewControllerAnimated:YES completion:nil];
    
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
