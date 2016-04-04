//
//  MMiaShareViewController.h
//  MMIA
//
//  Created by MMIA-Mac on 14-9-10.
//  Copyright (c) 2014年 com.yhx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTCollectionViewWaterfallLayout.h"

@protocol MMiaShareViewControllerDelegate <NSObject>
-(void)returnShareVie;
@end
@interface MMiaShareViewController : UIViewController<CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource,MMiaShareViewControllerDelegate>

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, assign) CGFloat   collectionInset;

@property (nonatomic, strong) NSMutableArray*   shareDataArr;
@property(nonatomic,assign)BOOL isOthers;
- (id)initWithUserId:(NSInteger)userId ticket:(NSString *)ticket;

@end
