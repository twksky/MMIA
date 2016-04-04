//
//  MMiaCollectionViewWaterfallHeader.m
//  MMIA
//
//  Created by MMIA-Mac on 14-7-4.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import "MMiaCollectionViewWaterfallHeader.h"

@interface MMiaCollectionViewWaterfallHeader()
{
    UILabel* _titleLbl;
    UIImageView* _leftImageView;
    UIImageView* _rightImageView;
}

@end

@implementation MMiaCollectionViewWaterfallHeader

#pragma mark - Accessors

- (void)setTitleString:(NSString *)titleString
{
	if ( ![_titleString isEqualToString:titleString] )
    {
		_titleString = [titleString copy];
		_titleLbl.text = _titleString;
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor redColor];
        
        _leftImageView = [[UIImageView alloc] init];
        [self addSubview:_leftImageView];
        
        _titleLbl = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLbl.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		_titleLbl.backgroundColor = [UIColor clearColor];
		_titleLbl.textColor = [UIColor blackColor];
        _titleLbl.font = [UIFont systemFontOfSize:15];
		_titleLbl.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLbl];
        
        _rightImageView = [[UIImageView alloc] init];
        [self addSubview:_rightImageView];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)initializeHeaderWithLeftImage:(UIImage*)leftImage rightImage:(UIImage*)rightImage titleString:(NSString*)titleString
{
    if( leftImage )
    {
        _leftImageView.frame = CGRectMake(5, self.bounds.origin.y + (self.bounds.size.height - leftImage.size.height)/2, leftImage.size.width, leftImage.size.height);
        _titleLbl.frame = CGRectMake(_leftImageView.frame.size.width + 10, self.bounds.origin.y, 150, self.bounds.size.height);
        _leftImageView.image = leftImage;
    }
    if( rightImage )
    {
        _rightImageView.frame = CGRectMake(self.bounds.size.width - rightImage.size.width - 10, self.bounds.origin.y + (self.bounds.size.height - rightImage.size.height)/2, rightImage.size.width, rightImage.size.height);
        _rightImageView.image = rightImage;
    }
    _titleLbl.text = titleString;
}

- (void)selfTap:(id)sender
{
    if ( [_delegate respondsToSelector:@selector(MMiaCollectionViewWaterfallHeaderTap:)] )
        [_delegate MMiaCollectionViewWaterfallHeaderTap:self];
}

@end
