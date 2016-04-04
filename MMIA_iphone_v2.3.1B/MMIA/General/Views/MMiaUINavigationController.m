//
//  MMiaUINavigationController.m

//
//  Created by WuZixun on 14-4-16.
//  Copyright (c) 2014年 WuZixun. All rights reserved.
//

#import "MMiaUINavigationController.h"
#import "../../Manager/MMiaSkinManager.h"

@interface MMiaUINavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeGesture;
@end


@implementation MMiaUINavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak MMiaUINavigationController *weakSelf = self;
    self.delegate = weakSelf;
    
    if (IS_IOS_7) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
            self.interactivePopGestureRecognizer.delegate = weakSelf;
        }
    }else{
        self.swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureFired:)];
        [self.view addGestureRecognizer:self.swipeGesture];
    }
}

-(void)gestureFired:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight && self){
        [self popViewControllerAnimated:YES];
    }
}

// Hijack the push method to disable the gesture

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (IS_IOS_7) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
            self.interactivePopGestureRecognizer.enabled = NO;
    }else{
        self.swipeGesture.enabled = NO;
    }
    
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    // Enable the gesture again once the new controller is shown
    if (IS_IOS_7) {
        // disable interactivePopGestureRecognizer in the rootViewController of navigationController
        if ([[navigationController.viewControllers firstObject] isEqual:viewController]) {
            navigationController.interactivePopGestureRecognizer.enabled = NO;
        } else {
            // enable interactivePopGestureRecognizer
            navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }else {
        if ([[navigationController.viewControllers firstObject] isEqual:viewController]) {
            self.swipeGesture.enabled = NO;
        } else {
            // enable interactivePopGestureRecognizer
            self.swipeGesture.enabled = YES;
        }
    }}

@end
