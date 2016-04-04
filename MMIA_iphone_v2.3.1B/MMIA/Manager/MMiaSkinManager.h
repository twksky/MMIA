
#import <Foundation/Foundation.h>

#define IS_IOS_7 [MMiaSkinManager isIOS7]

@interface MMiaSkinManager : NSObject

+ (MMiaSkinManager *)sharedInstance;

+ (BOOL)isIOS7;
+ (BOOL)isRetina;

- (UINavigationController *)createDefaultNavigationControllerWithRootView:(UIViewController *)rootViewController;
- (UILabel *)createNavigationTitleLabelForiOS6;
- (UIImageView *)getMMiaLoadingSpinner;

//颜色
@property (nonatomic, strong, readonly) UIColor *defaultClearColor;
@property (nonatomic, strong,readonly) UIColor *defaultBackgroundColor;
@property (nonatomic, strong) UIColor *defaultButtonTitleColor;
@property (nonatomic, strong) UIColor *defaultLabeTextColor;
@property (nonatomic, strong) UIColor *defaultBorderColor;
@property (nonatomic, strong) UIColor *defaultTagBorderColor;
@property (nonatomic, strong) UIColor *defaultTagTextColor;
@property (nonatomic, strong) UIColor *defaultAppSizeTextColor;
@property (nonatomic, strong) UIColor *defaultEnglishNameTextColor;
@property (nonatomic, strong) UIColor *defaultCommentBackgroundColor;
@property (nonatomic, strong) UIColor *defaultTomatoSpeakTextColor;
@property (nonatomic, strong) UIColor *defaultCommentTextColor;
@property (nonatomic, strong) UIColor *defaultCommentNicknameTextColor;
@property (nonatomic, strong) UIColor *defaultOpenPackTextColor;
@property (nonatomic, strong) UIColor *defaultCalendarTextColor;

//字体
@property (nonatomic, strong) UIFont  *defaultButtonFont;
@property (nonatomic, strong) UIFont  *defaultCalendarMonthFont;
@property (nonatomic, strong) UIFont  *defaultCalendarDayFont;
@property (nonatomic, strong) UIFont  *defaultCalendarPickerMonthFont;
@property (nonatomic, strong) UIFont  *defaultCalendarPickerWeekFont;
@property (nonatomic, strong) UIFont  *defaultCalendarPickerSelectedFont;
@property (nonatomic, strong) UIFont  *defaultTagFont;
@property (nonatomic, strong) UIFont  *defaultAppSizeTextFont;
@property (nonatomic, strong) UIFont  *defaultAppShortDescFont;
@property (nonatomic, strong) UIFont *defaultTomatoSpeakTextFont;
@property (nonatomic, strong) UIFont *defaultOpenPackTextFont;
@property (nonatomic, strong) UIFont *defaultCommentTextFont;
@property (nonatomic, strong) UIFont *defaultCommentNicknameFont;

//图片
@property (nonatomic,strong) UIImage *defaultMenuIconImage;
@property (nonatomic,strong) UIImage *defaultBackIconImage;
@property (nonatomic,strong) UIImage *defaultShareIconImage;
@property (nonatomic,strong) UIImage *defaultMMiaLogoImage;
@property (nonatomic,strong) UIImage *defaultGuideThumbImage;
@property (nonatomic,strong) UIImage *defaultBannerImage;
@property (nonatomic,strong) UIImage *defaultTomatoSpeakImage;
@property (nonatomic,strong) UIImage *defaultOpenUpImage;
@property (nonatomic,strong) UIImage *defaultPackUpImage;
@property (nonatomic,strong) UIImage *defaultDownloadBackgroundIamge;
@property (nonatomic,strong) UIImage *defaultDownloadIconImage;
@property (nonatomic,strong) UIImage *defaultAppIconImage;
@property (nonatomic,strong) UIImage *defaultLeftComemntBubbleImage;
@property (nonatomic,strong) UIImage *defaultRightCommentBubbleImage;

//Size
@property (nonatomic,assign) CGFloat defaultSlideMenuWidth;

//视图
@property (nonatomic, strong) IBOutlet UIImageView *defaultMMiaLoadingSpinner;

@end
