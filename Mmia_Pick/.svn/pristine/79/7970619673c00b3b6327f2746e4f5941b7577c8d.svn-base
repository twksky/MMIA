//
//  MmiaMainViewController.m
//  MMIA
//
//  Created by MMIA-Mac on 15-5-15.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaMainViewController.h"
#import "GlobalNetwork.h"
#import "MmiaDataModel.h"
#import "MJExtension.h"
#import "AdditionHeader.h"

#import "MmiaCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "MmiaTransitionController.h"

#import "MmiaCollectionViewSmallLayout.h"
#import "MmiaPaperViewController.h"


@interface MmiaMainViewController () <MmiaPaperViewControllerDelegate, UINavigationControllerDelegate>
{
    MmiaDataModel *_model;
}
@property (nonatomic, retain) NSMutableArray *dataArr;


@property (nonatomic, strong) MmiaTransitionController* transitionController;

@end

@implementation MmiaMainViewController

#pragma mark - Accessors

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UINavigationControllerDelegate
    self.navigationController.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArr = [[NSMutableArray alloc]init];

//    [self requestWithStart:0];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 200, 200)];
    view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view];
    // 添加点击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
    [view addGestureRecognizer:tapGesture];
    view.userInteractionEnabled = YES;
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
    MmiaPaperViewController* paperViewController = [[MmiaPaperViewController alloc] initWithCollectionViewLayout:smallLayout];
    paperViewController.topDataArray = @[@"photo1.jpg", @"photo2.jpg", @"photo3.jpg"];
    
    [self.navigationController pushViewController:paperViewController animated:YES];
}

- (void)requestWithStart:(NSInteger)start
{
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1697],@"userid", [NSNumber numberWithInteger:start],@"start",[NSNumber numberWithInteger:20],@"size",@"b61549cd8b00c2efddac690e8b728686", @"ticket", nil];
    
    [[MMiaNetworkEngine sharedInstance]startPostAsyncRequestWithUrl:@"ados/love/getProductLike" param:infoDict completionHandler:^(AFHTTPRequestOperation *operation, NSDictionary* responseDic)
     {
         _model = [MmiaDataModel objectWithKeyValues:responseDic];
         NSArray *arr = [MMiaDetailModel objectArrayWithKeyValuesArray:_model.data];
         for (MMiaDetailModel *data in arr)
         {
             [self.dataArr addObject:data.imgUrl];
         }
//         [self.collectionView reloadData];
         
     }errorHandler:^(AFHTTPRequestOperation *operation, NSError* error){
         
     }];
}

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout])
    {
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ID"];
//        [self.collectionView registerClass:[UICollectionReusableView class]
//            forSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter"
//                   withReuseIdentifier:@"myFooter"];
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView* reusableView = nil;
//    if( [kind isEqualToString:@"UICollectionElementKindSectionFooter"] )
//    {
//        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"myFooter" forIndexPath:indexPath];
//        reusableView.backgroundColor = [UIColor brownColor];
//        
////        [reusableView addSubview:self.paperView];
//        [reusableView addSubview:self.paperViewController.view];
//        [self.paperViewController didMoveToParentViewController:self];
//    }
//    return reusableView;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MmiaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor cyanColor];
    cell.layer.cornerRadius = 4;
    cell.clipsToBounds = YES;
    UIImageView *backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Cell"]];
    cell.backgroundView = backgroundView;
//
//    cell.headImageView.backgroundColor = [UIColor whiteColor];
//    cell.titleLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
//    
//    if (indexPath.row == self.dataArr.count)
//    {
//        [cell.contentView addSubview:cell.acView];
//        [cell.acView startAnimating];
//        cell.headImageView.image = nil;
//        
//    }else
//    {
//        [cell.acView stopAnimating];
//        [cell.acView removeFromSuperview];
//        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[self.dataArr objectAtIndex:indexPath.row]]];
//    }
//    //提前处理,总共20条数据，15条开始处理
//    if (_model.num >= 20 && (indexPath.row % 20) == 15)
//    {
//        [self requestWithStart:self.dataArr.count];
//    }
    return cell;
}

#pragma mark - MmiaPaperViewControllerDelegate

- (void)showViewController:(UIViewController *)viewController didSelectInPaperView:(MmiaPaperViewController *)paperView
{
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if( animationController == self.transitionController)
    {
        return self.transitionController;
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (![fromVC isKindOfClass:[UICollectionViewController class]] || ![toVC isKindOfClass:[UICollectionViewController class]])
    {
        return nil;
    }
    if (!self.transitionController.hasActiveInteraction)
    {
        return nil;
    }
    
    self.transitionController.navigationOperation = operation;
    return self.transitionController;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 0;
    //增加一个
    
//    return (_model.num >= 20?self.dataArr.count + 1 : self.dataArr.count);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
