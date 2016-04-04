//
//  MMiaDetailGoodsViewController.m
//  MMIA
//
//  Created by lixiao on 14-9-22.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaDetailGoodsViewController.h"
#import "MMIToast.h"
#import "MMiaCommonUtil.h"
#import "MMiaMainViewWaterfallCell.h"
#import "MagezineItem.h"
#import "MMiaConcernPersonHomeViewController.h"
#import "MMIAPersonalHomePageViewController.h"
#import "MMiaInningMagezineViewController.h"
#import "MMiaCollectionViewWaterfallHeader.h"
#import "MMiaCollectionViewWaterfallFooter.h"
#import "MMiaDetailSpecialViewController.H"
#import "MMIALoginViewController.h"
#import "MMiaPopListView.h"
#import "MMIANewMagezineController.h"

#define HEAD_IMAGEVIEW_TAG    100
#define NIKENAME_LABEL_TAG    101
#define Fresh_Button_Tag      102
#define CELL_IDENTIFIER   @"cellId"
#define HEADER_IDENTIFIER @"headId"
#define IN_MAGEZINE_VIEW_TAG  201
#define LIKE_BUTTON_TAG    202
#define DELETE_BUTTON_TAG     203
#define Top_Back_Button       205
#define Label_Button_Tag      300
#define Big_ImageView_Tag     206

@interface MMiaDetailGoodsViewController() < MMiaPopListViewDelegate, MMIANewMagezineControllerDelegate >
{
    NSString *_title;
    NSInteger   _id;
    NSInteger  _productId;
    NSString  *_imageUrl;
    float   _width;
    float   _height;
    float   _price;
    UICollectionView *_collectionView;
    UIView *_headerView;
    BOOL   _isLike;
    int    _userId;
    BOOL    _reload;
    
}
@property (nonatomic, strong) UICollectionView* collectionView;
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,assign)CGFloat headerHeight;
@property(nonatomic,retain)NSMutableArray* magazineTypeArr;
@property(nonatomic,assign)NSInteger requestMagezineErrorCount;
@property(nonatomic,assign)NSInteger magazineIndex;
@end

@implementation MMiaDetailGoodsViewController

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
    if (self)
    {
        _title=title;
        _id=id;
        _imageUrl = imageUrl;
        _width=width;
        _height=height;
        _price=price;
        _productId=productId;
        
    }
    return self;
}
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        //背景视图
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        layout.columnCount=1;
        layout. minimumInteritemSpacing=0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.frame)) collectionViewLayout:layout];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[MMiaMainViewWaterfallCell class]
            forCellWithReuseIdentifier:CELL_IDENTIFIER];
      [_collectionView registerClass:[MMiaCollectionViewWaterfallHeader class]
           forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                 withReuseIdentifier:HEADER_IDENTIFIER];
        self.headerHeight = 10;
    }
    return _collectionView;
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.tabController hideOrNotCustomTabBar:YES];
    
    if( self.magazineTypeArr.count == 0 )
    {
        [self getUserAllMagazineDataStart:0];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _dataArray=[[NSMutableArray alloc]init];
    _headerView = [[UIView alloc]init];
    _magazineTypeArr = [[NSMutableArray alloc] init];
    [self.view insertSubview:self.collectionView belowSubview:self.navigationView];
    [self creatHeaderViewWithTitleArr:nil DataDict:nil];
    [self loadBgView];
    [self GetProductPicsByIdData];
}

#pragma mark -loadUI
- (void)loadBgView
{
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

-(void)creatHeaderViewWithTitleArr:(NSMutableArray *)titleArr DataDict:(NSMutableDictionary *)dataDict
{
    [_headerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    float rate;
    if (_width!=0)
    {
        rate=App_Frame_Width/_width;
    }
  
    UIImageView *bigImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width,  _height*rate)];
    bigImageView.tag = Big_ImageView_Tag;
    [bigImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl]];
    [_headerView addSubview:bigImageView];
    
    if (_userId != -1) {
        UIImage *likeImage;
        if (_isLike)
        {
            likeImage = [UIImage imageNamed:@"commoditypage_likebuttonselected.png"];
        }else
        {
            likeImage = [UIImage imageNamed:@"commoditypage_likebutton.png"];
        }
        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        likeButton.frame = CGRectMake(CGRectGetWidth(bigImageView.frame)-likeImage.size.width-20, CGRectGetHeight(bigImageView.frame)-likeImage.size.height-10, likeImage.size.width+20, likeImage.size.height);
        [likeButton setImage:likeImage forState:UIControlStateNormal];
        likeButton.tag = LIKE_BUTTON_TAG;
        [likeButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:likeButton];
    }
    
    
    UIView *firstView = [[UIView alloc]init];
    firstView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:firstView];
    
    
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
    CGFloat lastViewHeight = 0;
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
        lastViewHeight = CGRectGetHeight(titleLabel.frame)+10+8+10+(count+1)*(20+rowSpace)+5;

    }else
    {
        lastViewHeight = CGRectGetHeight(titleLabel.frame)+10+8+5;
    }
    firstView.frame = CGRectMake(0, _height*rate, App_Frame_Width, lastViewHeight);
    UILabel *lineLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lastViewHeight-0.5, App_Frame_Width, 0.5)];
    lineLabel2.backgroundColor = UIColorFromRGB(0xd9d9d9);
    [firstView addSubview:lineLabel2];
    
    CGFloat middleViewHeight = 0;
    if (_userId != -1)
    {
        UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, _height*rate+lastViewHeight, App_Frame_Width, 40+20)];
        middleView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:middleView];
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
        
        
//        CGFloat nikeNameWidth = [ [dataDict objectForKey:@"nickName"] sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(MAXFLOAT, 40) lineBreakMode:NSLineBreakByWordWrapping].width;
        UILabel *nikeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+15+10, 10, 176, 40)];
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
        middleViewHeight =CGRectGetHeight(middleView.frame) + 5;

    }else
    {
        middleViewHeight = 5;
    }
  
    
    
    
    if ([[dataDict objectForKey:@"desc"]length] != 0)
    {
        UIView *descriptionView = [[UIView alloc]init];
        descriptionView.backgroundColor = [UIColor whiteColor];
        [_headerView addSubview:descriptionView];
        UILabel *lineLabel5 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width, 0.5)];
        lineLabel5.backgroundColor = UIColorFromRGB(0xe5e5e5);
        [descriptionView addSubview:lineLabel5];

        
        UILabel *descriptionLabel = [[UILabel alloc]init];
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.text = [dataDict objectForKey:@"desc"];
        [descriptionLabel setFont:[UIFont systemFontOfSize:11]];
        [descriptionLabel setTextColor:UIColorFromRGB(0x404040)];
        CGFloat descripHeight = [ [dataDict objectForKey:@"desc"] sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(App_Frame_Width-20, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
        //descriptionLabel.backgroundColor = [UIColor whiteColor];
        
        descriptionView.frame = CGRectMake(0, _height*rate+lastViewHeight+middleViewHeight, App_Frame_Width,  descripHeight+20);
        descriptionLabel.frame = CGRectMake(10, _height*rate+lastViewHeight+middleViewHeight+10, App_Frame_Width-20, descripHeight);
        
        [_headerView addSubview:descriptionLabel];
        self.headerHeight = _height*rate+lastViewHeight+middleViewHeight+descripHeight+20;
    }else
    {
        self.headerHeight  = _height*rate+lastViewHeight+middleViewHeight;
    }
    
    
    _headerView.frame = CGRectMake(0, 0, App_Frame_Width, self.headerHeight);
    [self.collectionView reloadData];
    
}
#pragma mark -sendRequest
-(void)GetProductPicsByIdData
{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *userTicket=[defaults objectForKey:USER_TICKET];
    if (!userTicket) {
        userTicket=@"";
    }
   int userId=[[defaults objectForKey:USER_ID]intValue];
    if (!userId) {
        userId=0;
    }
    
    NSDictionary *infoDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:_id],@"id",userTicket,@"ticket",[NSNumber numberWithInt:userId],@"userid",[NSNumber numberWithLong:_productId],@"productId", nil];

    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_PRODUCTPIC_URL  param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
        if ([jsonDict[@"result"]intValue]==0)
        {
            [self.dataArray removeAllObjects];
            NSDictionary *dataDict=jsonDict[@"data"];
            NSDictionary *picturesDict=[dataDict objectForKey:@"pictures"];
            NSArray *pictUrlArr=[picturesDict objectForKey:@"pictureUrls"];
            for (NSDictionary *dict in pictUrlArr)
            {
                MagezineItem *item=[[MagezineItem alloc]init];
                item.imageHeight=[[dict objectForKey:@"height"]floatValue];
                item.imageWidth=[[dict objectForKey:@"width"]floatValue];
                item.pictureImageUrl=[dict objectForKey:@"url"];
                [self.dataArray addObject:item];
            }
            NSMutableArray *titleArr = [[NSMutableArray alloc]init];
            NSMutableDictionary *deDataDict = [[NSMutableDictionary alloc]init];
            if ([[picturesDict objectForKey:@"magazineName"]length]!=0)
            {
                [titleArr addObject:[picturesDict objectForKey:@"magazineName"]];
            }
            if ([[picturesDict objectForKey:@"brandName"]length]!=0)
            {
                [titleArr addObject:[picturesDict objectForKey:@"brandName"]];
            }
            if ([[picturesDict objectForKey:@"categoryName"]length]!=0)
            {
                [titleArr addObject:[picturesDict objectForKey:@"categoryName"]];
            }
            [deDataDict setObject:[picturesDict objectForKey:@"desc"] forKey:@"desc"];
            NSDictionary *userDict=[dataDict objectForKey:@"user"];

            [deDataDict setObject:[userDict objectForKey:@"userPictureUrl"] forKey:@"userPictureUrl"];
           [deDataDict setObject:[userDict objectForKey:@"nickName"] forKey:@"nickName"];
               if ([[picturesDict objectForKey:@"isLike"]intValue]==1)
               {
                  _isLike=YES;
               }else
               {
                   _isLike=NO;
               }
            
            _userId=[[userDict objectForKey:@"userId"]intValue];
            _reload=YES;
            [self creatHeaderViewWithTitleArr:titleArr DataDict:deDataDict];
            
        }else
        {
            [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
        }
        
//        [MMIToast showWithText:jsonDict[@"desc"] topOffset:100 image:nil];
        }errorHandler:^(NSError *error){
        
            if ([app.mmiaDataEngine isReachable]==NO)
            {
                [MMIToast showWithText:@"没有网络连接" topOffset:Main_Screen_Height-20 image:nil];
                
            }else
            {
                [MMIToast showWithText:@"网络异常，请重试" topOffset:Main_Screen_Height-20 image:nil];
                
            }

    }];
    
    
}
/*删除商品或图片*/
-(void)deleteProductPicRequest
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
    NSDictionary *infoDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:_id],@"productpicsid",userTicket,@"ticket",[NSNumber numberWithInt:userId],@"userid", nil];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_DELETEPRODUCTPIC_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict)
     {
         UIButton *deleteButton=(UIButton *)[self.navigationView viewWithTag:DELETE_BUTTON_TAG];
        
         
         if ([jsonDict[@"result"]intValue]==0)
         {
              [deleteButton setEnabled:NO];
             [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
             NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
             [nc postNotificationName:Change_MagezineData object:nil];
             
             for (UIViewController *vc in self.navigationController.viewControllers)
             {
                 if ([vc isKindOfClass:[MMiaDetailSpecialViewController class]])
                 {
                     if (self.deleteGoodsBlock) {
                         self.deleteGoodsBlock();
                     }
                     

                     [self.navigationController popToViewController:vc animated:YES];
                 }else if ([vc isKindOfClass:[MMiaShareViewController class]])
                 {
                     [self.shareDelegate returnShareVie];
                     [self.navigationController popToViewController:vc animated:YES];
                 }else if ([vc isKindOfClass:[MMiaLikeViewController class]])
                 {
                    //增加数据减少操作
                    // [self.likeDelegate returnLikeVieW];
                     [self.navigationController popToViewController:vc animated:YES];
                 }else if ([vc isKindOfClass:[MMiaTabLikeViewController class]])
                 {
                   [self.tabLikeDelegate returnTabLikeVieW];
                   [self.navigationController popToViewController:vc animated:YES];
                 }
                 
             }
             
         }else
         {
               [deleteButton setEnabled:YES];
             [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
         }
     }errorHandler:^(NSError *error)
     {
         UIButton *deleteButton=(UIButton *)[self.navigationView viewWithTag:DELETE_BUTTON_TAG];
         [deleteButton setEnabled:YES];
         if ([app.mmiaDataEngine isReachable]==NO)
         {
             [MMIToast showWithText:@"没有网络连接" topOffset:Main_Screen_Height-20 image:nil];
             
         }else
         {
              [MMIToast showWithText:@"网络异常，请重试" topOffset:Main_Screen_Height-20 image:nil];
             
         }

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
       
        UIButton *likeButton=(UIButton *)[_headerView viewWithTag:LIKE_BUTTON_TAG];
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
        
        UIButton *likeButton=(UIButton *)[_headerView viewWithTag:LIKE_BUTTON_TAG];
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
    NSDictionary *infoDict=[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:_id],@"shareId",userTicket,@"ticket",[NSNumber numberWithInt:userId],@"userid", nil];
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_DELETELIKE_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict){
       
        UIButton *likeButton=(UIButton *)[_headerView viewWithTag:LIKE_BUTTON_TAG];
        likeButton.enabled = YES;
        
        if ([jsonDict[@"result"]intValue]==0) {
            [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
            _isLike=NO;
            
            UIImage *likeInImage=[UIImage imageNamed:@"commoditypage_likebutton.png"];
            [likeButton setImage:likeInImage forState:UIControlStateNormal];
            
            NSDictionary *infoDict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInt:-1],Add_Like_Num, nil];
            NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
            [nc postNotificationName:Change_LikeData object:nil userInfo:infoDict];
           
        }else
        {
            [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
        }
        
    }errorHandler:^(NSError *error){
        
        UIButton *likeButton=(UIButton *)[_headerView viewWithTag:LIKE_BUTTON_TAG];
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
        
    }
    if (button.tag==DELETE_BUTTON_TAG)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"确定要删除吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        
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
    //收进专题
    if (button.tag == IN_MAGEZINE_VIEW_TAG)
    {
        MMiaPopListView* popListView = [[MMiaPopListView alloc] initWithTitle:@"选择要加入的专题" dataArray:self.magazineTypeArr isRound:YES];
        [popListView showInSuperView:self.view animated:YES];
        popListView.delegate = self;
        popListView.frame = CGRectMake(0, 0 , self.view.bounds.size.width, self.view.bounds.size.height );
        
//        UIImageView *imageView=(UIImageView *)[_headerView viewWithTag:Big_ImageView_Tag];
//        MMiaInningMagezineViewController *inMagezineVC=[[MMiaInningMagezineViewController alloc]initWithImage:imageView.image imgId:_productId];
//        inMagezineVC.delegate=self.delegate;
//        inMagezineVC.isLikeOrShareVC=YES;
//        [self.navigationController pushViewController:inMagezineVC animated:YES];
    }
    if (button.tag == Fresh_Button_Tag)
    {
        [self GetProductPicsByIdData];
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
    if (view.tag==HEAD_IMAGEVIEW_TAG || view.tag==NIKENAME_LABEL_TAG) {
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
        
            MMiaConcernPersonHomeViewController *concernPersonVC=[[MMiaConcernPersonHomeViewController alloc]initWithUserid:_userId];
            [self.navigationController pushViewController:concernPersonVC animated:YES];
            return;
    }
}

-(void)logonSuccess
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)registerSuccess
{
    [self.navigationController popViewControllerAnimated:NO];
     [self.navigationController popViewControllerAnimated:YES];
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error!=nil) {
        [MMIToast showWithText:@"图片保存失败" topOffset:Main_Screen_Height-20 image:nil];
    }else
    {
        [MMIToast showWithText:@"图片保存成功" topOffset:Main_Screen_Height-20 image:nil];
    }
}


#pragma mark -UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
   return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMiaMainViewWaterfallCell *cell =
    (MMiaMainViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER
                                                                           forIndexPath:indexPath];
    
    if (self.dataArray.count==0)
    {
        return cell;
    }
    MagezineItem *item=[self.dataArray objectAtIndex:indexPath.item];
    float aFloat = 0;
    if( item.imageWidth!=0 )
    {
        aFloat =App_Frame_Width / item.imageWidth;
    }
    cell.logoImageView.frame = CGRectMake(0.f, 0, App_Frame_Width, item.imageHeight * aFloat);
   
    [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl] placeholderImage:nil];
      return cell;
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem* item = [self.dataArray objectAtIndex:indexPath.item];
    float afloat = 0;
    
    if( item.imageWidth!=0 )
    {
        afloat = App_Frame_Width / item.imageWidth;
    }
    CGSize size = CGSizeMake(App_Frame_Width, item.imageHeight * afloat);
    
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    MMiaCollectionViewWaterfallHeader *reusableView = nil;
    if( [kind isEqualToString:CHTCollectionElementKindSectionHeader] )
    {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
        [reusableView fillContent:nil indexPath:indexPath];
       reusableView.backgroundColor=UIColorFromRGB(0xE1E1E1);
        [reusableView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [reusableView addSubview:_headerView];
        return reusableView;
    }
    return nil;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{
    float rate;
    if (_width!=0)
    {
        rate=App_Frame_Width/_width;
    }
    return MAX(self.headerHeight, _height*rate);
    
}

#pragma mark -alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        UIButton *deleteButton=(UIButton *)[self.navigationView viewWithTag:DELETE_BUTTON_TAG];
        [deleteButton setEnabled:NO];
        [self deleteProductPicRequest];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - MMIANewMagezineControllerDelegate

- (void)reloadUserAllMagazineData:(MMIANewMagezineController *)viewController
{
    [self getUserAllMagazineDataStart:0];
}

#pragma mark - MMiaPopListViewDelegate

-(void)popListView:(MMiaPopListView *)popListView didSelectedIndex:(NSInteger)aIndex
{
    if(aIndex == -1)
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        int userId=[[defaults objectForKey:USER_ID]intValue];
        NSString *userTicket=[defaults objectForKey:USER_TICKET];
        UIImageView *imageView=(UIImageView *)[_headerView viewWithTag:Big_ImageView_Tag];
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

//请求接口收进专题
#pragma mark - sendRequest

-(void)getUploadData
{
    UIImageView *imageView=(UIImageView *)[_headerView viewWithTag:Big_ImageView_Tag];
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
