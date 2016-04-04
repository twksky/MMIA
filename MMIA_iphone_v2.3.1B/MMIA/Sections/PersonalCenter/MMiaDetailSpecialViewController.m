//
//  MMiaDetailSpecialViewController.m
//  MMIA
//
//  Created by lixiao on 14-9-15.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaDetailSpecialViewController.h"
#import "MMiaQueryViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "MMiaMainViewWaterfallCell.h"
#import "MMIADetailSpecialViewWaterfallHeader.h"
#import "UIImage+ImageEffects.h"
#import "MMiaCommonUtil.h"
#import "MMiaDetailGoodsViewController.h"
#import "MMiaDetailPictureViewController.h"
#import "MMIToast.h"
#import "MJRefresh.h"
#import "MMiaErrorTipView.h"


#define CELL_IDENTIFIER   @"cellId"
#define HEADER_IDENTIFIER @"headerId"
#define EDIT_MAGEZINE_BUTTON_TAG  100
#define ATTENTION_BUTTON_TAG      101

const NSInteger size = 20;
@interface MMiaDetailSpecialViewController()<UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout,MMIADetailSpecialViewWaterfallHeaderDelegate>
{
    NSString*    _title;
    NSInteger    _magazineId;
    NSInteger    _userId;
    NSInteger    _selfId;
    NSInteger    _start;
    NSInteger    _isAttention;
    NSString*    _createData;
    float        _titleLableY;
    float        _collectionViewScorllY1;
    float        _collectionViewScorllY2;
    NSIndexPath* _indexPath;
    BOOL         _isLoadding;
}
@property (nonatomic, strong)UICollectionView* collectionView;
@property (nonatomic, strong)MMIADetailSpecialViewWaterfallHeader* header;
@property (nonatomic, strong)NSMutableArray* magazineArr;
@property (nonatomic, strong)NSString* firstImgURL;
@end

@implementation MMiaDetailSpecialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithTitle:(NSString *)title MagazineId:(NSInteger)magazineId UserId:(NSInteger)userId isAttention:(NSInteger)isAttention
{
    self=[super init];
    if (self) {
        _title=title;
        _magazineId = magazineId;
        _userId = userId;
        _isAttention = isAttention;
    }
    return self;
}

-(UICollectionView*)collectionView
{
    if( !_collectionView )
    {
    CHTCollectionViewWaterfallLayout* layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(9, 9, 9, 9);
    layout.headerHeight = 200;
    layout.minimumColumnSpacing = 7;
    layout.minimumInteritemSpacing = 7;
    layout.columnCount = 2;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[MMiaMainViewWaterfallCell class]
        forCellWithReuseIdentifier:CELL_IDENTIFIER];
    [_collectionView registerClass:[MMIADetailSpecialViewWaterfallHeader class]
        forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
               withReuseIdentifier:HEADER_IDENTIFIER];
    }
    return _collectionView;
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    [appDelegate.tabController hideOrNotCustomTabBar:YES];
  
    }


- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    NSNotificationCenter *nc=[NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(doDetailMagezineRequest:) name:Change_LikeData object:nil];
    _magazineArr = [[NSMutableArray alloc] init];
    [self.view addSubview:self.collectionView];
    [self.view bringSubviewToFront:self.navigationView];
//    [self.view bringSubviewToFront:[self.view viewWithTag:1000]];
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestMagazineInfoData];
    [MMiaLoadingView showLoadingForView:self.view];
    [_header isAttention: _isAttention];
}

- (void)requestMagazineInfoData
{
    _isLoadding = YES;
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:_userId],@"userid",[NSNumber numberWithInt:_magazineId],@"magazineId",[NSNumber numberWithLong:_start],@"start",[NSNumber numberWithInt:size],@"size",nil];
    [appDelegate.mmiaDataEngine startAsyncRequestWithUrl:MMia_MAGAZINESHARELIST_URL param:param requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *resultDict)
     {
         NSInteger result = [resultDict[@"result"] integerValue];
         if(result == 0)
         {
             
             NSDictionary *dataDict = resultDict[@"data"];
             _firstImgURL = dataDict[@"magazineCover"];
             _createData = dataDict[@"createTime"];
             NSArray* dataArr = dataDict[@"pics"];
             
             for (NSDictionary* dict in dataArr)
             {
                 MagezineItem* item = [[MagezineItem alloc] init];
                 item.aId = [dict[@"id"] intValue];
                 item.pictureImageUrl = dict[@"pictureUrl"];
                 item.imageWidth = [dict[@"width"] floatValue];
                 item.imageHeight = [dict[@"height"] floatValue];
                 item.likeNum  = [dict[@"likedNum"] integerValue];
                 item.logoWord = dict[@"title"];
                 item.magazineId = [dict[@"productId"] integerValue];
                 [self.magazineArr addObject:item];
             }
             [self refreshDetailSpecialPage];
         }else
         {
             [self netWorkError:nil];
         }
     }errorHandler:^(NSError *error){
         [self netWorkError:error];
     }];
}

- (void)initNewNavigationView
{
    [super initNewNavigationView];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    _selfId =[[defaults objectForKey:USER_ID]intValue];
    [self setNaviBarViewBackgroundColor: [UIColor colorWithRed:0x39 /255.0f green:0x3b /255.0f blue:0x49 /255.0f alpha:1]];
    [self addNewBackBtnWithTarget:self selector:@selector(backButClick:)];
    UIImage* image = [UIImage imageNamed:@"searchresultpage_searchbutton.png"];
    [self addNewRightBtnWithImage:image Target:self selector:@selector(rightButClick:)];
    [self setTitleString:_title];
    self.titleLabel.textColor = [UIColor whiteColor];
    CGRect rect =  self.titleLabel.frame;
    _titleLableY = 80;
    rect.origin.y = _titleLableY;
    self.titleLabel.frame = rect;
    self.navigationView.backgroundColor = [UIColor clearColor];
}

- (void)backButClick:(id)but
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButClick:(id)but
{
    MMiaQueryViewController *queryVC=[[MMiaQueryViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFromRight;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:queryVC animated:NO];

}

#pragma mark -Notification
- (void)doDetailMagezineRequest:(NSNotification *)nc
{
    if (_indexPath)
    {
        int likeNum=[[nc.userInfo objectForKey:Add_Like_Num]intValue];
        MagezineItem* item = [self.magazineArr objectAtIndex:_indexPath.item];
        item.likeNum+=likeNum;
        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:_indexPath]];
    }
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.magazineArr.count;
}

- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        _header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HEADER_IDENTIFIER forIndexPath:indexPath];
        _header.delegate = self;
        _header.bgImgView.contentMode = UIViewContentModeCenter | UIViewContentModeScaleAspectFill;
        [_header initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
        [_header.bgImgView sd_setImageWithURL:[NSURL URLWithString:_firstImgURL]];
//        [header.bgImgView sd_setImageWithURL:[NSURL URLWithString:_firstImgURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            image = [image applyBlurWithRadius:10 tintColor:[UIColor clearColor] saturationDeltaFactor:10 maskImage:image];
//            [header.bgImgView setImage:image];
//        }];
        
        _header.bgImgView.contentMode = UIViewContentModeCenter | UIViewContentModeScaleAspectFill;
        
        _header.createTimeView.text = _createData;
        _header.createTimeView.backgroundColor = [UIColor clearColor];
        if (_selfId == _userId)
        {
            _header.attentionBut.hidden = YES;
        }else
        {
        [_header isAttention:_isAttention];
        }
        return _header;
    }
    return nil;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMiaMainViewWaterfallCell *cell =
    (MMiaMainViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.layer.cornerRadius=4.0;
    cell.clipsToBounds=YES;
    
    cell.contentView.layer.cornerRadius=4.0;
    cell.contentView.clipsToBounds=YES;
    cell.contentView.backgroundColor=[UIColor clearColor];
    MagezineItem *item=[self.magazineArr objectAtIndex:indexPath.item];
    CGFloat aFloat = 0;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:item.pictureImageUrl]];
    
    cell.imageView.backgroundColor=[UIColor clearColor];
    //cell.imageView.layer.cornerRadius=4.0;
    cell.imageView.clipsToBounds=YES;
    
    if( item.imageWidth )
    {
        aFloat = Homepage_Cell_Image_Width / item.imageWidth;
    }
    cell.imageView.frame = CGRectMake(0.f, cell.bounds.origin.y, Homepage_Cell_Image_Width, item.imageHeight * aFloat);
    
    NSString* lbText = item.logoWord;
    cell.displayLabel.text = lbText;
    cell.displayLabel.numberOfLines = 0;
    cell.displayLabel.textAlignment = MMIATextAlignmentLeft;
    CGFloat labelH = [MMiaCommonUtil getTextHeightWithFontOfSize:12 string:lbText];
    cell.displayLabel.frame = CGRectMake(6.f, cell.contentView.bounds.origin.y + cell.imageView.frame.size.height + 8, Homepage_Cell_Image_Width - 12, labelH);
    cell.likeLabel.text = [NSString stringWithFormat:@"%ld", (long)item.likeNum];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagezineItem* item = [self.magazineArr objectAtIndex:indexPath.item];
    
    CGFloat afloat = 0;
    
    if( item.imageWidth )
    {
        afloat = Homepage_Cell_Image_Width / item.imageWidth;
    }
    CGFloat labelHeight = [MMiaCommonUtil getTextHeightWithFontOfSize:12 string:item.logoWord];
    if( labelHeight > 0 )
    {
        labelHeight += 8;
    }
    labelHeight += 29;
    
    CGSize size = CGSizeMake(Homepage_Cell_Image_Width, item.imageHeight * afloat + labelHeight);
    
    return size;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(_isLoadding)
    {
        return;
    }
    _collectionViewScorllY2 = scrollView.contentOffset.y;
    CGRect rect =  self.titleLabel.frame;
    if (_collectionViewScorllY1 < _collectionViewScorllY2)
    {
        if (_titleLableY - _collectionViewScorllY2 >= VIEW_OFFSET)
        {
            CGRect rect =  self.titleLabel.frame;
            rect.origin.y = _titleLableY - _collectionViewScorllY2 ;
            self.titleLabel.frame = rect;
        }else if(rect.origin.y != VIEW_OFFSET)
        {
            CGRect rect =  self.titleLabel.frame;
            rect.origin.y = VIEW_OFFSET;
            self.titleLabel.frame = rect;
        }
    }else
    {
        if(_titleLableY - _collectionViewScorllY2 >= VIEW_OFFSET)
        {
            CGRect rect =  self.titleLabel.frame;
            rect.origin.y = _titleLableY - _collectionViewScorllY2 ;
            self.titleLabel.frame = rect;
        }
    }
    if (_collectionViewScorllY2 > 0 && _collectionViewScorllY2 <= 200)
    {
        [self setNaviBarViewBackgroundColor: [UIColor colorWithRed:0x39 /255.0f green:0x3b /255.0f blue:0x49 /255.0f alpha:_collectionViewScorllY2 / 200.0f]];
    }else if(_collectionViewScorllY2 >=200)
    {
        [self setNaviBarViewBackgroundColor: [UIColor colorWithRed:0x39 /255.0f green:0x3b /255.0f blue:0x49 /255.0f alpha:1]];
    }else if(_collectionViewScorllY2 <= 0)
    {
        [self setNaviBarViewBackgroundColor: [UIColor colorWithRed:0x39 /255.0f green:0x3b /255.0f blue:0x49 /255.0f alpha:0]];
    }
    _collectionViewScorllY1 = _collectionViewScorllY2;
}

#pragma mark -UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    MagezineItem* item = [self.magazineArr objectAtIndex:indexPath.item];
    if (item.magazineId>0)
    {
        MMiaDetailGoodsViewController *detailGoodsVC=[[MMiaDetailGoodsViewController alloc]initWithTitle:item.logoWord Id:item.aId goodsImage:item.pictureImageUrl Width:item.imageWidth Height:item.imageHeight price:item.imgPrice productId:item.magazineId];
        detailGoodsVC.delegate = self;
        detailGoodsVC.productpicsid = _magazineId;
        detailGoodsVC.specialTitle = _title;
        detailGoodsVC.deleteGoodsBlock = ^{
            if (_indexPath)
            {
                [self.magazineArr removeObjectAtIndex:_indexPath.item];
                [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:_indexPath]];
            }
            
        };
        [self.navigationController pushViewController:detailGoodsVC animated:YES];
    }else
    {
        MMiaDetailPictureViewController *detailPictureVC=[[MMiaDetailPictureViewController alloc]initWithTitle:item.logoWord Id:item.aId goodsImage:item.pictureImageUrl Width:item.imageWidth Height:item.imageHeight price:item.imgPrice productId:item.magazineId];
        detailPictureVC.delegate = self;
        detailPictureVC.productpicsid = _magazineId;
        detailPictureVC.specialTitle = _title;
        detailPictureVC.deletePicBlock = ^{
            if (_indexPath)
            {
                [self.magazineArr removeObjectAtIndex:_indexPath.item];
                [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:_indexPath]];
            }
            
        };
        [self.navigationController pushViewController:detailPictureVC animated:YES];
    }
    
}

#pragma mark 上拉加载更多
- (void)addRefreshFooter
{
    __block MMiaDetailSpecialViewController* detailSpecialVC = self;
    [self.collectionView addFooterWithCallback:^{
        if( detailSpecialVC->_isLoadding )
            return;
        detailSpecialVC->_isLoadding = YES;
        _start += size;
        [self requestMagazineInfoData];
    }];
}

- (void)removeRefreshFooter
{
    if(![_collectionView isFooterHidden])
    {
        [_collectionView removeFooter];
    }
}


- (void)netWorkError:(NSError *)error
{
    _isLoadding = NO;
    [self setNaviBarViewBackgroundColor: [UIColor colorWithRed:0x39 /255.0f green:0x3b /255.0f blue:0x49 /255.0f alpha:1]];

    [MMiaLoadingView hideLoadingForView:self.view];

    [_collectionView footerEndRefreshing];
    if( self.magazineArr.count == 0)
    {
        CGFloat errTipY = (CGRectGetHeight(self.view.bounds) - 125)/2;
        CGFloat errTipX = CGRectGetWidth(self.view.bounds) / 2;
        [MMiaErrorTipView showErrorTipForView:self.view center:CGPointMake(errTipX, errTipY) error:error delegate:self];
    }
    else
    {
        [MMiaErrorTipView showErrorTipForErroe:error];
        [MMiaErrorTipView hideErrorTipForView:self.view];
    }
}

- (void)refreshDetailSpecialPage
{
    _isLoadding = NO;
    [self setNaviBarViewBackgroundColor: [UIColor colorWithRed:0x39 /255.0f green:0x3b /255.0f blue:0x49 /255.0f alpha:0]];
    [MMiaErrorTipView hideErrorTipForView:self.view];
    
    [MMiaLoadingView hideLoadingForView:self.view];

    [_collectionView footerEndRefreshing];
    
    [self.collectionView reloadData];
    if( self.magazineArr.count % Request_Data_Count == 0 )
    {
        [self addRefreshFooter];
    }
    else
    {
        [self removeRefreshFooter];
    }
}

#pragma mark -MMiaErrorTipViewDelegate

- (void)onErrorTipViewRefreshBtnClicked:(MMiaErrorTipView* )sender
{
    [MMiaErrorTipView hideErrorTipForView:self.view];
    _isLoadding = YES;
    [MMiaLoadingView showLoadingForView:self.view];
    _start = 0;
    [self requestMagazineInfoData];
}

#pragma mark MMIADetailSpecialViewWaterfallHeaderDelegate
-(void) attentionButClinck
{
    if(_isAttention == 0)
    {
        [self FollowmagazineRequestMagazineid];
    }else
    {
        [self cancelFollowmagazineRequestMagazineid];
    }
}
//取消关注杂志
-(void)cancelFollowmagazineRequestMagazineid
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
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
    NSDictionary *infoDict=[NSDictionary dictionaryWithObjectsAndKeys:userTicket,@"ticket",[NSNumber numberWithInt:userId],@"myUserid",[NSNumber numberWithLong:_magazineId],@"magazineid", nil];
    
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_CANCEL_FOLLOWMAGZINE_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict)
     {
         
         if ([jsonDict[@"result"]intValue]==0)
         {
             //lx add
             if (self.magezineBlock)
             {
                 self.magezineBlock(-1);
             }
             _isAttention = 0;
             [_header isAttention:_isAttention];
             [MMIToast showWithText:@"取消关注成功" topOffset:Main_Screen_Height-20 image:nil];
         }else
         {
             [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
         }
     }errorHandler:^(NSError *error){
         [MMIToast showWithText:@"取消关注失败" topOffset:Main_Screen_Height-20 image:nil];
     }];
}

//关注专题

-(void)FollowmagazineRequestMagazineid
{
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
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
    NSDictionary *infoDict=[NSDictionary dictionaryWithObjectsAndKeys:userTicket,@"ticket",[NSNumber numberWithInt:userId],@"myUserid",[NSNumber numberWithLong:_magazineId],@"magazineid", nil];
    [app.mmiaDataEngine startAsyncRequestWithUrl:MMia_FOLLOWMAGZINE_URL param:infoDict requestMethod:HTTP_REQUEST_POST completionHandler:^(NSDictionary *jsonDict)
     {
         if ([jsonDict[@"result"]intValue]==0)
         {
             //lx add
             if (self.magezineBlock)
             {
                 self.magezineBlock(1);
             }
             
             _isAttention = 1;
            [_header isAttention:_isAttention];
             [MMIToast showWithText:@"关注成功" topOffset:Main_Screen_Height-20 image:nil];
         }else
         {
             [MMIToast showWithText:jsonDict[@"msg"] topOffset:Main_Screen_Height-20 image:nil];
         }
     }errorHandler:^(NSError *error){
         [MMIToast showWithText:@"关注失败" topOffset:Main_Screen_Height-20 image:nil];
     }];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Change_LikeData object:nil];
}


- (void) didReceiveMemoryWarning
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
