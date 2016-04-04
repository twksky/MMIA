//
//  MmiaTextViewUtil.m
//  MmiaHD
//
//  Created by twksky on 15/4/10.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaTextViewUtil.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS  4

@implementation MmiaTextViewUtil

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
        self.font=[UIFont systemFontOfSize:15];
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
    [self addPlaceholderView];
}

-(void)addPlaceholderView{
    
    self.backgroundColor=[UIColor whiteColor];
//    self.layer.masksToBounds=YES;
//    self.layer.cornerRadius=CORNER_RADIUS;
//    self.layer.borderWidth=2.0;
    self.layer.borderColor= [[UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1] CGColor];
    
    CGSize size=[self.placeholder sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    
    self.placeholderLabel=[[UILabel alloc]initWithFrame:CGRectMake(6, 5, self.frame.size.width, size.height)];
    
    self.placeholderLabel.font=self.font;
    self.placeholderLabel.text=self.placeholder;
    self.placeholderLabel.alpha=0.3;
    
    
    self.placeholderLabel.backgroundColor=[UIColor clearColor];
    self.placeholderLabel.numberOfLines=1;
    [self addSubview:self.placeholderLabel];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showPlaceholder) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showPlaceholder) name:UITextViewTextDidEndEditingNotification object:nil];
    
}

-(void)showPlaceholder{
    if (self.text.length==0) {
        self.placeholderLabel.alpha=0.3;
    }else{
        self.placeholderLabel.alpha=0;
    }
}



@end
