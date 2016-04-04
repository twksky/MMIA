//
//  MMiaTextPromptAlertView.h
//  MMIA
//
//  Created by MMIA-Mac on 14-9-12.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import <Foundation/Foundation.h>

// 可以输入文字TextView的自定义AlertView

typedef void(^ButtonPressCallBack)();

@interface MMiaAlertView : UIView//NSObject
{
    NSMutableArray* _blocks;
    CGFloat         _height;
}

@property (nonatomic, strong) UIView*   alertView;
@property (nonatomic, strong) UIImage*  backgroundImage;

+ (MMiaAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message;

- (id)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)addButtonWithTitle:(NSString *)title block:(ButtonPressCallBack)block;
- (void)setDestructiveButtonWithTitle:(NSString *)title block:(ButtonPressCallBack)block;
- (void)setCancelButtonWithTitle:(NSString *)title block:(ButtonPressCallBack)block;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@end


@class MMiaTextPromptAlertView;

typedef BOOL(^TextViewReturnCallBack)(MMiaTextPromptAlertView *);

@interface MMiaTextPromptAlertView : MMiaAlertView <UITextViewDelegate>

@property (nonatomic, retain) UITextView *textView;

+ (MMiaTextPromptAlertView *)promptWithTitle:(NSString *)title
                                     message:(NSString *)message
                                 defaultText:(NSString*)defaultText;

+ (MMiaTextPromptAlertView *)promptWithTitle:(NSString *)title
                                     message:(NSString *)message
                                 defaultText:(NSString*)defaultText
                                       block:(TextViewReturnCallBack)block;

+ (MMiaTextPromptAlertView *)promptWithTitle:(NSString *)title
                                     message:(NSString *)message
                                   textView:(out UITextView**)textView;

+ (MMiaTextPromptAlertView *)promptWithTitle:(NSString *)title
                                     message:(NSString *)message
                                   textView:(out UITextView**)textView
                                       block:(TextViewReturnCallBack)block;


- (id)initWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText block:(TextViewReturnCallBack) block;

- (void)setAllowableCharacters:(NSString*)accepted;
- (void)setMaxLength:(NSInteger)max;

@end
