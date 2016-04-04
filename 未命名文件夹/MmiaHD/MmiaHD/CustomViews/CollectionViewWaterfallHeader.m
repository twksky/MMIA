//
//  CollectionViewWaterfallHeader.m
//  MmiaHD
//
//  Created by MMIA-Mac on 15-2-3.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "CollectionViewWaterfallHeader.h"
#import "UtilityMacro.h"
#import "UIView+Additions.h"

const NSInteger WaterfallHeader_Margin = 20;
const NSInteger ContentView_Margin = 10;

@interface CollectionViewWaterfallHeader ()

@property (nonatomic, strong) UIImageView* leftImageView;
@property (nonatomic, strong) UIImageView* rightImageView;
@property (nonatomic, strong) UILabel*     textLabel;

@end

@implementation CollectionViewWaterfallHeader

- (UIImageView *)leftImageView
{
    if( !_leftImageView )
    {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.originX, (self.height - 18)/2, 5, 18)];
        _leftImageView.backgroundColor = [UIColor redColor];
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView
{
    if( !_rightImageView )
    {
        UIImage* image = UIImageNamed(@"");
        _rightImageView = UIImageViewImage(image);
        _rightImageView.frame = CGRectMake(self.width - image.size.height - self.originX, (self.height - image.size.height)/2, image.size.width, image.size.height);
    }
    return _rightImageView;
}

- (UILabel *)textLabel
{
    if( !_textLabel )
    {
        _textLabel = [[UILabel alloc] initWithFrame: CGRectMake(self.leftImageView.right + ContentView_Margin, 0, self.width, self.height)];
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _textLabel.backgroundColor = UIColorClear;
        _textLabel.textColor = ColorWithHexRGB(0x404040);
        _textLabel.font = UIFontSystem(18);
        _textLabel.textAlignment = MMIATextAlignmentLeft;
    }
    return _textLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = UIColorClear;
        
        _originX = WaterfallHeader_Margin;

        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
        [self addGestureRecognizer:tap];
        
        [self addSubview:self.leftImageView];
        [self addSubview:self.textLabel];
        [self addSubview:self.rightImageView];
    }
    return self;
}

- (void)setOriginX:(CGFloat)originX
{
    if( _originX != originX )
    {
        _originX = originX;
        
        self.leftImageView.left = originX;
        self.textLabel.left = self.leftImageView.right + ContentView_Margin;
    }
}

- (void)fillWithContent:(NSString *)contentLabel indexPath:(NSIndexPath*)indexPath originX:(CGFloat)originX
{
    self.textLabel.text = contentLabel;
    self.indexPath = indexPath;
    self.originX = originX;
}

- (void)selfTap:(id)sender
{
    if ( [_delegate respondsToSelector:@selector(CollectionViewWaterfallHeaderTap:)] )
        [_delegate CollectionViewWaterfallHeaderTap:self];
}

@end
