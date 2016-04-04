//
//  MmiaPaperViewController.m
//  MMIA
//
//  Created by MMIA-Mac on 15-5-19.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaPaperViewController.h"
#import "MmiaSingleGoodsCollectionCell.h"
#import "MmiaBrandCollectionCell.h"
#import "MmiaDescripBrandCollectionCell.h"

#import "CHTCollectionViewWaterfallLayout.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "MmiaProductDetailViewController.h"
#import "MmiaBrandViewController.h"
#import "UIImage+ImageEffects.h"


@interface MmiaPaperViewController () <UINavigationControllerDelegate>
{
    NSInteger _currentPage;
}

@property (strong, nonatomic) UIView *reflectedView;

- (void)configPaperView;

@end

@implementation MmiaPaperViewController

#pragma mark - init

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if( self = [super initWithCollectionViewLayout:layout] )
    {
        _topDataArray = [[NSMutableArray alloc] init];
        _itemsArray = [[NSMutableArray alloc] init];
        
        UINib* nib1 = [UINib nibWithNibName:@"MmiaBrandCollectionCell" bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:MmiaBrandCellIdentifier ];
        UINib* nib2 = [UINib nibWithNibName:@"MmiaSingleGoodsCollectionCell" bundle:[NSBundle mainBundle]];
        UINib *nib3 = [UINib nibWithNibName:@"MmiaDescripBrandCollectionCell" bundle:[NSBundle mainBundle]];
        
        [self.collectionView registerNib:nib2 forCellWithReuseIdentifier:MmiaSingleGoodsCellIdentifier];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:MmiaPaperLoadCellIdentifier];
        [self.collectionView registerNib:nib3 forCellWithReuseIdentifier:MmiaDescriptionBrandCellIdentifier];
        
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return  UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    self.collectionView.alwaysBounceHorizontal = YES;
    
    _detailVC = nil;
    [self.adboardView startTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.adboardView stopTimer];
    
    [self.loadingCell stopAnimation];
    self.loadingCell = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self configPaperView];
}

- (void)configPaperView
{
    _loadMore = NO;
    self.reflectedView.transform = CGAffineTransformMakeScale(1.0, -1.0);
    
    // Gradient to top image
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.topImageView.bounds;
    gradient.colors = @[(id)ColorWithRGBA(0, 0, 0, 0.4).CGColor, (id)UIColorWhite.CGColor];
    [self.topImageView.layer insertSublayer:gradient atIndex:0];
    
    // Gradient to reflected image
    CAGradientLayer *gradientReflected = [CAGradientLayer layer];
    gradientReflected.frame = self.reflectedView.bounds;
    gradientReflected.colors = @[(id)ColorWithRGB(0, 0, 0).CGColor, (id)UIColorWhite.CGColor];
    [self.reflectedView.layer insertSublayer:gradientReflected atIndex:0];
    
    // Content perfect pixel
    UIView* perfectPixel = UIView.new;
    perfectPixel.backgroundColor = ColorWithRGBA(0, 0, 0, 0.2);
    [self.topImageView addSubview:perfectPixel];
    [perfectPixel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(self.view);
        make.width.equalTo(self.view).priorityLow();
        make.height.equalTo(@1);
    }];
}

#pragma mark - Private

- (void)netWorkError:(NSError *)error
{
    // 列表页加载更多
    if( _loadMore )
    {
        _loadMore = NO;
        [self.loadingCell stopAnimation];
        [self.loadingCell hiddenReloadButton:NO];
        [self.loadingCell addReloadButtonWithTarget:self selector:@selector(reloadButtonClick:)];
    }
}

// TODO:记得重写
- (void)reloadButtonClick:(id)sender
{
    [self.loadingCell hiddenReloadButton:YES];
    [self.loadingCell startAnimation];
    
    _loadMore = YES;
    // TODO:每个页面的请求不同
//    [self getHomeRecommendListWithStart:self.itemsArray.count];
}

#pragma mark - Accessors

- (MmiaAdboardView *)adboardView
{
    if( !_adboardView )
    {
        UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        
        _adboardView = [[MmiaAdboardView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, layout.sectionInset.top)];
        _adboardView.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        _adboardView.hiddenPageControl = YES;
        
        [self.view insertSubview:_adboardView belowSubview:self.navigationView];
    }
    return _adboardView;
}

- (MmiaLoadingCollectionCell *)loadingCell
{
    if( !_loadingCell )
    {
        _loadingCell = [[MmiaLoadingCollectionCell alloc] initWithFrame:CGRectMake(0, 0, 143, 254)];
    }
    return _loadingCell;
}

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
            
            UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
            make.height.equalTo(@(layout.sectionInset.top));
        }];
    }
    return _topImageView;
}

- (UIView *)reflectedView
{
    if( !_reflectedView )
    {
        _reflectedView = UIView.new;
        [self.view insertSubview:_reflectedView belowSubview:self.collectionView];
        
        [_reflectedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topImageView.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.equalTo(self.topImageView.mas_height);
        }];
    }
    return _reflectedView;
}

- (UILabel *)sloganLabel
{
    UILabel* _sloganLabel = UILabel.new;
    _sloganLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _sloganLabel.backgroundColor = [UIColor clearColor];
    _sloganLabel.textColor = ColorWithHexRGB(0xffffff);
    _sloganLabel.font = UIFontSystem(15);
    [_sloganLabel setShadowOffset:CGSizeMake(0.0f, 0.5f)];
    _sloganLabel.shadowColor = ColorWithHexRGBA(0x000001, 0.65);
    
    return _sloganLabel;
}

- (UILabel *)descriptionLabel
{
    UILabel* _descriptionLabel = UILabel.new;
    _descriptionLabel.backgroundColor = [UIColor clearColor];
    _descriptionLabel.textColor = ColorWithHexRGB(0xffffff);
    _descriptionLabel.font = UIFontSystem(12);
    [_descriptionLabel setShadowOffset:CGSizeMake(0.0f, 0.5f)];
    _descriptionLabel.shadowColor = ColorWithHexRGBA(0x000001, 0.65);
    _descriptionLabel.numberOfLines = 0;
    
    return _descriptionLabel;
}

- (void)loadTopImageViewsWithArray:(NSMutableArray *)bannerArray
{
    for( MmiaPaperRecommendModel* model in self.topDataArray )
    {
        // Source Picture
        UIImageView* imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:NSURLWithString(model.pictureUrl) placeholderImage:nil];
        // add picture text
        UILabel* sloganLabel = [self sloganLabel];
        UILabel* descriptionLabel = [self descriptionLabel];
        sloganLabel.text = model.title;
        descriptionLabel.text = model.describe;
        [imageView addSubview:sloganLabel];
        [imageView addSubview:descriptionLabel];
        
        [sloganLabel mas_makeConstraints:^(MASConstraintMaker *make)
         {
             make.top.equalTo(imageView.mas_top).offset(VIEW_OFFSET + 44 +18);
             make.left.equalTo(imageView.mas_left).offset(10);
             make.width.equalTo(@(self.view.width - 85 - 10));
             make.height.mas_equalTo(@15);
         }];
        
        [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(sloganLabel.mas_bottom).offset(5);
            make.left.right.equalTo(sloganLabel);
            make.height.mas_equalTo(50);
        }];
        
        [bannerArray addObject:imageView];
    }
}

- (void)loadBlurryImageViewsWithArray:(NSMutableArray *)blurryArray
{
    for( MmiaPaperRecommendModel* model in self.topDataArray )
    {
        // 模糊处理
        UIImageView* blurryImageView = UIImageView.new;
        blurryImageView.contentMode = UIViewContentModeScaleAspectFill;
        blurryImageView.clipsToBounds = YES;
        [blurryImageView sd_setImageWithURL:NSURLWithString(model.pictureUrl) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            
            if (image)
            {
                image = [image applyTintEffectWithColor:nil];
                blurryImageView.image = image;
            }
        }];
        [blurryArray addObject:blurryImageView];
    }
}

#pragma mark - setter方法

- (void)setTopDataArray:(NSArray *)topDataArray
{
    if( ![_topDataArray isEqualToArray:topDataArray] && topDataArray )
    {
        _topDataArray = topDataArray;
        
        NSMutableArray* blurryArray = [@[] mutableCopy];
        NSMutableArray* bannerArray = [@[] mutableCopy];
        [self loadTopImageViewsWithArray:bannerArray];
        [self loadBlurryImageViewsWithArray:blurryArray];
        
        WeakSelf(weakSelf);
        self.adboardView.reflectedViewAtIndex = ^(NSInteger pageIndex){
            
            UIView* view = blurryArray[pageIndex];
            [weakSelf.reflectedView removeAllSubviews];
            [weakSelf.reflectedView insertSubview:view belowSubview:weakSelf.collectionView];
            
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.right.equalTo(weakSelf.reflectedView);
            }];
        };
        self.adboardView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
            
            return bannerArray[pageIndex];
        };
        
        self.adboardView.totalPageCount = bannerArray.count;
        self.adboardView.TapActionBlock = ^(NSInteger pageIndex){
            
            MmiaPaperRecommendModel* item = weakSelf.topDataArray[pageIndex];
            [weakSelf pushViewControllerWithSourceId:item.sourceId type:item.type];
        };
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

- (void)pushViewControllerWithSourceId:(NSInteger)sourceId type:(NSInteger)type
{
    // 根据type类型选择跳转的页面
    if( type == 0 )
    {
        // 进入单品详情页
        CHTCollectionViewWaterfallLayout* detailLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
        MmiaProductDetailViewController* detailViewController = [[MmiaProductDetailViewController alloc] initWithCollectionViewLayout:detailLayout];
        detailViewController.spId = sourceId;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if( type == 1 )
    {
        // 进入品牌列表页
        MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
        MmiaBrandViewController* brandViewController = [[MmiaBrandViewController alloc] initWithCollectionViewLayout:smallLayout];
        brandViewController.brandId = sourceId;;
        [self.navigationController pushViewController:brandViewController animated:YES];
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
    
    if(indexPath.row == self.itemsArray.count)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaPaperLoadCellIdentifier forIndexPath:indexPath];
        [cell.contentView addSubview:self.loadingCell];
        self.loadingCell.frame = CGRectMake(0, 0, cell.contentView.width, cell.contentView.height);
        [self reloadButtonClick:nil];
    }
    else
    {
        MmiaPaperProductListModel *model = [self.itemsArray objectAtIndex:indexPath.row];
        
        if (model.type == 0)
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaSingleGoodsCellIdentifier forIndexPath:indexPath];
            [(MmiaSingleGoodsCollectionCell *)cell reloadCellWithModel:model];
            
        }
        else if (model.type == 1)
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaDescriptionBrandCellIdentifier forIndexPath:indexPath];
            [(MmiaDescripBrandCollectionCell *)cell reloadCellWithModel:model];
        }
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MmiaCollectionViewLargeLayout* largeLayout = [[MmiaCollectionViewLargeLayout alloc] init];
    MmiaPaperDetailsViewController *detailVC = [[MmiaPaperDetailsViewController alloc]initWithCollectionViewLayout:largeLayout];
    detailVC.everyNum = self.everyNum;
    detailVC.dataArray = self.itemsArray;
    _detailVC = detailVC;
    
    //加载更多数据
    WeakSelf(weakSelf);
    detailVC.PaperDetailLoadMoreDataBlock = ^(UICollectionViewCell* cell)
    {
        [cell addSubview:weakSelf.loadingCell];
        weakSelf.loadingCell.frame = CGRectMake(0, 0, cell.contentView.width, cell.contentView.height);
        [weakSelf reloadButtonClick:nil];
    };
    
    if( [self.delegate respondsToSelector:@selector(showViewController:didSelectInPaperView:)] )
    {
        detailVC.selectIndexPath = indexPath;
        
        //返回首页到相应地位置
        detailVC.popToMainVCBlock = ^(NSIndexPath *indexPath){
            
            [weakSelf.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        };
        
        [self.delegate showViewController:detailVC didSelectInPaperView:self];
    }
    else
    {
       detailVC.useLayoutToLayoutNavigationTransitions = YES;
       [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)dealloc
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
