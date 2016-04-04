//
//  MMiaQueryViewController.m
//  MMIA
//
//  Created by lixiao on 14-10-29.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaQueryViewController.h"
#import "MMiaSearchViewController.h"


#define Deletate_Label_Tag 102
#define Search_Button_Tag   101
#define Hot_Button_Tag   300
#define History_Button_Tag 400
static const CGFloat Search_Image_Margin = 10;

@interface MMiaQueryViewController ()<MMiaSearchViewControllerDelegate>
{
    NSMutableArray* _buttonArr;
    UITextField  *_searchTextFiled;
}
@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic,retain) UIView *hotView;
@property (nonatomic,retain) UIView *historyView;
@property (nonatomic,retain) UIScrollView *bgScrollView;

@end

@implementation MMiaQueryViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf0f0f0);
    [self loadNavView];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    self.bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+VIEW_OFFSET, App_Frame_Width,  Main_Screen_Height-20-44)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    [self.bgScrollView addGestureRecognizer:tap];
    self.bgScrollView.backgroundColor = [UIColor clearColor];
    self.bgScrollView.delegate = self;
    [self.view addSubview:self.bgScrollView];
    self.hotView = [[UIView alloc]init];
    self.hotView.backgroundColor = [UIColor clearColor];
    self.historyView = [[UIView alloc]init];
    self.historyView.backgroundColor = [UIColor clearColor];
    [self.bgScrollView addSubview:self.hotView];
    [self.bgScrollView addSubview:self.historyView];
   [self getHotDataRequest];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[self historyInfoPath]]) {
        NSMutableArray *historyArr = [NSMutableArray arrayWithContentsOfFile:[self historyInfoPath]];
     [self creatHistoryViewWith:historyArr];
    }
    
    

}
-(void)loadNavView
{
    [self setNaviBarViewBackgroundColor: UIColorFromRGB(0x393b49)];
    [self addNewBackBtnWithTarget:self selector:@selector(btnClick:)];
   _searchTextFiled=[[UITextField alloc]init];
    _searchTextFiled.frame = CGRectMake((CGRectGetWidth(self.navigationView.frame)-App_Frame_Width+100)/2, (kNavigationBarHeight-32)/2 + VIEW_OFFSET, App_Frame_Width-100, 32);
    _searchTextFiled.layer.cornerRadius = 15;
     [_searchTextFiled performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
    _searchTextFiled.delegate=self;
    UIColor *placeHolerColcor=UIColorFromRGB(0x969696);
    _searchTextFiled.attributedPlaceholder=[[NSAttributedString alloc]initWithString:@"搜索你喜欢的商品或商家" attributes:@{NSForegroundColorAttributeName: placeHolerColcor}];
    _searchTextFiled.font = [UIFont boldSystemFontOfSize:13];
    _searchTextFiled.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
    _searchTextFiled.textColor = UIColorFromRGB(0x969696);
    _searchTextFiled.backgroundColor=[UIColor whiteColor];
    _searchTextFiled.clearButtonMode=UITextFieldViewModeAlways;
    _searchTextFiled.leftViewMode=UITextFieldViewModeAlways;
      
    UIImage* _image = [UIImage imageNamed:@"searchpage_topsearchicon.png"];
    UIView *leftView=[[UIView alloc]initWithFrame:CGRectMake(0, (CGRectGetHeight(_searchTextFiled.bounds) - _image.size.height)/2, _image.size.width+2*Search_Image_Margin, _image.size.height)];
    leftView.backgroundColor=[UIColor clearColor];
    UIImageView* searchImage = [[UIImageView alloc] initWithFrame:CGRectMake( 10, 0, _image.size.width, _image.size.height )];
    searchImage.image = _image;
    [leftView addSubview:searchImage];
     _searchTextFiled.leftView = leftView;
    _searchTextFiled.returnKeyType= UIReturnKeySearch;
    [self.navigationView addSubview:_searchTextFiled];
    
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(App_Frame_Width-10-32, (kNavigationBarHeight-25)/2+ VIEW_OFFSET, 32, 25)];
    searchButton.tag = Search_Button_Tag;
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [searchButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [searchButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:searchButton];
    
}

//建立热门推荐

-(void)creatHotRecommendViewWith:(NSMutableArray *)hotArray
{
    //打乱
    for (int i = 0; i < hotArray.count; i++)
    {
        int m = (arc4random() % (hotArray.count - i)) + i;
        [hotArray exchangeObjectAtIndex:i withObjectAtIndex: m];
    }
    
    UIImage *hotImage = [UIImage imageNamed:@"searchpage_fireicon.png"];
    CGFloat height = [self creatSectionViewWithTitleImage:hotImage Title:@"热门推荐" LabelArr:hotArray Basetag:Hot_Button_Tag AddView:self.hotView];
    self.hotView.frame = CGRectMake(0, 0, App_Frame_Width, height);
    CGRect frame = self.historyView.frame;
    frame.origin.y = height;
    self.historyView.frame = frame;
    [self calculateScrollViewContentSize];
}
//建立历史记录
-(void)creatHistoryViewWith:(NSMutableArray *)historyArray
{
    UIImage *historyImage = [UIImage imageNamed:@"searchpage_searchhistoryicon.png"];
    CGFloat height = [self creatSectionViewWithTitleImage:historyImage Title:@"搜索历史" LabelArr:historyArray Basetag:History_Button_Tag AddView:self.historyView];
    
    UIView *deleteView = [[UIView alloc]init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteTapClick)];
    [deleteView addGestureRecognizer:tap];
    deleteView.backgroundColor = [UIColor clearColor];
    [self.historyView addSubview:deleteView];
    UIImage *deleteImage = [UIImage imageNamed:@"searchpage_clearhistoryicon.png"];
    UIImageView *deleteImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, deleteImage.size.width, deleteImage.size.height)];
    deleteImageView.image = deleteImage;
    [deleteView addSubview:deleteImageView];

    NSString *deleteTitle = @"清空搜索历史";
    UIFont *deleteFont = [UIFont systemFontOfSize:14];
    CGFloat labelWidth = [deleteTitle sizeWithFont:deleteFont constrainedToSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(deleteImageView.frame)) lineBreakMode:NSLineBreakByWordWrapping].width;
    UILabel *deleteLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(deleteImageView.frame)+7.5, 15, labelWidth, CGRectGetHeight(deleteImageView.frame))];
    deleteLabel.text = deleteTitle;
    deleteLabel.backgroundColor = [UIColor clearColor];
    deleteLabel.font = deleteFont;
    [deleteView addSubview:deleteLabel];
    
    CGFloat deleteWidth = CGRectGetWidth(deleteImageView.frame)+7.5+labelWidth;
    deleteView.frame = CGRectMake((App_Frame_Width-deleteWidth)/2, height, deleteWidth, 15 + CGRectGetHeight(deleteImageView.frame));
    height += 15 + CGRectGetHeight(deleteImageView.frame);

    self.historyView.frame = CGRectMake(0, CGRectGetHeight(self.hotView.frame), App_Frame_Width, height);
   
    [self calculateScrollViewContentSize];
   
}
//布局
-(CGFloat)creatSectionViewWithTitleImage:(UIImage *)imag Title:(NSString *)title LabelArr:(NSMutableArray *)arr Basetag:(int)baseTag AddView:(UIView *)addView
{
    [addView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (arr.count == 0)
    {
        return 0;
    }
    UIImageView *hotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 13, imag.size.width, imag.size.height)];
    hotImageView.image = imag;
    [addView addSubview:hotImageView];
    UILabel *hotLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(hotImageView.frame)+5, 13, 100, CGRectGetHeight(hotImageView.frame))];
    hotLabel.textAlignment = MMIATextAlignmentLeft;
    hotLabel.text = title;
    hotLabel.backgroundColor = [UIColor clearColor];
    hotLabel.font = [UIFont systemFontOfSize:15];
    hotLabel.textColor = UIColorFromRGB(0xe14a4a);
    [addView addSubview:hotLabel];
    CGFloat hotViewHeight= 13 +CGRectGetHeight(hotImageView.frame)+10;
    int row = 20,count = 0;
    int rowSpace = 10;
    for (int i=0; i < arr.count; i++)
    {
        NSString *str = [arr objectAtIndex:i];
        CGFloat width = [str sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:NSLineBreakByWordWrapping].width+30;
        
        if (row+10+width > App_Frame_Width-10)
        {
            row = 20;
            count ++;
        }
        UIButton *hotButton = [[UIButton alloc]initWithFrame:CGRectMake(row, hotViewHeight+count*(20+rowSpace), width, 20)];
        hotButton.tag = baseTag+i;
        UIImage *backImage = [UIImage imageNamed:@"commoditypage_tag.png"];
        backImage = [backImage stretchableImageWithLeftCapWidth:floorf(backImage.size.width/2) topCapHeight:floorf(backImage.size.height/2)];
        [hotButton setBackgroundImage:backImage forState:UIControlStateNormal];
        [hotButton setBackgroundImage:[UIImage imageNamed:@"commoditypage_tagselected.png"] forState:UIControlStateHighlighted];
        [hotButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [hotButton setTitle:str forState:UIControlStateNormal];
        [hotButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [hotButton setTitleColor:UIColorFromRGB(0x6c6c6c) forState:UIControlStateNormal];
        [addView addSubview:hotButton];
        row += 10 + width;
        
    }
    hotViewHeight = hotViewHeight+(count+1)*(20+rowSpace);
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, hotViewHeight-0.5, App_Frame_Width-20, 0.5)];
    lineLabel.backgroundColor = UIColorFromRGB(0x969696);
    [addView addSubview:lineLabel];
    return hotViewHeight;
}

//计算scrollViewContentSize
-(void)calculateScrollViewContentSize
{
    if (CGRectGetHeight(self.hotView.frame)+CGRectGetHeight(self.historyView.frame)+10+self.keyboardHeight >= CGRectGetHeight(self.bgScrollView.frame))
    {
        self.bgScrollView.contentSize = CGSizeMake(App_Frame_Width, CGRectGetHeight(self.hotView.frame)+CGRectGetHeight(self.historyView.frame)+10+self.keyboardHeight);
    }else
    {
        self.bgScrollView.contentSize = CGSizeMake(App_Frame_Width, CGRectGetHeight(self.bgScrollView.frame)+10);
    }

}

#pragma mark - sendRequest

//获得搜索热词
-(void)getHotDataRequest
{
     AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *hotStr = @"humpback4/getMobileRecommendTag.do";
    [app.mmiaDataEngine startAsyncRequestWithUrl:hotStr param:nil requestMethod:HTTP_REQUEST_GET completionHandler:^(NSDictionary *jsonDict)
    {
        if ([jsonDict[@"result"] intValue]==0)
        {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            NSArray *hotArray = jsonDict[@"data"];
            for (NSDictionary *dict in hotArray)
            {
                [array addObject:[dict objectForKey:@"name"]];
            }
            [self creatHotRecommendViewWith:array];
            
        }
        
    }errorHandler:^(NSError *error)
    {
                        
    }];
}

#pragma mark - keyboardNotification

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    CGSize keyboardSize = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.keyboardHeight = keyboardSize.height;
    [self calculateScrollViewContentSize];
   
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.keyboardHeight = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.bgScrollView.contentOffset = CGPointZero;
    }];
    [self calculateScrollViewContentSize];
}

#pragma mark - buttonClick
//删除历史记录
-(void)deleteTapClick
{
    [self.historyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.historyView.frame = CGRectZero;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *historyPath=[self historyInfoPath];
    [fm removeItemAtPath:historyPath error:nil];
    if (CGRectGetHeight(self.hotView.frame)+CGRectGetHeight(self.historyView.frame)+10+self.keyboardHeight >= CGRectGetHeight(self.bgScrollView.frame))
    {
        self.bgScrollView.contentSize = CGSizeMake(App_Frame_Width, CGRectGetHeight(self.hotView.frame)+CGRectGetHeight(self.historyView.frame)+10+self.keyboardHeight);
    }else
    {
        self.bgScrollView.contentSize = CGSizeMake(App_Frame_Width, CGRectGetHeight(self.bgScrollView.frame)+20);
    }


    
}
-(void)btnClick:(UIButton *)button
{
    [_searchTextFiled resignFirstResponder];
    if (button.tag == 1003)
    {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFromRight;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }
    if (button.tag == Search_Button_Tag)
    {
        NSInteger newLength=[_searchTextFiled.text length];
        NSString *newStr;
        if (newLength!=0)
        {
            newStr=[_searchTextFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            newLength=newStr.length;
        }
        if (newLength==0)
        {
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入关键字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        [self writeHistoryFile];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        int userId=[[defaults objectForKey:USER_ID]intValue];
        MMiaSearchViewController *searchVc = [[MMiaSearchViewController alloc]initWithUserid:userId keyword:newStr];
        searchVc.delegate = self;
        [self.navigationController pushViewController:searchVc animated:YES];
    }
    if ((button.tag >= Hot_Button_Tag && button.tag <= History_Button_Tag) || (button.tag>= History_Button_Tag && button.tag <= History_Button_Tag+10)){
        _searchTextFiled.text = button.titleLabel.text;
        [self writeHistoryFile];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        int userId=[[defaults objectForKey:USER_ID]intValue];
        MMiaSearchViewController *searchVc = [[MMiaSearchViewController alloc]initWithUserid:userId keyword:button.titleLabel.text];
        searchVc.delegate = self;
        [self.navigationController pushViewController:searchVc animated:YES];
       
        return;
    }
}

-(void)tapClick
{
    [_searchTextFiled resignFirstResponder];
}

#pragma mark -saveData
-(NSString *)searchPath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
-(NSString *)historyInfoPath
{
    NSString *searchDic=[self searchPath];
    NSString *historyInfoPath = [searchDic stringByAppendingPathComponent:@"history.plist"];
    return historyInfoPath;
}

-(void)creatHistoryPlist
{
    NSString *historyPath=[self historyInfoPath];
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm createFileAtPath:historyPath contents:nil attributes:nil];
}
-(void)writeHistoryFile
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *historyPath=[self historyInfoPath];
    if ([fm fileExistsAtPath:historyPath]==NO)
    {
        [self creatHistoryPlist];
    }
    NSArray *arr1 = [NSArray arrayWithContentsOfFile:historyPath];
    NSMutableArray *mutableArr=[[NSMutableArray alloc]initWithArray:arr1];
    NSString *newStr=[_searchTextFiled.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString *searchStr in mutableArr)
    {
        if ([searchStr isEqualToString:newStr])
        {
            [mutableArr removeObject:searchStr];
            break;
        }
    }
     [mutableArr insertObject:newStr atIndex:0];
    NSMutableArray *insertArr=[[NSMutableArray alloc]init];
    if (mutableArr.count>10)
    {
        for (int i=0; i<10; i++)
        {
            NSString *str=[mutableArr objectAtIndex:i];
            [insertArr addObject:str];
        }
    }else
    {
        insertArr=mutableArr;
    }

    [insertArr writeToFile:historyPath atomically:YES];
    [self creatHistoryViewWith:mutableArr];
}

#pragma mark -textFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger newLength=[textField.text length];
    NSString *newStr;
    if (newLength!=0)
    {
        newStr=[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        newLength=newStr.length;
    }
    if (newLength==0)
    {
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入关键字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    _searchTextFiled.text=textField.text;
    [textField resignFirstResponder];
    [self writeHistoryFile];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    int userId=[[defaults objectForKey:USER_ID]intValue];
    MMiaSearchViewController *searchVc = [[MMiaSearchViewController alloc]initWithUserid:userId keyword:newStr];
    searchVc.delegate = self;
    [self.navigationController pushViewController:searchVc animated:YES];
    return YES;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   // [_searchTextFiled resignFirstResponder];
}

#pragma mark - MMiaSearchViewControllerDelegate
-(void)clickSearchKeyWord:(NSString *)keyWord
{
    _searchTextFiled.text = keyWord;
      [self writeHistoryFile];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
