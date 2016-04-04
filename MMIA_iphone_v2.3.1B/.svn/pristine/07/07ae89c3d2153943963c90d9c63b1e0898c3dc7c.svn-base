//
//  MMiaTabLikeViewController.h
//  MMIA
//
//  Created by lixiao on 14-10-30.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaBaseViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"

@protocol MMiaTabLikeViewControllerDelegate <NSObject>
-(void)returnTabLikeVieW;
@end


@interface MMiaTabLikeViewController : MMiaBaseViewController<MMiaTabLikeViewControllerDelegate,CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSMutableArray*   likeDataArr;
@property(nonatomic,retain)UIButton *topButton;
-(void)refreshLikeData;
@end
