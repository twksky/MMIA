//
//  ProductHeader.m
//  MMIA
//
//  Created by yhx on 15/6/8.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "ProductHeader.h"

const CGFloat KLogoImageHeight = 50.0f;

@interface ProductHeader ()

@property (weak, nonatomic) IBOutlet UIImageView* logoImageView;
@property (weak, nonatomic) IBOutlet UILabel*     singelName;
@property (weak, nonatomic) IBOutlet UILabel*     singelDescription;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageViewHeight;

- (IBAction)logoImageViewTapAction:(id)sender;

@end

@implementation ProductHeader

- (void)awakeFromNib
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoImageViewTapAction:)];
    [self.logoImageView addGestureRecognizer:singleTap];
}

- (void)reloadProductHeaderWithModel:(MmiaPaperProductListModel *)model productHeaderState:(ProductHeaderState)state
{
    [self.logoImageView sd_setImageWithURL:NSURLWithString(model.logo) placeholderImage:[UIImage imageNamed:@"search_logo.png"]];
    
    if( state == ProductInfoDetailHeaderType )
    {
        //self.singelName.text = model.title;
        //self.singelDescription.text = model.describe;
        [self.singelName setLineSpace:KProductLabel_LineSpace Text:model.title];
        [self.singelDescription setLineSpace:KProductLabel_LineSpace Text:model.describe];
    }
    else if( state == BrandEntryDetailHeaderType )
    {
        self.singelName.text = model.name;
         self.singelDescription.text = model.slogan;
       // [self.singelName setLineSpace:KProductLabel_LineSpace Text:model.name];
       // [self.singelDescription setLineSpace:KProductLabel_LineSpace Text:model.slogan];
    }
    
    if (model.logo.length <= 0)
    {
        self.logoImageViewHeight.constant = 0;
        self.logoTopSpace.constant = 0;
    }
    else
    {
        self.logoImageViewHeight.constant = KLogoImageHeight;
        self.logoTopSpace.constant = KProductDetailPicture_LeftMargin;
    }
    [self.logoImageView updateConstraints];
    
    if( self.singelName.text.length <= 0 )
    {
        self.nameTopSpace.constant = 0;
    }
    else
    {
        self.nameTopSpace.constant = KProductDetailPicture_LeftMargin;
    }
    [self.singelName updateConstraints];

}

- (IBAction)logoImageViewTapAction:(id)sender
{
    if( self.TapBrandLogoBlock )
    {
        self.TapBrandLogoBlock();
    }
}

@end
