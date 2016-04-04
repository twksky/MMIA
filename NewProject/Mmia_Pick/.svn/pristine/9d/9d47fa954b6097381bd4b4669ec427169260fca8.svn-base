//
//  BrandEntrancePageViewController.m
//  MMIA
//
//  Created by twksky on 15/6/4.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import "BrandEntrancePageViewController.h"
#import "ShareView.h"

@interface BrandEntrancePageViewController ()

@end

@implementation BrandEntrancePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:UINibWithName(@"SingelHeader") forSupplementaryViewOfKind:CollectionElementKindSectionHeader withReuseIdentifier:@"cell2_CellHeader"];
    [self.collectionView registerClass:[ShareView class] forSupplementaryViewOfKind:@"UICollectionElementKindSectionFooter" withReuseIdentifier:@"Share"];
    [self.collectionView registerNib:UINibWithName(@"ProductDetailPictureCell") forCellWithReuseIdentifier:ProductDetailPictureCellIdentifier ];
    self.collectionView.frame = CGRectMake(0, VIEW_OFFSET+kNavigationBarHeight, Main_Screen_Width, Main_Screen_Height-VIEW_OFFSET-kNavigationBarHeight);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
