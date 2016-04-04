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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:0xff/255.0 green:0xff/255.0 blue:0xff/255.0 alpha:1.0];
        
        //        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.bounds.origin.y + (self.bounds.size.height - 25)/2, 10, 25)];
        //        _leftImageView.backgroundColor = [UIColor colorWithRed:0xCE/255.0 green:0x21/255.0 blue:0x2A/255.0 alpha:1.0];
        //        [self addSubview:_leftImageView];
        
        _titleLbl = [[UILabel alloc] initWithFrame: CGRectMake(15, self.bounds.origin.y, 260, self.bounds.size.height)];
        _titleLbl.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textColor = [UIColor colorWithRed:0x8c/255.0 green:0x8c/255.0 blue:0x8c/255.0 alpha:1.0];
        _titleLbl.font = [UIFont systemFontOfSize:14];
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
        _leftImageView.frame = CGRectMake(10, self.bounds.origin.y + (self.bounds.size.height - leftImage.size.height)/2, leftImage.size.width, leftImage.size.height);
        _titleLbl.frame = CGRectMake(_leftImageView.frame.size.width + 20, self.bounds.origin.y, 150, self.bounds.size.height);
        _leftImageView.image = leftImage;
    }
    if( rightImage )
    {
        _rightImageView.frame = CGRectMake(self.bounds.size.width - rightImage.size.width - 10, self.bounds.origin.y + (self.bounds.size.height - rightImage.size.height)/2, rightImage.size.width, rightImage.size.height);
        _rightImageView.image = rightImage;
    }
    _titleLbl.text = titleString;
}

- (void)fillContent:(id)content indexPath:(NSIndexPath*)indexPath
{
    self.content = content;
    self.indexPath = indexPath;
}

- (void)selfTap:(id)sender
{
    if ( [_delegate respondsToSelector:@selector(MMiaCollectionViewWaterfallHeaderTap:)] )
        [_delegate MMiaCollectionViewWaterfallHeaderTap:self];
}

@end
