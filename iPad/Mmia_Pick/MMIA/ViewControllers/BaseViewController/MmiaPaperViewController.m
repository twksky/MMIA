//
//  MmiaPaperViewController.m
//  MMIA
//
//  Created by MMIA-Mac on 15-5-19.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaPaperViewController.h"
#import "GlobalKey.h"
#import "UtilityMacro.h"
#import "View+MASAdditions.h"
#import "CollectionViewPaperCell1.h"
#import "CollectionViewPaperCell2.h"
#import "MmiaBrandDetailViewController.h"
#import "MmiaCollectionViewLargeLayout.h"


static CGFloat const AD_SCROLL_RunloopTime = 5.0;

@interface MmiaPaperViewController () <UINavigationControllerDelegate>
{
    NSTimer*  _myTimer;
    NSInteger _slide;
}

- (void)configPaperView;
- (UIViewController *)nextViewControllerAtPoint:(CGPoint)point;

@end

@implementation MmiaPaperViewController

#pragma mark - init

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if( self = [super initWithCollectionViewLayout:layout] )
    {
        UINib* nib1 = [UINib nibWithNibName:@"CollectionViewPaperCell1" bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:WaterfallCellIdentifier];
        UINib* nib2 = [UINib nibWithNibName:@"CollectionViewPaperCell2" bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib2 forCellWithReuseIdentifier:MmiaPaperCellIdentifier];
        
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.collectionView.frame = self.view.bounds;
    
    // 根据item大小设置sectionInset.top
    UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    UIEdgeInsets contentInset = layout.sectionInset;
    contentInset.top = CGRectGetHeight(self.view.bounds) - layout.itemSize.height;
    layout.sectionInset = contentInset;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
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
        make.width.equalTo(self.view);
        make.height.equalTo(@1);
        
    }];
    
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:AD_SCROLL_RunloopTime target:self selector:@selector(changeTopImageView) userInfo:nil repeats:YES];
}


#pragma mark - Accessors

- (UIImageView *)topImageView
{
    if( !_topImageView )
    {
        _topImageView = UIImageView.new;
        [self.view addSubview:_topImageView];
        
        [_topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.reflectedImageView.mas_top);
        }];
    }
    return _topImageView;
}

- (UIImageView *)reflectedImageView
{
    if( !_reflectedImageView )
    {
        _reflectedImageView = UIImageView.new;
        [self.view insertSubview:_reflectedImageView belowSubview:self.collectionView];
        
        [_reflectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            
            UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
            make.height.equalTo(@(layout.itemSize.height)).priorityLow();
        }];
    }
    return _reflectedImageView;
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
    if( _slide > self.topDataArray.count - 1 )
    {
        _slide = 0;
    }
    
    UIImage *toImage = UIImageNamed(self.topDataArray[_slide]);
    [UIView transitionWithView:self.view
                      duration:0.6f
                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationCurveEaseInOut
                    animations:^{
                        self.topImageView.image = toImage;
                        self.reflectedImageView.image = toImage;
                        
                    }
                    completion:nil];
    _slide++;
}

- (void)topImageViewTapAction:(UITapGestureRecognizer *)tap
{
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
    return 5;//self.itemsArray;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO:根据model的type类型展示cell类型
    CollectionViewPaperCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WaterfallCellIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationController.delegate = self;
    UIViewController* vc = [self nextViewControllerAtPoint:CGPointZero];
//    if( [self.delegate respondsToSelector:@selector(showViewController:didSelectInPaperView:)] )
//    {
//        [self.delegate showViewController:vc didSelectInPaperView:self];
//    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIViewController *)nextViewControllerAtPoint:(CGPoint)point
{
    MmiaCollectionViewLargeLayout* largeLayout = [[MmiaCollectionViewLargeLayout alloc] init];
    
    MmiaBrandDetailViewController* detailViewController = [[MmiaBrandDetailViewController alloc] initWithCollectionViewLayout:largeLayout];
    detailViewController.useLayoutToLayoutNavigationTransitions = YES;
    
    return detailViewController;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ( [viewController isKindOfClass:[MmiaBrandDetailViewController class]] )
    {
        MmiaBrandDetailViewController* detailVC = (MmiaBrandDetailViewController*)viewController;
        detailVC.collectionView.dataSource = detailVC;
        detailVC.collectionView.delegate = detailVC;
        [detailVC.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }
    else if ( viewController == self )
    {
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
    }
}

- (void)dealloc
{
    [_myTimer invalidate];
    _myTimer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
