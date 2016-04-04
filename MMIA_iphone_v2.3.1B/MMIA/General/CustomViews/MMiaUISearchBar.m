//
//  MMiaUISearchBar.m

//
//  Created by WuZixun on 14-4-17.
//  Copyright (c) 2014年 WuZixun. All rights reserved.
//

#import "MMiaUISearchBar.h"
#import "../../Manager/MMiaSkinManager.h"

@implementation MMiaUISearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    NSArray *searchBarSubView=(IS_IOS_7)?[(UIView *)[self.subviews objectAtIndex:0] subviews]:self.subviews;
    for (UIView *subView in searchBarSubView) {
        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subView removeFromSuperview];
        }else if([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]){
            UITextField *textField = (UITextField *)subView;
            textField.layer.borderWidth = 0.5f;
            textField.layer.borderColor = [MMiaSkinManager sharedInstance].defaultBorderColor.CGColor;
            textField.layer.cornerRadius = 15.0f;
            CGRect rect = textField.frame;
            textField.frame = CGRectInset(rect, 0, -3.0f);
            textField.font = [UIFont systemFontOfSize:14.0f];
            textField.textAlignment = NSTextAlignmentLeft;
            
            textField.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchbar_icon_search"]];
        }
    }
}


@end
