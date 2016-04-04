//
//  UILabel+Additions.m
//  MMIA
//
//  Created by lixiao on 15/6/19.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "UILabel+Additions.h"

@implementation UILabel (Additions)

- (void)setLineSpace:(CGFloat)space Text:(NSString *)text
{
    NSMutableAttributedString *attributedString0 = [[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle *paragraphStyle0 = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle0 setLineSpacing:space];
    [attributedString0 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle0 range:NSMakeRange(0,text.length)];
    self.attributedText = attributedString0;
}

@end
