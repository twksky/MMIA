//
//  UIView+AutoResize.h

//

//  Copyright (c) 2014 wuzixun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoResize)
- (void)fixLeftEdge:(BOOL)fixed;
- (void)fixRightEdge:(BOOL)fixed;
- (void)fixTopEdge:(BOOL)fixed;
- (void)fixBottomEdge:(BOOL)fixed;
- (void)fixWidth:(BOOL)fixed;
- (void)fixHeight:(BOOL)fixed;
@end
