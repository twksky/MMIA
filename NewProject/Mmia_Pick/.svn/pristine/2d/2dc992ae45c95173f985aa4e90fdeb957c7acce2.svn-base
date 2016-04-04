//
//  DetailsCell2.m
//  MMIA
//
//  Created by twksky on 15/5/15.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "DetailsCell2.h"
#import "DetailsCell2_Cell.h"
#import "MmiaCollectionViewSmallLayout.h"
#import "MmiaBrandViewController.h"
#import "WeiboSDK.h"
//#import "AppDelegate.h"

@implementation DetailsCell2

- (void)awakeFromNib {
    // Initialization code
    
    
    _singleCollectionView.delegate = self;
    _singleCollectionView.dataSource = self;
    _singleCollectionView.backgroundColor = [UIColor clearColor];
    _productHeader.productModel = self.productModel;
    [_singleCollectionView registerNib:[UINib nibWithNibName:@"DetailsCell2_Cell" bundle:nil]forCellWithReuseIdentifier:@"cell2_Cell"];
    [_singleCollectionView registerClass:[ShareView class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" withReuseIdentifier:@"Share"];
    [_singleCollectionView registerNib:[UINib nibWithNibName:@"ProductHeader" bundle:nil] forSupplementaryViewOfKind:@"UICollectionElementKindSectionHeader" withReuseIdentifier:@"cell2_CellHeader"];
    [self getNavTitle];
}

-(void)getNavTitle
{
    _navTitle.text = self.productModel.title;
    _navTitle.font = [UIFont systemFontOfSize:20];
    _navTitle.textColor = [UIColor blackColor];
}

// 设置每一组有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.productModel.productPictureList.count;
}

// 设置一共有多少个分组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

////设置头脚高。。。**
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //先加载，定义高
    
    CGFloat H1 = [GlobalFunction getTextSizeWithSystemFont:[UIFont systemFontOfSize:10] ConstrainedToSize:CGSizeMake(Main_Screen_Width-20, Main_Screen_Height) string:self.productModel.title].height;
    CGFloat H2 = [GlobalFunction getTextSizeWithSystemFont:[UIFont systemFontOfSize:10] ConstrainedToSize:CGSizeMake(Main_Screen_Width-20, Main_Screen_Height) string:self.productModel.describe].height;
    
    return CGSizeMake(Main_Screen_Width-20, 10+50+10+H1+5+H2+10+10);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(Main_Screen_Width, 40);
}


//设置组头，组脚分享view

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind  isEqual: @"UICollectionElementKindSectionHeader"]) {
        self.productHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cell2_CellHeader" forIndexPath:indexPath];
        [self.productHeader initWithTarget:self];
        self.productHeader.brandLogo.backgroundColor = [UIColor grayColor];
        [self.productHeader.brandLogo sd_setImageWithURL:[NSURL URLWithString:self.productModel.brandLogo]];
        self.productHeader.singelName.text = self.productModel.title;
        self.productHeader.singelDescription.text = self.productModel.describe;
        return self.productHeader;
    }
    else if ([kind  isEqual: @"UICollectionElementKindSectionFooter"]){
        self.shareView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Share" forIndexPath:indexPath];
        [self.shareView initWithTarget:self];
        return self.shareView;
    }
    return nil;
}

//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 10;
//}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell2_Cell";
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    NSString *describe = ((MmiaProductPictureListModel*)self.productModel.productPictureList[indexPath.row]).describe;
    NSString* picUrl = ((MmiaProductPictureListModel*)self.productModel.productPictureList[indexPath.row]).picUrl;
    CGFloat H1 = [GlobalFunction getTextSizeWithSystemFont:[UIFont systemFontOfSize:10] ConstrainedToSize:CGSizeMake(Main_Screen_Width-20, Main_Screen_Height) string:describe].height;
    [self.cell.pic sd_setImageWithURL:[NSURL URLWithString:picUrl]];
    self.cell.describe.text = describe;
    _navTitle.text = self.productModel.title;
    self.cell.describe.font = [UIFont systemFontOfSize:10];
    self.cell.describe.textColor = ColorWithHexRGB(0x666666);
    [self.cell.describe setNumberOfLines:0];
    CGFloat H2 = 150;
    [self.cell setHeight:H1+H2+10];
    NSLog(@"%lf",self.cell.height);
    return self.cell;
}

-(void)initWithTarget:(id)target{
    _target = target;
}

-(void)pushBrand:(UIButton *)btn
{
    NSLog(@"跳到品牌列表页");
    MmiaCollectionViewSmallLayout* smallLayout = [[MmiaCollectionViewSmallLayout alloc] init];
    MmiaBrandViewController* brandViewController = [[MmiaBrandViewController alloc] initWithCollectionViewLayout:smallLayout];
    brandViewController.brandId = self.productModel.brandId;
    [((MmiaDetailsCollectionViewController *)_target).navigationController pushViewController:brandViewController animated:YES];
    
}

#pragma mark _btnClick 分享

-(void)QQShare{
    NSLog(@"QQ分享");
    
    
}

-(void)FriendShare{
    NSLog(@"朋友圈分享");
    //:1
    //    [self changeScene:1];
    //    [self sendLinkContent];
}

-(void)WBShare{
//    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"%@%@",self.productModel.title,self.productModel.shareUrl];
//    message.text = @"haha";
    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: self.productModel.focusImg]];
    message.imageObject = image;
    [_target performSelector:@selector(WBShare:) withObject:message];
    
}

-(void)WXShare{
    NSLog(@"微信好友分享");
    //:0
}




@end
