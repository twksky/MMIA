

#import "MMiaSkinManager.h"
#import "FrameMacro.h"
#import "MMiaCommonUtil.h"
#import "../General/CustomViews/MMiaUINavigationController.h"

@interface MMiaSkinManager()
- (void)initManager;
@end

@implementation MMiaSkinManager

+ (MMiaSkinManager *)sharedInstance
{
    static MMiaSkinManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MMiaSkinManager alloc] init];
        [instance initManager];
    });
    return instance;
}

+ (BOOL)isIOS7
{
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    
    return _deviceSystemMajorVersion >= 7;
}

+ (BOOL)isRetina
{
    CGFloat displayScale = [UIScreen mainScreen].scale;
    return (displayScale > 1.9 && displayScale < 2.1);
}

- (void)initManager
{
    if ([MMiaSkinManager isRetina]) {
        _defaultSlideMenuWidth = 275.0f;
    } else {
        _defaultSlideMenuWidth = 550.0f;
    }
    
    //init colors
    _defaultClearColor = [UIColor clearColor];
    _defaultBackgroundColor = [MMiaCommonUtil UIColorFromRGB:0xf5f5f5];
    
    //init font
    _defaultTagFont = [UIFont systemFontOfSize:12.0f];
    _defaultAppSizeTextFont = [UIFont systemFontOfSize:13.0f];
    _defaultAppShortDescFont = [UIFont boldSystemFontOfSize:17.0f];
    _defaultTomatoSpeakTextFont = [UIFont systemFontOfSize:16.0f];
    _defaultOpenPackTextFont = [UIFont systemFontOfSize:12.0f];
    _defaultCalendarMonthFont = [UIFont systemFontOfSize:10.0f];
    _defaultCalendarDayFont = [UIFont systemFontOfSize:20.0f];
    _defaultCalendarPickerMonthFont = [UIFont systemFontOfSize:25.0f];
    _defaultCalendarPickerWeekFont = [UIFont systemFontOfSize:14.0f];
    _defaultCalendarPickerSelectedFont = [UIFont boldSystemFontOfSize:18.0f];
    _defaultButtonFont = [UIFont systemFontOfSize:14.0f];
    _defaultCommentTextFont = [UIFont systemFontOfSize:13.0f];
    _defaultCommentNicknameFont = [UIFont systemFontOfSize:10.0f];;
    
    //init image
    if (IS_IOS_7) {
        //        _defaultMenuIconImage = [[UIImage imageNamed:@"btn_navi_menu.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        //        _defaultBackIconImage = [[UIImage imageNamed:@"btn_navi_backward.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        //        _defaultShareIconImage = [[UIImage imageNamed:@"btn_navi_share.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        //        _defaultTomatoSpeakImage = [[UIImage imageNamed:@"img_tomatoSpeak.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        //        _defaultOpenUpImage = [[UIImage imageNamed:@"btn_open_up.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        //        _defaultPackUpImage = [[UIImage imageNamed:@"btn_pack_up.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        //        _defaultDownloadBackgroundIamge = [[UIImage imageNamed:@"bk_download.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        //        _defaultDownloadIconImage = [[UIImage imageNamed:@"btn_icon_download.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        //        _defaultLeftComemntBubbleImage = [[UIImage imageNamed:@"bubble_left.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
        //        _defaultRightCommentBubbleImage = [[UIImage imageNamed:@"bubble_right.png"] imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal];
    }else{
        //        _defaultMenuIconImage = [UIImage imageNamed:@"btn_navi_menu.png"];
        //        _defaultBackIconImage = [UIImage imageNamed:@"btn_navi_backward.png"];
        //        _defaultShareIconImage = [UIImage imageNamed:@"btn_navi_share.png"];
        //        _defaultTomatoSpeakImage = [UIImage imageNamed:@"img_tomatoSpeak.png"];
        //        _defaultOpenUpImage = [UIImage imageNamed:@"btn_open_up.png"];
        //        _defaultPackUpImage = [UIImage imageNamed:@"btn_pack_up.png"];
        //        _defaultDownloadBackgroundIamge = [UIImage imageNamed:@"bk_download.png"];
        //        _defaultDownloadIconImage = [UIImage imageNamed:@"btn_icon_download.png"];
        //        _defaultLeftComemntBubbleImage = [UIImage imageNamed:@"bubble_left.png"];
        //        _defaultRightCommentBubbleImage = [UIImage imageNamed:@"bubble_right.png"];
    }
    
    //    _defaultAppIconImage = [UIImage imageNamed:@"app_default_icon"];
    //
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"Icon" ofType:@"png"];
    //    _defaultMMiaLogoImage = [UIImage imageWithContentsOfFile:path];
    //
    //    path = [[NSBundle mainBundle] pathForResource:@"guide_thumb_detail" ofType:@"png"];
    //    _defaultGuideThumbImage = [UIImage imageWithContentsOfFile:path];
    //
    //    path = [[NSBundle mainBundle] pathForResource:@"banner_default" ofType:@"png"];
    //    _defaultBannerImage = [UIImage imageWithContentsOfFile:path];
    //
    //    _defaultMMiaLoadingSpinner = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 51.0f/2.0f, 53.0f/2.0f)];
    //    NSMutableArray *loadingImages = [[NSMutableArray alloc] initWithCapacity:7];
    //    for (int i =1; i<=7; i++) {
    //        path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"loading%d",i] ofType:@"png"];
    //        UIImage *image = [UIImage imageWithContentsOfFile:path];
    //        [loadingImages addObject:image];
    //    }
    //    _defaultMMiaLoadingSpinner.animationImages = loadingImages;
    //    _defaultMMiaLoadingSpinner.animationDuration = 0.5f;
    //    _defaultMMiaLoadingSpinner.animationRepeatCount = 0;
}

- (UINavigationController *)createDefaultNavigationControllerWithRootView:(UIViewController *)rootViewController
{
    UINavigationController *navController = [[MMiaUINavigationController alloc] initWithRootViewController:rootViewController];
    [navController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navController.navigationBar setShadowImage:[[UIImage alloc] init]];
    navController.navigationBar.translucent = YES;
    if (IS_IOS_7) {
        navController.navigationBar.barTintColor = [UIColor clearColor];
    }
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_5_1) {
        NSMutableDictionary *titleTextAttributesDic = [[NSMutableDictionary alloc] init];
        [titleTextAttributesDic setObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        [titleTextAttributesDic setObject:[UIFont boldSystemFontOfSize:19.0f] forKey:NSFontAttributeName];
        [navController.navigationBar setTitleTextAttributes:titleTextAttributesDic];
    }
    
    return navController;
}

- (UILabel *)createNavigationTitleLabelForiOS6
{
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:CGRectMake(0, 0, Main_Screen_Width - 136.0f, kNavigationBarHeight)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:19.0f]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    return titleLabel;
}

- (UIImageView *)getMMiaLoadingSpinner
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 51.0f/2.0f, 53.0f/2.0f)];
    NSMutableArray *loadingImages = [[NSMutableArray alloc] initWithCapacity:7];
    for (int i =1; i<=7; i++) {
        NSString* path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"loading%d",i] ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [loadingImages addObject:image];
    }
    imgView.animationImages = loadingImages;
    imgView.animationDuration = 0.5f;
    imgView.animationRepeatCount = 0;
    
    return imgView;
}
@end
