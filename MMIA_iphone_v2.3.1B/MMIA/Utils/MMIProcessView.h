//
//  MMIProcessView.h
//  MMIA
//
//  Created by Free on 14-6-16.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMIProcessView : UIView{
    UIView *_bgView;
    NSInteger _height;
}
//- (id)initWithMessage:(NSString *)message;
-(id)initWithMessage:(NSString *)message top:(NSInteger)height;
- (void)showInRootView:(UIView *)rootView;
- (void)dismiss;

@end
