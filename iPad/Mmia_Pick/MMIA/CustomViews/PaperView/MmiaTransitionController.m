//
//  MmiaTransitionController.m
//  MMIA
//
//  Created by MMIA-Mac on 15-5-18.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaTransitionController.h"
#import "MmiaTransitionLayout.h"


@interface MmiaTransitionController ()

@property (nonatomic) MmiaTransitionLayout* transitionLayout;
@property (nonatomic) id <UIViewControllerContextTransitioning> context;
/////
@property (nonatomic, strong) UICollectionView *toCollectionView;

@end

@implementation MmiaTransitionController

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
{
    self = [super init];
    if (self != nil)
    {
        //        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        //        [collectionView addGestureRecognizer:pinchGesture];
        //
        //        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerGesture:)];
        //        panGestureRecognizer.delegate = self;
        //        panGestureRecognizer.minimumNumberOfTouches = 1;
        //        panGestureRecognizer.maximumNumberOfTouches = 1;
        //        [collectionView addGestureRecognizer:panGestureRecognizer];
        
        self.collectionView = collectionView;
        self.fromCollectionView = collectionView;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView* containerView = [transitionContext containerView];
    
    UIViewController *fromViewController = (UICollectionViewController*) [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    NSLog( @"trans.fVC = %@", fromViewController );
    UIView *fromView = [fromViewController view];
    
    UICollectionViewController *toViewController   = (UICollectionViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSLog( @"trans.tVC = %@", toViewController );
    UIView *toView = toViewController.view;
    
    self.toCollectionView = [toViewController collectionView];
    
    CGRect initialRect = [containerView convertRect:_fromCollectionView.frame fromView:_fromCollectionView.superview];
    CGRect finalRect   = [transitionContext finalFrameForViewController:toViewController];
    
    UICollectionViewFlowLayout *toLayout = (UICollectionViewFlowLayout*) _toCollectionView.collectionViewLayout;
    
    UICollectionViewFlowLayout *currentLayout = (UICollectionViewFlowLayout*) _fromCollectionView.collectionViewLayout;
    
    UICollectionViewFlowLayout *currentLayoutCopy = [[UICollectionViewFlowLayout alloc] init];
    currentLayoutCopy.itemSize = currentLayout.itemSize;
    currentLayoutCopy.sectionInset = currentLayout.sectionInset;
    currentLayoutCopy.minimumLineSpacing = currentLayout.minimumLineSpacing;
    currentLayoutCopy.minimumInteritemSpacing = currentLayout.minimumInteritemSpacing;
    currentLayoutCopy.scrollDirection = currentLayout.scrollDirection;
    
    [self.fromCollectionView setCollectionViewLayout:currentLayoutCopy animated:NO];
    
    UIEdgeInsets contentInset = _toCollectionView.contentInset;
    
    CGFloat oldBottomInset = contentInset.bottom;
    contentInset.bottom = CGRectGetHeight(finalRect)-(toLayout.itemSize.height+toLayout.sectionInset.bottom+toLayout.sectionInset.top);
    
    self.toCollectionView.contentInset = contentInset;
    [self.toCollectionView setCollectionViewLayout:currentLayout animated:NO];
    toView.frame = initialRect;
    [containerView insertSubview:toView aboveSubview:fromView];
    
    [UIView
     animateWithDuration:[self transitionDuration:transitionContext]
     delay:0
     options:UIViewAnimationOptionBeginFromCurrentState
     animations:^{
         toView.frame = finalRect;
         [_toCollectionView
          performBatchUpdates:^{
              [_toCollectionView setCollectionViewLayout:toLayout animated:NO];
          }
          completion:^(BOOL finished) {
              _toCollectionView.contentInset = UIEdgeInsetsMake(contentInset.top,
                                                                contentInset.left,
                                                                oldBottomInset,
                                                                contentInset.right);
          }];
         
     } completion:^(BOOL finished) {
         [transitionContext completeTransition:YES];
     }];
}

#pragma mark - UIViewControllerInteractiveTransitioning

- (void)startInteractiveTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    self.context = transitionContext;
    
    UICollectionViewController *fromCollectionViewController =
    (UICollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UICollectionViewController *toCollectionViewController =
    (UICollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:[toCollectionViewController view]];
    
//    self.transitionLayout = (MmiaTransitionLayout *)[fromCollectionViewController.collectionView startInteractiveTransitionToCollectionViewLayout:toCollectionViewController.collectionViewLayout completion:^(BOOL didFinish, BOOL didComplete) {
//        [self.context completeTransition:didComplete];
//        self.transitionLayout = nil;
//        self.context = nil;
//        self.hasActiveInteraction = NO;
//    }];
}

@end
