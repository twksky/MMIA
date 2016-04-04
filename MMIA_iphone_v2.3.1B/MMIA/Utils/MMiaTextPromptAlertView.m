//
//  MMiaTextPromptAlertView.m
//  MMIA
//
//  Created by MMIA-Mac on 14-9-12.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import "MMiaTextPromptAlertView.h"
#import "MMiaCommonUtil.h"

#define kAlertViewBorder       10
#define kTextBoxSpacing        15
#define kAlertButtonHeight     34
#define kAlertViewTitleFont    [UIFont systemFontOfSize:14]
#define kAlertViewMessageFont  [UIFont systemFontOfSize:14]
#define kAlertViewButtonFont   [UIFont systemFontOfSize:14]

#pragma mark - MMiaAlertView

@interface MMiaAlertView ()

@end

@implementation MMiaAlertView

static UIFont*  titleFont = nil;
static UIFont*  messageFont = nil;
static UIFont*  buttonFont = nil;

#pragma mark ** init

+ (void)initialize
{
    if( self == [MMiaAlertView class] )
    {
        titleFont = kAlertViewTitleFont;
        messageFont = kAlertViewTitleFont;
        buttonFont = kAlertViewButtonFont;
    }
}

+ (MMiaAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message
{
    return [[MMiaAlertView alloc] initWithTitle:title message:message];
}

#pragma mark ** NSObject

- (id)initWithTitle:(NSString *)title message:(NSString *)message
{
    if( (self = [super init]) )
    {
    self.frame = [[UIScreen mainScreen] bounds];
        
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        
        _backgroundImage = [UIImage imageNamed:@"alert-windowbg.png"];
        _blocks = [[NSMutableArray alloc] init];
        _height = kAlertViewBorder;
        
        CGRect frame = self.bounds;
        frame.origin.x = floorf((frame.size.width - _backgroundImage.size.width) * 0.5);
        frame.size.width = _backgroundImage.size.width;
        
        _alertView = [[UIView alloc] initWithFrame:frame];
        _alertView.backgroundColor = [UIColor clearColor];
        _alertView.layer.cornerRadius = 8.0;
        _alertView.layer.opacity = .95;
        _alertView.clipsToBounds = YES;
        [self addSubview:_alertView];
        
        if( title )
        {
            CGSize size = [title sizeWithFont:titleFont
                            constrainedToSize:CGSizeMake(CGRectGetWidth(frame) - kAlertViewBorder*2, 1000)
                                lineBreakMode:NSLineBreakByWordWrapping];
            
            UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewBorder, _height, CGRectGetWidth(frame) - kAlertViewBorder*2, size.height)];
            titleLabel.font = titleFont;
            titleLabel.numberOfLines = 0;
            titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.text = title;
            [_alertView addSubview:titleLabel];
            
            _height += size.height + kAlertViewBorder;
            
            UILabel* lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _height, CGRectGetWidth(frame), 1)];
            lineLabel.backgroundColor = [UIColor lightGrayColor];
            [_alertView addSubview:lineLabel];
            
            _height += 1 + kTextBoxSpacing;
        }
        
        if( message )
        {
            CGSize size = [message sizeWithFont:messageFont
                              constrainedToSize:CGSizeMake(CGRectGetWidth(frame) - kAlertViewBorder*2, 1000)
                                  lineBreakMode:NSLineBreakByWordWrapping];
            
            UILabel *mesLabel = [[UILabel alloc] initWithFrame:CGRectMake(kAlertViewBorder, _height, CGRectGetWidth(frame) - kAlertViewBorder*2, size.height)];
            mesLabel.font = messageFont;
            mesLabel.numberOfLines = 0;
            mesLabel.lineBreakMode = NSLineBreakByWordWrapping;
            mesLabel.textColor = [UIColor blackColor];
            mesLabel.backgroundColor = [UIColor clearColor];
            mesLabel.textAlignment = NSTextAlignmentCenter;
//            mesLabel.layer.borderWidth = 1.0;
//            mesLabel.layer.borderColor = [UIColor grayColor].CGColor;
//            mesLabel.layer.cornerRadius = 5;
//            mesLabel.shadowColor = [UIColor blackColor];
//            mesLabel.shadowOffset = CGSizeMake(0, -1);
            mesLabel.text = message;
            [_alertView addSubview:mesLabel];
            
            _height += size.height + kTextBoxSpacing;
        }
    }
    return self;
}

- (void)dealloc
{
    _blocks = nil;
}

#pragma mark ** Public

- (void)addButtonWithTitle:(NSString *)title color:(NSString*)color block:(ButtonPressCallBack)block
{
    [_blocks addObject:[NSArray arrayWithObjects:
                        block ? [block copy] : [NSNull null],
                        title,
                        color,
                        nil]];
}

- (void)addButtonWithTitle:(NSString *)title block:(ButtonPressCallBack)block
{
    [self addButtonWithTitle:title color:@"add" block:block];
}

- (void)setCancelButtonWithTitle:(NSString *)title block:(ButtonPressCallBack)block
{
    [self addButtonWithTitle:title color:@"cancel" block:block];
}

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(ButtonPressCallBack)block
{
    [self addButtonWithTitle:title color:@"red" block:block];
}

- (void)show
{
    BOOL isSecondButton = NO;
    NSUInteger index = 0;
    for (NSUInteger i = 0; i < _blocks.count; i++)
    {
        NSArray *block = [_blocks objectAtIndex:i];
        NSString *title = [block objectAtIndex:1];
        NSString *color = [block objectAtIndex:2];
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"alert-%@-button.png", color]];
        image = [image stretchableImageWithLeftCapWidth:(int)(image.size.width+1)>>1 topCapHeight:0];
        
        // 每个button的宽度
        CGFloat maxHalfWidth = floorf( CGRectGetWidth(self.alertView.bounds) * 0.5 );
        // 两个button的总宽度
        CGFloat width = CGRectGetWidth(self.alertView.bounds);
        CGFloat xOffset = 0;
        if( isSecondButton )
        {
            width = maxHalfWidth;
            xOffset += width;
            isSecondButton = NO;
        }
        else if (i + 1 < _blocks.count)
        {
            CGSize size = [title sizeWithFont:buttonFont
                                  minFontSize:10
                               actualFontSize:nil
                                     forWidth:CGRectGetWidth(self.alertView.bounds)
                                lineBreakMode:NSLineBreakByClipping];
            
            if( size.width < maxHalfWidth )
            {
                // It might fit. Check the next Button
                NSArray *block2 = [_blocks objectAtIndex:i+1];
                NSString *title2 = [block2 objectAtIndex:1];
                size = [title2 sizeWithFont:buttonFont
                                minFontSize:10
                             actualFontSize:nil
                                   forWidth:CGRectGetWidth(self.alertView.bounds)
                              lineBreakMode:NSLineBreakByClipping];
                
                if( size.width < maxHalfWidth )
                {
                    // They'll fit!
                    isSecondButton = YES;  // For the next iteration
                    width = maxHalfWidth;
                }
            }
        }
        else if (_blocks.count  == 1)
        {
            // In this case this is the ony button. We'll size according to the text
            CGSize size = [title sizeWithFont:buttonFont
                                  minFontSize:10
                               actualFontSize:nil
                                     forWidth:CGRectGetWidth(self.alertView.bounds)
                                lineBreakMode:NSLineBreakByClipping];
            
            size.width = MAX(size.width, 80);
            if (size.width < width)
            {
                width = size.width;
                xOffset = floorf((CGRectGetWidth(self.alertView.bounds) - width) * 0.5);
            }
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(xOffset, _height, width, kAlertButtonHeight);
        button.titleLabel.font = buttonFont;
        button.titleLabel.minimumScaleFactor = 10;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.shadowOffset = CGSizeMake(0, -1);
        button.backgroundColor = [UIColor clearColor];
        button.tag = i+1;
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.accessibilityLabel = title;
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.alertView addSubview:button];
        
        if( !isSecondButton )
            _height += kAlertButtonHeight;
        
        index++;
    }
    MyNSLog( @"buttonH = %f", _height );
    
    if( _height < self.backgroundImage.size.height )
    {
        CGFloat offset = self.backgroundImage.size.height - _height;
        _height = self.backgroundImage.size.height;
        CGRect frame;
        for (NSUInteger i = 0; i < _blocks.count; i++)
        {
            UIButton *btn = (UIButton *)[self.alertView viewWithTag:i+1];
            frame = btn.frame;
            frame.origin.y += offset;
            btn.frame = frame;
        }
    }
    
    CGRect frame = self.alertView.frame;
    frame.origin.y = floorf( (CGRectGetHeight(self.alertView.bounds) - _height) * 0.5 );
    frame.size.height = _height;
    self.alertView.frame = frame;
    
    UIImageView* modalBackground = [[UIImageView alloc] initWithFrame:self.alertView.bounds];
    modalBackground.image = self.backgroundImage;
    modalBackground.contentMode = UIViewContentModeScaleToFill;
    [self.alertView insertSubview:modalBackground atIndex:0];
    
    if( self.hidden )
    {
        self.hidden = NO;
        self.userInteractionEnabled = YES;
    }
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    if (buttonIndex >= 0 && buttonIndex < [_blocks count])
    {
        id obj = [[_blocks objectAtIndex: buttonIndex] objectAtIndex:0];
        if (![obj isEqual:[NSNull null]])
        {
            ((void (^)())obj)();
        }
    }
    
    [self.alertView removeFromSuperview];
}

#pragma mark ** Action

- (void)buttonClicked:(id)sender
{
    int buttonIndex = [sender tag] - 1;
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

@end

#pragma mark - MMiaTextPromptAlertView

#define kTextBoxHeight           53
#define kTextBoxHorizontalMargin 12
#define kKeyboardResizeBounce    20

@interface MMiaTextPromptAlertView ()
{
    NSCharacterSet *unacceptedInput;
    NSInteger maxLength;
}

@property(nonatomic, copy) TextViewReturnCallBack callBack;

@end

@implementation MMiaTextPromptAlertView

+ (MMiaTextPromptAlertView *)promptWithTitle:(NSString *)title
                                     message:(NSString *)message
                                 defaultText:(NSString*)defaultText
{
    return [self promptWithTitle:title message:message defaultText:defaultText block:nil];
}

+ (MMiaTextPromptAlertView *)promptWithTitle:(NSString *)title
                                     message:(NSString *)message
                                 defaultText:(NSString*)defaultText
                                       block:(TextViewReturnCallBack) block
{
    return [[MMiaTextPromptAlertView alloc] initWithTitle:title message:message defaultText:defaultText block:block];
}

+ (MMiaTextPromptAlertView *)promptWithTitle:(NSString *)title
                                     message:(NSString *)message
                                   textView:(out UITextView**)textView
{
    return [self promptWithTitle:title message:message textView:textView block:nil];
}


+ (MMiaTextPromptAlertView *)promptWithTitle:(NSString *)title
                                     message:(NSString *)message 
                                   textView:(out UITextView**)textView
                                       block:(TextViewReturnCallBack) block
{
    MMiaTextPromptAlertView *prompt = [[MMiaTextPromptAlertView alloc] initWithTitle:title message:message defaultText:nil block:block];
   
    *textView = prompt.textView;
    
    return prompt;
}

#pragma mark ** init

- (id)initWithTitle:(NSString *)title message:(NSString *)message defaultText:(NSString*)defaultText block:(TextViewReturnCallBack) block
{
    self = [super initWithTitle:title message:message];
    
    if (self)
    {
        UITextView *theTextView = [[UITextView alloc] initWithFrame:CGRectMake(kTextBoxHorizontalMargin, _height, CGRectGetWidth(self.alertView.bounds) - kTextBoxHorizontalMargin * 2, kTextBoxHeight)];
        
        [theTextView setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [theTextView setTextAlignment:NSTextAlignmentLeft];
        theTextView.font = [UIFont systemFontOfSize:14];
        theTextView.layer.borderColor = [UIColor grayColor].CGColor;
        theTextView.layer.borderWidth = 1;
        theTextView.layer.cornerRadius = 5;

        if (defaultText)
            theTextView.text = defaultText;
        
        if(block)
        {
            theTextView.delegate = self;
        }
        
        [self.alertView addSubview:theTextView];
        
        self.textView = theTextView;
        
        _height += kTextBoxHeight + kTextBoxSpacing;
        
        self.callBack = block;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(handleBackgroundTap:)];
        tapRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tapRecognizer];
    }
    
    return self;
}

- (void) handleBackgroundTap:(UITapGestureRecognizer*)sender
{
    [self.textView resignFirstResponder];
}

#pragma mark ** Public

- (void)show
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [super show];
    
    [self.textView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5];
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    
    if( self.callBack )
    {
        self.callBack(self);
    }
    
    NSArray *block = [_blocks objectAtIndex:buttonIndex];
    ButtonPressCallBack butBlock = [block objectAtIndex:0];
    if( butBlock )
    {
        butBlock();
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

#pragma mark ** KVO

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;  // UIKeyboardFrameBeginUserInfoKey

    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height-VIEW_OFFSET_FOR_TABBR;
    __block CGRect frame = self.alertView.frame;
    
    if (frame.origin.y + frame.size.height > screenHeight - keyboardSize.height)
    {
        frame.origin.y = screenHeight - keyboardSize.height - frame.size.height;
        
        if (frame.origin.y < 0)
            frame.origin.y = 0;
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.alertView.frame = frame;
                         }
                         completion:nil];
    }
}

- (void)setAllowableCharacters:(NSString*)accepted
{
    unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:accepted] invertedSet];
    self.textView.delegate = self;
}

- (void)setMaxLength:(NSInteger)max
{
    maxLength = max;
    self.textView.delegate = self;
}

#pragma mark ** UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>maxLength)
    {
         textView.text = [textView.text substringToIndex:maxLength];
    }
    if( [textView.text length] > 1000 )
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"名称为5-1000字哦！" delegate:nil cancelButtonTitle:@"确  定" otherButtonTitles:nil];
        [alert show];
        textView.text = [textView.text substringToIndex:1000];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    NSUInteger newLength = [self.textView.text length] + [text length] - range.length;
    
    if( maxLength > 0 && newLength > maxLength )
        return NO;
    
    if( !unacceptedInput )
        return YES;
    
    if( [[text componentsSeparatedByCharactersInSet:unacceptedInput] count] > 1 )
        return NO;
    else
        return YES;
}


- (void)dealloc
{
    self.callBack = nil;
}

@end
