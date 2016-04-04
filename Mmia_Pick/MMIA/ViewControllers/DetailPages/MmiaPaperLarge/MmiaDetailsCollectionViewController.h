//
//  MmiaDetailsCollectionViewController.h
//  MMIA
//
//  Created by twksky on 15/5/20.
//  Copyright (c) 2015年 lixiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface MmiaDetailsCollectionViewController : UICollectionViewController<UIApplicationDelegate,UIAlertViewDelegate, WXApiDelegate>

{
    enum WXScene _scene;
}

- (void) changeScene:(NSInteger)scene;
- (void) sendTextContent;
- (void) sendImageContent;
- (void) sendLinkContent;
- (void) sendMusicContent;
- (void) sendVideoContent;
- (void) sendAppContent;
- (void) sendNonGifContent;
- (void) sendGifContent;
- (void) sendAuthRequest;
- (void) sendFileContent;
- (void) testUrlLength : (NSString*) length;
- (void) openProfile;
- (void) jumpToBizWebview;
- (void) addCardToWXCardPackage;
- (void) batchAddCardToWXCardPackage;


@end
