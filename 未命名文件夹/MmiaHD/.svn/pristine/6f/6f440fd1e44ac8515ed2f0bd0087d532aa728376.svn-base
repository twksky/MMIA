//
//  MmiaVerSucessView.m
//  MmiaHD
//
//  Created by twksky on 15/3/24.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaVerSucessView.h"
#import "AdditionHeader.h"

@implementation MmiaVerSucessView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.vertifyLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width, 20)];
        self.vertifyLabel.textAlignment=MMIATextAlignmentCenter;
        self.vertifyLabel.center=CGPointMake(App_Frame_Width/2, 10);
        self.vertifyLabel.font=[UIFont systemFontOfSize:15];
        
        self.vertifyLabel.textColor = ColorWithHexRGB(0xffffff);
        self.vertifyLabel.backgroundColor=[UIColor clearColor];
        
        [self addSubview:self.vertifyLabel];
        self.vertifyToLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width, 20)];
        self.vertifyToLabel.center=CGPointMake(App_Frame_Width/2, 30);
        self.vertifyToLabel.textAlignment=MMIATextAlignmentCenter;
        self.vertifyToLabel.font=[UIFont systemFontOfSize:15];
        self.vertifyToLabel.textColor = ColorWithHexRGB(0xffffff);
        self.vertifyToLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:self.vertifyToLabel];
        
        
    }
    return self;
}

@end
