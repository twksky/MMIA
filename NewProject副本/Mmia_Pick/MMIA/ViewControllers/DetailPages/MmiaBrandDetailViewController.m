//
//  MmiaBrandDetailViewController.m
//  MMIA
//
//  Created by MMIA-Mac on 15-5-15.
//  Copyright (c) 2015年 yhx. All rights reserved.
//

#import "MmiaBrandDetailViewController.h"
#import "CollectionViewPaperCell2.h"
#import "GlobalKey.h"


@interface MmiaBrandDetailViewController ()

@end

@implementation MmiaBrandDetailViewController

#pragma mark - Accessors
#pragma mark - init

- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout])
    {
        UINib* nib1 = [UINib nibWithNibName:@"MmiaBrandCollectionCell" bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:MmiaBrandCellIdentifier ];
        
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5; //与MmiaPaperViewController count对应
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewPaperCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MmiaBrandCellIdentifier forIndexPath:indexPath];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
