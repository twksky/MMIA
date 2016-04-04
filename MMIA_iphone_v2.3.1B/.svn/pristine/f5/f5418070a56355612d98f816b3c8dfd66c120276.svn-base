//
//  MMiaNoDataView.m
//  MMIA
//
//  Created by lixiao on 14-10-10.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaNoDataView.h"

@implementation MMiaNoDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithImageName:(NSString *)imageName TitleLabel:(NSString *)labelStr height:(int)height
{
    self=[super init];
    if (self)
    {
        UIImage *image=[UIImage imageNamed:imageName];
        UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
        imageView.center=CGPointMake(App_Frame_Width/2, height+image.size.height/2);
        [self addSubview:imageView];
        UILabel *label=[[UILabel alloc]init];
        label.backgroundColor=[UIColor clearColor];
        label.text=labelStr;
        label.textColor=[UIColor lightGrayColor];
        label.font=[UIFont systemFontOfSize:14];
        CGFloat width=[label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:NSLineBreakByCharWrapping].width;
        label.bounds=CGRectMake(0, 0, width+5,20);
        label.center=CGPointMake(App_Frame_Width/2, CGRectGetMaxY(imageView.frame)+5+10);
        [self addSubview:label];
      
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
