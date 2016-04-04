//
//  UIView+Subview.m
//

//  Copyright (c) 2014 wuzixun. All rights reserved.
//

#import "UIView+Subview.h"

@implementation UIView (Subview)

+ (UIView*)getSubViewInView:(UIView*)view withTag:(NSInteger)tag
{
    for (UIView *subview in view.subviews) {
        if(subview.tag == tag)
            return subview;
    }
    return nil;
}

- (void)removeAllSubviews
{
    for(UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
}

@end
