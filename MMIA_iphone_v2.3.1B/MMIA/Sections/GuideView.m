//
//  GuideView.m
//  MMIA
//
//  Created by lixiao on 14-8-20.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "GuideView.h"

@implementation GuideView{
    SwipeView *_swipeView;
    NSMutableArray *_dataArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];

   [defaults setBool:YES forKey:USER_FIRST_TIME_LOGIN];

        _swipeView=[[SwipeView alloc]init];
        _swipeView.frame=self.bounds;
        _swipeView.delegate=self;
        _swipeView.dataSource=self;
        _swipeView.pagingEnabled=YES;
        _swipeView.bounces=NO;
               _dataArray=[[NSMutableArray alloc]init];
        if (Main_Screen_Height>=568) {
             _dataArray=[NSMutableArray arrayWithObjects:@"guide_1_568h.png",@"guide_2_568h.png",@"guide_3_568h.png" ,nil];
        }else if (Main_Screen_Height>=460)
        {
            _dataArray=[NSMutableArray arrayWithObjects:@"guide_1_480h.png",@"guide_2_480h.png",@"guide_3_480h.png", nil];
        }
        [self addSubview:_swipeView];
        
    }
    return self;
}
#pragma mark --SwipeViewDataSource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return _dataArray.count;
}
- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
  
    UIImageView *imageView=nil;
    UIButton* button = nil;
    
        if (view==nil) {
        view=[[UIView alloc]initWithFrame:_swipeView.frame];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView=[[UIImageView alloc]initWithFrame:view.bounds];
        imageView.tag=1;
            imageView.userInteractionEnabled=YES;
        [view addSubview:imageView];
         button=[[UIButton alloc]initWithFrame:CGRectMake((320-100)/2, imageView.frame.size.height-70, 100, 30)];
            button.tag=2;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"立即体验" forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0xCE212A) forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0xCE212A) forState:UIControlStateHighlighted];
            
            button.clipsToBounds=YES;
            button.layer.cornerRadius=5.0;
            [button.layer setBorderWidth:1];
            button.layer.borderColor=[UIColorFromRGB(0xCE212A) CGColor];
        [imageView addSubview:button];
            
    }else{
        imageView=(UIImageView *)[view viewWithTag:1];
        button=(UIButton *)[view viewWithTag:2];
    }

    if (index==2) {
       //button.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"guide_register.png"]];
       
        button.hidden=NO;
       
       
    }else{
        button.hidden=YES;
        
    }
  
    imageView.image=[UIImage imageNamed:[_dataArray objectAtIndex:index]];
    return view;
}
-(CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return _swipeView.bounds.size;
}
- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView
{
    
    int x=(int)lroundf(swipeView.scrollOffset);
    swipeView.scrollOffset=x;
}
- (void)swipeViewDidScroll:(SwipeView *)swipeView
{
    if (swipeView.scrollOffset<=0) {
        swipeView.scrollOffset=0;
    }
    if (swipeView.scrollOffset>=2) {
        swipeView.scrollOffset=2;
    }
    
   // NSLog(@"swipeView.scrollOffset=%f %d",swipeView.scrollOffset,x);
}

-(void)buttonClick:(UIButton *)button
{
    [UIView animateWithDuration:0.2 animations:^{
        _swipeView.alpha=0;
    }completion:^(BOOL finished){
        [_swipeView removeFromSuperview];
        [self removeFromSuperview];
    }];
   
    [_swipeView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)buttonDownClick:(UIButton *)button
{
    [button setTitle:@"立即体验" forState:UIControlStateHighlighted];
     [button setTitle:@"立即体验" forState:UIControlStateSelected];
    button.titleLabel.textColor=UIColorFromRGB(0xCE212A);
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
