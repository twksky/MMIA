//
//  MmiaSearchWaterFallHeader.m
//  MmiaHD
//
//  Created by lixiao on 15/4/2.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaSearchWaterFallHeader.h"
#import "UtilityMacro.h"

@interface MmiaSearchWaterFallHeader (){
    UIImageView  *_bgImageView;
}
@property (nonatomic, retain) UILabel  *titleLabel;

@end


@implementation MmiaSearchWaterFallHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addContentToView];
    }
    return self;
}

- (void)addContentToView
{
    _bgImageView = [[UIImageView alloc]init];
    _bgImageView.clipsToBounds = YES;
    _bgImageView.frame = self.bounds;
    _bgImageView.image = [UIImage imageNamed:@"search_topBar.png"];
    [self addSubview:_bgImageView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 400, 40)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    CGPoint center = self.center;
    self.titleLabel.center = center;
    self.titleLabel.textColor = ColorWithHexRGB(0xffffff);
    self.titleLabel.font = UIFontSystem(30);
    self.titleLabel.textAlignment = MMIATextAlignmentCenter;
    [self addSubview:self.titleLabel];
}

- (void)setTitle:(NSString *)title
{
    if (_title != title)
    {
        _title = title;
        self.titleLabel.text = title;
    }
}


@end
