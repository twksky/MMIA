//
//  MMIAAboutPersonViewController.h
//  MMIA
//
//  Created by Free on 14-6-18.
//  Copyright (c) 2014年 com.zixun. All rights reserved.
//

#import "MMiaBaseViewController.h"
#import "LoginInfoItem.h"

@interface MMIAAboutPersonViewController : MMiaBaseViewController{
    
}
@property(nonatomic,retain)UIImage *headImage;
-(id)initWithLoginItem:(LoginInfoItem *)loginItem;
@property(nonatomic,assign)NSInteger userId;
@end
