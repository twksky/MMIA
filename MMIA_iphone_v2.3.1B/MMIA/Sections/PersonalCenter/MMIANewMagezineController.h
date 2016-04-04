//
//  MMIANewMagezineController.h
//  MMIA
//
//  Created by Jack on 15/1/20.
//  Copyright (c) 2015年 com.zixun. All rights reserved.
//

#import "MMiaBaseViewController.h"

@class MMIANewMagezineController;
@protocol MMIANewMagezineControllerDelegate <NSObject>

- (void)reloadUserAllMagazineData:(MMIANewMagezineController *)viewController;

@end

@interface MMIANewMagezineController : MMiaBaseViewController

@property (nonatomic, weak) id <MMIANewMagezineControllerDelegate> delegate;

-(id)initWithShare:(int)magezineId ticket:(NSString*)ticket magazineId:(NSInteger)magazineId imageData:(NSData*)imageData imageId:(NSInteger)imageId;


@end
