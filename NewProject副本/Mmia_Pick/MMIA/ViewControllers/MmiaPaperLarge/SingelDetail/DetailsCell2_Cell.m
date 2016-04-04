//
//  DetailsCell2_Cell.m
//  MMIA
//
//  Created by twksky on 15/5/15.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "DetailsCell2_Cell.h"
#import "DataController.h"

#define CellWidth [UIScreen mainScreen].bounds.size.width

@implementation DetailsCell2_Cell

- (void)awakeFromNib {
    // Initialization code
    
    DataController *data = [DataController sharedSingle];
    // Initialization code
    CGFloat H = 0;
    
    for (int i = 0 ; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:data.singelCellImageName]];
        imageView.frame = CGRectMake(10, 0 + H, CellWidth-20, 150 );
        NSLog(@"%@",NSStringFromCGRect(imageView.frame));
        [self addSubview:imageView];
        
        UILabel *imageDescription = [[UILabel alloc]init];
        imageDescription.font = [UIFont systemFontOfSize:10];
        imageDescription.textColor = ColorWithHexRGB(0x666666);
        imageDescription.text = data.singelCellImageDescriptionText;
        [imageDescription setNumberOfLines:0];
        CGSize imageDescriptionSize = CGSizeMake(CellWidth-20, MAXFLOAT);
        CGRect imageDescriptionRect = [imageDescription.text boundingRectWithSize:imageDescriptionSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:imageDescription.font} context:nil];
        imageDescription.frame = CGRectMake(10 , imageView.frame.origin.y+imageView.frame.size.height+10, CellWidth-20, imageDescriptionRect.size.height);
        [self addSubview:imageDescription];
        imageDescription.backgroundColor = [UIColor grayColor];
        
        H = H +imageView.frame.size.height + 10 +imageDescription.frame.size.height + 10;
    }

    
}

@end
