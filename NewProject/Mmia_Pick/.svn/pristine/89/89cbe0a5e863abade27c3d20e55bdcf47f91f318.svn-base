//
//  MmiaPaperViewController.m
//  MMIA
//
//  Created by MMIA-Mac on 15-5-19.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaPaperViewController.h"
#import "MmiaCollectionViewLargeLayout.h"
#import "MmiaSingleGoodsCollectionCell.h"
#import "MmiaBrandCollectionCell.h"
#import "MmiaLoadingCollectionCell.h"
#import "MmiaDescripBrandCollectionCell.h"
#import "MmiaHomeRecomRequestModel.h"
#import "MmiaHomePageModel.h"


static CGFloat const AD_SCROLL_RunloopTime = 5.0;

@interface MmiaPaperViewController () <UINavigationControllerDelegate>
{
    NSTimer*   _myTimer;
    NSInteger  _slide;
}

- (void)configPaperView;

@end

@implementation MmiaPaperViewController

#pragma mark - init

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if( self = [super initWithCollectionViewLayout:layout] )
    {
        _topDataArray = [[NSMutableArray alloc]init];
        _itemsArray = [[NSMutableArray alloc]init];
        UINib* nib1 = [UINib nibWithNibName:@"MmiaBrandCollectionCell" bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:MmiaBrandCellIdentifier ];
        UINib* nib2 = [UINib nibWithNibName:@"MmiaSingleGoodsCollectionCell" bundle:[NSBundle mainBundle]];
        UINib *nib3 = [UINib nibWithNibName:@"MmiaDescripBrandCollectionCell" bundle:[NSBundle mainBundle]];
        
        [self.collectionView registerNib:nib2 forCellWithReuseIdentifier:MmiaSingleGoodsCellIdentifier];
        [self.collectionView registerClass:[MmiaLoadingCollectionCell class] forCellWithReuseIdentifier:MmiaLoadCellIdentifier];
        [self.collectionView registerNib:nib3 forCellWithReuseIdentifier:MmiaDescriptionBrandCellIdentifier];
        
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
//   self.collectionView.frame = self.view.bounds;
    // 根据item大小设置sectionInset.top
   UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
   UIEdgeInsets contentInset = layout.sectionInset;
    contentInset.top = CGRectGetHeight(self.view.bounds) - layout.itemSize.height - layout.sectionInset.bottom;
   layout.sectionInset = contentInset;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configPaperView];
}

- (void)configPaperView
{
    self.reflectedImageView.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    // Gradient to top image
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.topImageView.bounds;
    gradient.colors = @[(id)ColorWithRGBA(0, 0, 0, 0.4).CGColor, (id)UIColorWhite.CGColor];
    [self.topImageView.layer insertSublayer:gradient atIndex:0];
    
    // Gradient to reflected image
    CAGradientLayer *gradientReflected = [CAGradientLayer layer];
    gradientReflected.frame = self.reflectedImageView.bounds;
    gradientReflected.colors = @[(id)ColorWithRGB(0, 0, 0).CGColor, (id)UIColorWhite.CGColor];
    [self.reflectedImageView.layer insertSublayer:gradientReflected atIndex:0];
    
    // Content perfect pixel
    UIView* perfectPixel = UIView.new;
    perfectPixel.backgroundColor = ColorWithRGBA(0, 0, 0, 0.2);
    [self.topImageView addSubview:perfectPixel];
    [perfectPixel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view);
        make.width.equalTo(self.view).priorityLow();
        make.height.equalTo(@1);
        
    }];
    
   // _myTimer = [NSTimer scheduledTimerWithTimeInterval:AD_SCROLL_RunloopTime target:self selector:@selector(changeTopImageView) userInfo:nil repeats:YES];

        _myTimer = [NSTimer timerWithTimeInterval:AD_SCROLL_RunloopTime target:self selector:@selector(changeTopImageView) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
}


//lx add  请求推荐位加载更多
- (void)getHomeRecommendListWithStart: (NSInteger)start
{
    MmiaHomeRecomRequestModel *model = [[MmiaHomeRecomRequestModel alloc]init];
    model.start = start;
    model.size = Request_Size;
    NSDictionary *infoDict = [model keyValues];
    
    [[MMiaNetworkEngine sharedInstance]startPostAsyncRequestWithUrl: MmiaHomeRecommendListURL param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic){
        
        if( ![responseDic[@"status"] intValue] )
        {
            MmiaHomePageModel* dataModel = [MmiaHomePageModel objectWithKeyValues:responseDic];
            
            self.everyNum = dataModel.recommendList.count;
            self.itemsArray = [self.itemsArray arrayByAddingObjectsFromArray:dataModel.recommendList];
        }else{
            //错误处理
        }
        
    }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
        
    }];
    
}


#pragma mark - Accessors

- (UIImageView *)topImageView
{
    if( !_topImageView )
    {
        _topImageView = UIImageView.new;
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
        _topImageView.clipsToBounds = YES;
        [self.view insertSubview:_topImageView belowSubview:self.navigationView];

        [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.reflectedImageView.mas_top);
        }];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topImageViewTapAction:)];
        [_topImageView addGestureRecognizer:tapGesture];
        _topImageView.userInteractionEnabled = YES;
    }
    return _topImageView;
}

- (UIImageView *)reflectedImageView
{
    if( !_reflectedImageView )
    {
        _reflectedImageView = UIImageView.new;
        _reflectedImageView.contentMode = UIViewContentModeScaleAspectFill;
        _reflectedImageView.clipsToBounds = YES;
        [self.view insertSubview:_reflectedImageView belowSubview:self.collectionView];
        
        [_reflectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            
            UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
            make.height.equalTo(@(layout.itemSize.height)).priorityLow();
        }];
    }
    return _reflectedImageView;
}

//lx add

- (UILabel *)sloganLabel
{
    if ( !_sloganLabel)
    {
        _sloganLabel = UILabel.new;
         _sloganLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _sloganLabel.backgroundColor = [UIColor clearColor];
        _sloganLabel.textColor = ColorWithHexRGB(0xffffff);
        _sloganLabel.font = UIFontSystem(15);
        [self.topImageView addSubview:_sloganLabel];
        
        [_sloganLabel mas_makeConstraints:^(MASConstraintMaker *make){
            
            make.top.equalTo(self.topImageView.mas_top).offset(VIEW_OFFSET + 44 +18);
            make.left.equalTo(self.topImageView.mas_left).offset(10);
            make.width.equalTo(@(self.view.width - 85 - 10));
            make.height.mas_equalTo(@15);
    
        }];
    }
    return _sloganLabel;
}

- (UILabel *)descriptionLabel
{
    if (!_descriptionLabel)
    {
        _descriptionLabel = UILabel.new;
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.textColor = ColorWithHexRGB(0xffffff);
        _descriptionLabel.font = UIFontSystem(10);
        _descriptionLabel.numberOfLines = 0;
        [self.topImageView addSubview:_descriptionLabel];
        
        [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make){
            
            make.top.equalTo(self.sloganLabel.mas_bottom).offset(5);
            make.left.right.equalTo(self.sloganLabel);
            make.height.mas_equalTo(50);
            
        }];
    }
    return _descriptionLabel;
}

- (MmiaDetailsCollectionViewController *)detailViewController
{
    if( !_detailViewController )
    {
        MmiaCollectionViewLargeLayout* largeLayout = [[MmiaCollectionViewLargeLayout alloc] init];
        _detailViewController = [[MmiaDetailsCollectionViewController alloc] initWithCollectionViewLayout:largeLayout];
//        _detailViewController.useLayoutToLayoutNavigationTransitions = YES;
    }
    return _detailViewController;
}

#pragma mark - setter方法

- (void)setTopDataArray:(NSArray *)topDataArray
{
    if( ![_topDataArray isEqualToArray:topDataArray] )
    {
        _topDataArray = topDataArray;
        
        // First Load
        [self changeTopImageView];
    }
}

- (void)setItemsArray:(NSArray *)itemsArray
{
    if( ![_itemsArray isEqualToArray:itemsArray] )
    {
        _itemsArray = itemsArray;
        
        [self.collectionView reloadData];
    }
}

#pragma mark - 响应事件

- (void)changeTopImageView
{
    if( self.topDataArray.count <= 0 )
        return;
    
    if( _slide >= self.topDataArray.count )
    {
        _slide = 0;
    }
    
    MmiaPaperRecommendModel *model = self.topDataArray[_slide];
    if( model )
    {
        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:model.pictureUrl]];
        [self.reflectedImageView sd_setImageWithURL:[NSURL URLWithString:model.pictureUrl]];
        
        self.sloganLabel.text = model.title;
        self.descriptionLabel.text = model.describe;
    }
    
//    [UIView transitionWithView:self.view
//                      duration:0.6f
//                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationCurveEaseInOut
//                    animations:^{
//                        self.topImageView.image = toImage;
//                        self.reflectedImageView.image = toImage;
//                        
//                    }
//                    completion:nil];
    
    _slide++;
}

- (void)topImageViewTapAction:(UITapGestureRecognizer *)tap
{
    NSLog( @"我点击了大图哟！" );
    
    if( self.TopViewTapActionBlock )
    {
        NSInteger index = tap.view.tag % self.topDataArray.count;
        self.TopViewTapActionBlock(index);
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.itemsArray.count == 0)
    {
        return 0;
    }
    
    return (self.everyNum >= Request_Size) ? (self.itemsArray.count + 1):self.itemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    
    if (indexPath.row == self.itemsArray.count  && self.everyNum >= Request_Size)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaLoadCellIdentifier forIndexPath:indexPath];
        [(MmiaLoadingCollectionCell *)cell startAnimation];
        
    }else {
        
        MmiaPaperProductListModel *model = [self.itemsArray objectAtIndex:indexPath.row];
        
        if (model.type == 0)
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaSingleGoodsCellIdentifier forIndexPath:indexPath];
            [(MmiaSingleGoodsCollectionCell *)cell reloadCellWithModel:model];
            
        }else if (model.type == 1)
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaDescriptionBrandCellIdentifier forIndexPath:indexPath];
            [(MmiaDescripBrandCollectionCell *)cell reloadCellWithModel:model];
        }
    }
    
    if (self.itemsArray.count - indexPath.row == 2 && self.everyNum >= 15)
    {
        [self getHomeRecommendListWithStart:self.itemsArray.count];
    }
    
      return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if( [self.delegate respondsToSelector:@selector(showViewController:didSelectInPaperView:)] )
    {

        [self.delegate showViewController:self.detailViewController didSelectInPaperView:self];
    }
    else
    {
        self.detailViewController.useLayoutToLayoutNavigationTransitions = YES;

       [self.navigationController pushViewController:self.detailViewController animated:YES];
    }
}

- (UIViewController *)nextViewControllerAtPoint:(CGPoint)point
{
    MmiaCollectionViewLargeLayout* largeLayout = [[MmiaCollectionViewLargeLayout alloc] init];
    MmiaDetailsCollectionViewController *detailViewController = [[MmiaDetailsCollectionViewController alloc] initWithCollectionViewLayout:largeLayout];
    detailViewController.useLayoutToLayoutNavigationTransitions = YES;
    
    return detailViewController;
}

- (void)dealloc
{
    [_myTimer invalidate];
    _myTimer = nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
