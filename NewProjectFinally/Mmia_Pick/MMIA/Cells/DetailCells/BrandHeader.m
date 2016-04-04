//
//  BrandHeader.m
//  MMIA
//
//  Created by yhx on 15/5/27.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "BrandHeader.h"


@interface BrandHeader ()

@property (weak, nonatomic) IBOutlet UILabel*  brandDescription;
@property (weak, nonatomic) IBOutlet UIView*   lineView;
@property (weak, nonatomic) IBOutlet UILabel*  websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel*  websiteInfo;
@property (weak, nonatomic) IBOutlet UIView*   nextLineView;
@property (weak, nonatomic) IBOutlet UILabel*  titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *websiteLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *websiteInfoTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextLineTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextLineViewHeight;

- (IBAction)websiteInfoTapAction:(id)sender;

@end

@implementation BrandHeader

- (void)awakeFromNib
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(websiteInfoTapAction:)];
    [self.websiteInfo addGestureRecognizer:singleTap];
}

- (void)reloadBrandHeaderWithModel:(MmiaPaperProductListModel *)model
{
   // self.brandDescription.text = model.describe;
    self.websiteInfo.text = model.officalWebsite;
    //self.titleLabel.text = model.title;
     [self.brandDescription setLineSpace:KProductLabel_LineSpace Text:model.describe];
    [self.titleLabel setLineSpace:KProductLabel_LineSpace Text:model.title];
    if( model.officalWebsite.length <= 0 )
    {
        self.websiteLabel.text = @"";
        self.websiteLabelTop.constant = 0;
        
        self.websiteInfoTop.constant = 0;
        
        self.nextLineTop.constant = 0;
        self.nextLineViewHeight.constant = 0;
    }else
    {
        self.websiteLabelTop.constant = 10;
        self.websiteLabel.text = @"官方网站";
        
        self.websiteInfoTop.constant = 8;
        
        self.nextLineTop.constant = 10;
        self.nextLineViewHeight.constant = 1;
    }
     [self.websiteLabel updateConstraintsIfNeeded];
     [self.websiteInfo updateConstraintsIfNeeded];
     [self.nextLineView updateConstraintsIfNeeded];
    
}

- (IBAction)websiteInfoTapAction:(id)sender
{
    if( self.TapWebsiteBlock )
    {
        self.TapWebsiteBlock();
    }
}

@end