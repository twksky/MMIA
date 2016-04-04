//
//  MMiaSetDataViewCell.m
//  MMIA
//
//  Created by lixiao on 14-6-19.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaSetDataViewCell.h"
#define CORNERS_SPACE  10

@implementation MMIASetDataCellContentView

- (id)init
{
    self = [super init];
    if (self) {
        
        self.addCorner  = YES;
        self.strokeColor = [UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1];
        self.fileColor = [UIColor whiteColor];
        self.rectCorner = UIRectCornerAllCorners;
        self.cornerSize = CGSizeMake(3, 3);
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.addCorner  = NO;
        self.strokeColor = [UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1];
        self.fileColor = [UIColor whiteColor];
        self.cornerSize = CGSizeMake(3, 3);
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.addCorner) {
        [self drawRectWithRectCorner:self.rectCorner andCornerRadii:self.cornerSize];
    }
}
- (void)drawRectWithRectCorner:(UIRectCorner)rectCorner andCornerRadii:(CGSize)size
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    //设置边界颜色
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
    //设置填充颜色
    CGContextSetFillColorWithColor(context, self.fileColor.CGColor);
    CGContextSetLineWidth(context, LINE_WIDTH);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:size];
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(1, 1, self.frame.size.width-2, self.frame.size.height-2) byRoundingCorners:rectCorner cornerRadii:size];
    
    [path stroke];
    [path1 fill];
}

@end
@implementation MMiaSetDataViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initview];
    }
    return self;
}
-(void)initview{
    self.contentView.backgroundColor=[UIColor clearColor];
    self.lineContentView=[[MMIASetDataCellContentView alloc]init];
    self.lineContentView.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:self.lineContentView];
    self.typeLabel=[[UILabel alloc]init];
     [self.typeLabel setFont:[UIFont systemFontOfSize:15]];
    
    [self.lineContentView addSubview:self.typeLabel];
    self.contentLabel=[[UILabel alloc]init];
    [self.lineContentView addSubview:self.contentLabel];
    self.accessoryImageView=[[UIImageView alloc]init];
    [self.lineContentView addSubview:self.accessoryImageView];
    
//    self.typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 30)];
//    [self.typeLabel setFont:[UIFont systemFontOfSize:15]];
//    [self.contentView addSubview:self.typeLabel];
//    
//    self.contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(85, 5, 190, 30)];
//    self.contentLabel.textAlignment=MMIATextAlignmentRight;
//    self.contentLabel.numberOfLines=0;
//    [self.contentLabel setFont:[UIFont systemFontOfSize:15]];
//    self.contentLabel.numberOfLines=0;
//    [self.contentView addSubview:self.contentLabel];
// 
    
}
- (void)setContentViewCornerTypeWith:(NSIndexPath *)indexPath  cellNumber:(NSUInteger)cellNumber
{
    self.lineContentView.cornerSize = CGSizeMake(3, 3);
    if (cellNumber == 1) {
        self.lineContentView.rectCorner = UIRectCornerAllCorners;
    }else{
        if (indexPath.row==0) {
            //第一行
            self.lineContentView.rectCorner = UIRectCornerTopLeft|UIRectCornerTopRight;
        }else if(indexPath.row +1 ==cellNumber){
            //最后一行
            self.lineContentView.rectCorner = UIRectCornerBottomLeft|UIRectCornerBottomRight;
        }else{
            self.lineContentView.rectCorner = UIRectCornerAllCorners;
            self.lineContentView.cornerSize = CGSizeMake(0, 0);
        }
    }
}

- (void)resetSubViewWithSize:(CGSize)size withCellIndexPath:(NSIndexPath *)indePath cellNumber:(NSInteger)cellNumber
{
    
    CGRect contentViewFrame = CGRectMake(0, 0, size.width, size.height);
contentViewFrame = CGRectMake(CORNERS_SPACE, 0, size.width-2*CORNERS_SPACE, size.height);
    [self setContentViewCornerTypeWith:indePath cellNumber:cellNumber];
    self.lineContentView.frame=contentViewFrame;
    [self.lineContentView setNeedsDisplay];
    self.typeLabel.frame=CGRectMake(10, (size.height-20)/2, 100, 20);
    
    UIImage *accessoryImage=self.accessoryImageView.image;
    if (accessoryImage)
    {
        self.accessoryImageView.frame=CGRectMake(CGRectGetWidth(self.lineContentView.frame)-10-accessoryImage.size.width, ((CGRectGetHeight(self.lineContentView.frame)-accessoryImage.size.height))/2, accessoryImage.size.width, accessoryImage.size.height);
    }

    self.contentLabel.frame=CGRectMake(CGRectGetMinX(self.accessoryImageView.frame)-140,(size.height-20)/2, 140, 20);
    self.contentLabel.font=[UIFont systemFontOfSize:15];
    self.contentLabel.textAlignment=MMIATextAlignmentRight;
    [self.contentLabel setFont:[UIFont systemFontOfSize:15]];
     self.contentLabel.numberOfLines=0;
   }

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
