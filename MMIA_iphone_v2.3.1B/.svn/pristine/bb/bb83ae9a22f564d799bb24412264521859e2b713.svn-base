 //
//  MMIAGroupTableViewCell.m
//  MMIA
//
//  Created by Vivian's Office MAC on 14-6-1.
//  Copyright (c) 2014年 Vivian's Office MAC. All rights reserved.
//

#import "MMIAGroupTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define CORNERS_SPACE  10

@implementation MMIAGroupTableViewCellContentView

@synthesize addCorner = _addCorner,cornerSize = _cornerSize,rectCorner = _rectCorner,strokeColor = _strokeColor,fileColor = _fileColor;

- (id)init
{
    self = [super init];
    if (self) {
        
        self.addCorner  = NO;
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

@implementation MMIAGroupTableViewCell
@synthesize MGTVCContentView = _MGTVCContentView,MGTVCImageView= _MGTVCImageView,MGTVCTitleLabel = _MGTVCTitleLabel,MGTVCDetialLabel =_MGTVCDetialLabel,MGTVCAccessoryView = _MGTVCAccessoryView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.MGTVCContentView = [[MMIAGroupTableViewCellContentView alloc]init];
        self.MGTVCContentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.MGTVCContentView];
        self.MGTVCImageView = [[UIImageView alloc]init];
        [self.MGTVCContentView addSubview:self.MGTVCImageView];
        self.MGTVCTitleLabel = [[UILabel alloc]init];
        [self.MGTVCContentView addSubview:self.MGTVCTitleLabel];
        if (UITableViewCellStyleSubtitle  ==  style) {
            self.MGTVCDetialLabel = [[UILabel alloc]init];
            [self.MGTVCContentView addSubview:self.MGTVCDetialLabel];
        }
        self.MGTVCAccessoryView = [[UIImageView alloc]init];
        [self.MGTVCContentView addSubview:self.MGTVCAccessoryView];
    }
    return self;
}
- (void)setContentViewCornerTypeWith:(NSIndexPath *)indexPath  cellNumber:(NSUInteger)cellNumber
{
    self.MGTVCContentView.cornerSize = CGSizeMake(3, 3);
    if (cellNumber == 1) {
        self.MGTVCContentView.rectCorner = UIRectCornerAllCorners;
    }else{
        if (indexPath.row==0) {
            //第一行
            self.MGTVCContentView.rectCorner = UIRectCornerTopLeft|UIRectCornerTopRight;
        }else if(indexPath.row +1 ==cellNumber){
            //最后一行
            self.MGTVCContentView.rectCorner = UIRectCornerBottomLeft|UIRectCornerBottomRight;
        }else{
            self.MGTVCContentView.rectCorner = UIRectCornerAllCorners;
            self.MGTVCContentView.cornerSize = CGSizeMake(0, 0);
        }
    }
}
- (CGSize)transformSizeWithSize:(CGSize)size forImageSize:(CGSize )imageSize
{
    CGFloat widthRate = imageSize.width/size.width;
    CGFloat heightRate = imageSize.height/size.height;
    if (widthRate<=1&&heightRate<=1) {
        return CGSizeMake(imageSize.width , imageSize.height);
    }else{
        if (widthRate>1&&heightRate>1) {
            if (widthRate>heightRate)
                return CGSizeMake(size.width, imageSize.height*size.width/imageSize.width);
            else
                return CGSizeMake(imageSize.width*size.height/imageSize.height,size.height);
            
        }else{
            if (widthRate>1)
                return CGSizeMake(size.width, size.width*imageSize.height/imageSize.width);
            else
                return CGSizeMake(size.height*imageSize.width/imageSize.height, size.height);
            
        }
    }
}
- (void)resetImageViewWithSize:(CGSize)size
{
    if (self.MGTVCImageView.image) {
        CGSize newSize = [self transformSizeWithSize:CGSizeMake(size.height-10, size.height-10) forImageSize:self.MGTVCImageView.image.size];
        self.MGTVCImageView.frame = CGRectMake(10, (size.height - newSize.height)/2.0f, newSize.width, newSize.height);
        self.MGTVCTitleLabel.frame = CGRectMake(self.MGTVCImageView.frame.size.width+self.MGTVCImageView.frame.origin.x+10, 0, size.width-(self.MGTVCImageView.frame.size.width+self.imageView.frame.origin.x+10), size.height);
    }
}
- (CGFloat)contentLengthWith:(NSString *)text label:(UILabel *)label
{
    CGFloat length = 0.0f;
    UITextView *textView = [[UITextView alloc]init];
    textView.text = text;
    textView.font = label.font;
   length =  [textView sizeThatFits:CGSizeMake(1000, label.frame.size.height)].width;
    return length;
}
- (void)resetTitleLabelWithSize:(CGSize)size
{
    if (self.MGTVCTitleLabel.text!=nil) {
//        CGFloat width = [self contentLengthWith:self.MGTVCTitleLabel.text label:self.MGTVCTitleLabel];
        self.MGTVCTitleLabel.backgroundColor=[UIColor clearColor];
        self.MGTVCTitleLabel.frame = CGRectMake(self.MGTVCImageView.frame.size.width+self.MGTVCImageView.frame.origin.x+10, 5, size.width-(self.MGTVCImageView.frame.size.width+self.imageView.frame.origin.x+10), size.height-10);
    }
}
- (void)resetDetialLabelWithSize:(CGSize)size
{
    
}
- (void)resetAccessoryViewWithSize:(CGSize)size
{
    if (self.MGTVCAccessoryView.image) {
        CGSize newSize = [self transformSizeWithSize:CGSizeMake(size.height-10, size.height-10) forImageSize:self.MGTVCAccessoryView.image.size];
        self.MGTVCAccessoryView.frame = CGRectMake(size.width-10-newSize.width, (size.height - newSize.height)/2.0f, newSize.width, newSize.height);
    }
}
- (void)resetSubViewWithSize:(CGSize)size withCellIndexPath:(NSIndexPath *)indePath cellNumber:(NSInteger)cellNumber
{
    CGRect contentViewFrame = CGRectMake(0, 0, size.width, size.height);
    if (self.setGroup) {
        contentViewFrame = CGRectMake(CORNERS_SPACE, 0, size.width-2*CORNERS_SPACE, size.height);
        self.MGTVCContentView.addCorner = YES;
       
        [self setContentViewCornerTypeWith:indePath cellNumber:cellNumber];
    }
    self.MGTVCTitleLabel.frame = CGRectMake(0, 0, size.width, size.height);
    self.MGTVCContentView.frame = contentViewFrame;
    [self.MGTVCContentView setNeedsDisplay];
    [self resetImageViewWithSize:self.MGTVCContentView.frame.size];
    [self resetTitleLabelWithSize:self.MGTVCContentView.frame.size];
    [self resetDetialLabelWithSize:self.MGTVCContentView.frame.size];
    [self resetAccessoryViewWithSize:self.MGTVCContentView.frame.size];
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)drawCorner
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
