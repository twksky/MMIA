//
//  UIViewController+StackViewController.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-4.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "UIViewController+StackViewController.h"
#import "StackBaseViewController.h"
#import "UIView+Additions.h"

@implementation UIViewController (StackViewController)

@dynamic leftStackViewController;
@dynamic rightStackViewController;

- (void)setLeftStackViewController:(StackBaseViewController *)leftStackViewController
{
    [self setStackViewController:leftStackViewController withDirection:StackViewControllerDirectionLeft];
}

- (void)setRightStackViewController:(StackBaseViewController *)rightStackViewController
{
    [self setStackViewController:rightStackViewController withDirection:StackViewControllerDirectionRight];
}

- (void)setStackViewController:(StackBaseViewController *)stackViewController withDirection:(StackViewControllerDirection)direction
{
    stackViewController.direction = direction;

    switch( direction )
    {
        case StackViewControllerDirectionRight:
            stackViewController.view.left += self.view.width;
            break;
            
        case StackViewControllerDirectionLeft:
            stackViewController.view.left -= self.view.width;
            break;
            
        default:
            break;
    }
    
    [self.view addSubview:stackViewController.view];
    [self addChildViewController:stackViewController];
    [stackViewController willMoveToParentViewController:self];
}

@end
