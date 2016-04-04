//
//  MMiaPageIndicatorView.m
//  MMIA
//
//  Created by MMIA-Mac on 14-8-12.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import "MMiaPageIndicatorView.h"

@implementation MMiaPageIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.opaque = NO;
        _color = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Public

- (void)setColor:(UIColor *)color
{
    if (![_color isEqual:color])
    {
        _color = color;
        [self setNeedsDisplay];
    }
}

#pragma mark - Private

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, rect);
    
    CGContextBeginPath(context);
    
    
    CGContextMoveToPoint(context, CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextClosePath(context);
    
   // CGContextAddRect(context, rect);
    
    //    // 指定一个点成为current point
    //    CGContextMoveToPoint   (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    //    // 创建一条直线，从current point到 (x,y)
    //    CGContextAddLineToPoint(context, CGRectGetMidX(rect), CGRectGetMaxY(rect));
    //    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    CGContextFillPath(context);
}

@end
