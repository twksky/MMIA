//
//  FrameMacro.h
//  MMia
//

//  Copyright (c) 2014 Wuzixun. All rights reserved.
//

#ifndef MMia_FrameMacro_h
#define MMia_FrameMacro_h
//通知
/*修改个人呢资料*/
#define Change_PersonData     @"changePersonData"
/*修改专题*/
#define Change_MagezineData   @"changeMagezineData"
/*收进专题*/
#define Ining_MagezineData    @"inMagezineData"
/*修改关于内容*/
//#define Change_AboutData      @"changeAboutData"
/*修改关注的人的专题信息*/
#define Get_ConcernPerson_HomeMagezineData  @"changeConcernPersonData"
/*喜欢变化*/
#define  Change_LikeData        @"change_LikeData"
/*修改喜欢数 key值*/
#define  Add_Like_Num               @"addlikeNum"
#define  Change_AboutPerson_Data  @"changeAboutPersonData"

#define UMAppKey  @"5385405756240b6961180921"

#define kTipsTopOffset  330
#define CONTENT_INSET_TOP 342 / 2
#define Homepage_Cell_Image_Width 295 / 2
#define Homepage_Cell_Image_Hight 222 / 2
#define Homepage_Cell_Logo_Hight  44 / 2
#define Request_Data_Count        20


#define kTalkingDataKey @"5F367A20EB9134D30C76840BC4B71C3B"

// http request
#define HTTP_REQUEST_GET @"GET"
#define HTTP_REQUEST_POST @"POST"

//first time login
#define USER_FIRST_TIME_LOGIN  @"user_first_time_login"
//个人中心
#define USER_TICKET            @"userTicket"
#define USER_ID                @"userId"
#define USER_IS_LOGIN          @"userIsLogin"
#define USER_TYPE              @"userType"
#define USER_EMAIL             @"userEmail"
#define PERSON_HOME_HAVE       @"have"
#define PERSON_LIKE_HAVE       @"likeHave" 


// MMia URL

#define MMia_HOMEPAGE_URL         @"humpback4/mgetHomeBannerAndMagazines.do"
#define MMia_HOMEPAGE_FULL_URL    @"humpback4/mgetHomeAllMagazines.do"
#define MMia_HOMEPAGE_CHANNEL_URL @"humpback4/mgetHomeChannelMagazines.do"
#define MMia_FINDPAGE_URL       @"humpback3/mchannel.do"
#define MMia_DETAIL_MAGAZIN_URL @"humpback3/mgetMagazineById.do"
#define MMia_DETAIL_CONTENT_URL @"ados/share/getMagazinePic"
#define MMia_IMAGES_DETAIL_URL  @"humpback3/mgetPicById.do"
#define MMia_CATEGROY_URL       @"humpback4/getMobileCategories.do"
#define MMia_MINOR_CATEGROY_URL @"humpback4/getMSpriderCategorys.do"
#define MMia_SINGL_CATEGROY_URL @"channel/pages/ChannelData/getMobileNewAndHotData.do"
#define MMia_SINGL_HOTANEW_URL  @"channel/pages/ChannelData/getMobileSolrData.do"

// 最新/最热
#define MMia_NEWMAGEZINE_PAGE_URL @"humpback/mnewMagazines.do"
#define MMia_HOTMAGEZINE_PAGE_URL @"humpback/mhotMagazines.do"
// 搜索默认词，搜素热词，搜索
#define MMia_SEARCHDEFAULT_PAGE_URL  @"humpback/msearchHotWord.do"
#define MMia_SEARCHHOTWORDS_PAGE_URL @"humpback/mhotWords.do"
#define MMia_SEARCHApi_PAGE_URL      @"elephant/s.do"

//personal center
//登陆
#define MMia_LOGIN_URL  @"user/ados/mlogin"

//注册
/* 短信验证码*/
#define MMia_REGISTER_PHONE_VERITY_URL  @"user/sendText"
/* 邮箱验证码*/
#define MMia_REGISTER_MAIL_VERITY_URL   @"user/sendMail"
/* 注册*/
#define MMia_REGISTER_URL   @"user/ados/mregister"

//忘记密码
/* 忘记密码 */
#define MMia_FORGET_PASSWORD_URL  @"user/ados/mresetPassword"
/*验证邮箱或手机号是否注册*/
#define MMia_CHECK_MOBILEUNIQUE_URL  @"user/ados/checkMobileUnique"

//个人中心
/*获取用户的个人资料*/
#define MMia_GET_PERSONAL_INFO_URL  @"user/ados/mgetUserInfo"

/*用户修改个人资料 */
#define MMia_MODIFY_PERSONAL_INFO_URL @"user/ados/mmodifyUser"

/*用户上传图像*/
#define MMia_UPLOAD_HEADERPICTURE_URL @"user/ados/muploadHeaderPicture"

/*（拍照/照片）上传图片 */
#define MMia_upload_PIC_URL           @"up/ados/upload"


/*企业用户资料上传*/
#define MMia_MODIFY_COMPANY_INFO_URL  @"user/ados/mmodifyCompany"

/*获取用户的杂志 */
#define MMia_GET_USER_MAGEZINE_URL    @"ados/mag/getUserMagazine"

/*创建杂志*/
#define MMia_CREATE_MAGEZINE_URL       @"ados/mag/createMagazine"

/*专题详情页*/
#define MMia_MAGAZINESHARELIST_URL     @"ados/mag/getMagazineShareList"

/*商品详情页*/
#define MMia_PRODUCTPIC_URL            @"product/ados/mGetProductPicsById"

/*图片详情页*/
#define MMia_GETPICBYID_URL            @"ados/share/mgetPicById"

/*删除商品或图片*/
#define MMia_DELETEPRODUCTPIC_URL      @"product/ados/deleteProductPicsById"


/*用户修改杂志*/
#define MMia_EDIT_MAGEZINE_URL         @"ados/mag/editMagazine"

/*删除用户杂志*/
#define MMia_DELETE_MAGEZINE_URL       @"ados/mag/deletemagazine"

/*用户修改密码*/
#define MMia_CHANGE_PASSWORD_URL       @"user/ados/mchangePassword"

/*获取用户粉丝*/
#define MMia_GET_USERFUNS_URL           @"ados/focus/getUserFans/"

/*获取关注的人*/
#define MMia_GET_FAVOURPERSON_URL       @"ados/focus/getMyFavourPerson/"

/*用户取消关注某个人*/
#define MMia_CANCEL_FOLLOWONE_URL   @"ados/focus/cancelFollowSomeOne/"

/*用户关注某个人*/
#define MMia_FOCUS_FOLLOWONE_URL    @"ados/focus/followSomeOne/"

/*获取关注的杂志*/
#define MMia_GET_ATTENMAG_URL           @"ados/focus/getMyAttenMag/"

/*用户取消关注某本专题 */
#define MMia_CANCEL_FOLLOWMAGZINE_URL   @"ados/focus/cancelFollowmagazine/"

/*用户关注某本主题*/
#define MMia_FOLLOWMAGZINE_URL          @"ados/focus/followmagazine/"


/*获取用户专题*/
#define MMia_GET_USERALLMAGEZINE_URL    @"ados/mag/getUserAllMagazine"

/*分享图片到专题*/
#define MMia_PICTURE_TOMAGEZINE_URL     @"ados/share/sharePictureToMagazine"

/*用户喜欢某个商品或者图片*/
#define MMia_ADDLIKE_URL                @"ados/love/addLike"

/*用户取消喜欢某个商品或者图片*/
#define MMia_DELETELIKE_URL             @"ados/love/deleteLike"


//友盟
#define UMENG_APPKEY @"5385405756240b6961180921"


// TC qq
#define kQQAppKey @"101102472"
#define kQQAppSecret @"59acc5369c8b0b4fee2f31ef5ebc6396"

// weixin
#define kWxAppKey @"wx5a053bb69b4cfe38"
#define kWxAppSecret @"6210cd1bcb6a09429eac2bfda97f6e9f"

// sina weibo
#define kWBApiHost @"https://api.weibo.com"
#define kWbAppKey @"2393725781"
#define kWbAppSecret @"487e851d7a95591d8cf917dd81410e36"
#define kWbRedirectURI @"http://www.MMia.com/client/weibo_oauth/confirm/"

// TC weibo
#define kTCWBApiHost @"https://open.t.qq.com"
#define kTCWbAppKey @"801509979"
#define kTCWbAppSecret @"04edf51c4e2757cd4c8f24bbea7e0eb4"
#define kTCWbRedirectURI @"http://www.ying7wang7.com"


// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]

// App Frame Height&Width
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height
#define RIGHT(v)                ((v).frame.origin.x + (v).frame.size.width)
#define BOTTOM(v)               ((v).frame.origin.y + (v).frame.size.height)

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)

#define ViewWidth(v)                        v.frame.size.width
#define ViewHeight(v)                       v.frame.size.height
#define ViewX(v)                            v.frame.origin.x
#define ViewY(v)                            v.frame.origin.y


#define SelfViewWidth                       self.view.bounds.size.width
#define SelfViewHeight                      self.view.bounds.size.height


#define RectX(rect)                            rect.origin.x
#define RectY(rect)                            rect.origin.y
#define RectWidth(rect)                        rect.size.width
#define RectHeight(rect)                       rect.size.height


#define RectSetWidth(rect, w)                  CGRectMake(RectX(rect), RectY(rect), w, RectHeight(rect))
#define RectSetHeight(rect, h)                 CGRectMake(RectX(rect), RectY(rect), RectWidth(rect), h)
#define RectSetX(rect, x)                      CGRectMake(x, RectY(rect), RectWidth(rect), RectHeight(rect))
#define RectSetY(rect, y)                      CGRectMake(RectX(rect), y, RectWidth(rect), RectHeight(rect))


#define RectSetSize(rect, w, h)                CGRectMake(RectX(rect), RectY(rect), w, h)
#define RectSetOrigin(rect, x, y)              CGRectMake(x, y, RectWidth(rect), RectHeight(rect))


// 系统控件默认高度
#define kStatusBarHeight        (20.f)

#define kTopBarHeight           (44.f)
#define kBottomBarHeight        (49.f)

#define kCellDefaultHeight      (44.f)

#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)

#define kNavigationBarHeight    (44.f)

//add
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define VIEW_OFFSET                     ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0f?20.0f:0.0f)
#define VIEW_OFFSET_FOR_TABBR           ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0f?0.0f:20.0f)

//tabbar 背景颜色
#define TABLE_BAR_HEIGHT                self.tabBarController.tabBar.frame.size.height
#define  TABLE_BAR_ORIGIN_FRAME_NAME    @"tabbarOriginFrame"
#define  TABLE_BAR_ORIGIN_FRAME         [[NSUserDefaults standardUserDefaults] objectForKey:TABLE_BAR_ORIGIN_FRAME_NAME]
//背景颜色
#define BACK_GROUND_COLOR               [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1]
#define TABLEVIEW_LINE_COLOR            [UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1]

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height


#ifdef __IPHONE_6_0
# define MMIALineBreakModeWordWrap  NSLineBreakByWordWrapping
# define MMIATextAlignment          NSTextAlignment

# define MMIATextAlignmentCenter    NSTextAlignmentCenter
# define MMIATextAlignmentLeft      NSTextAlignmentLeft
# define MMIATextAlignmentRight     NSTextAlignmentRight

#else
# define MMIALineBreakModeWordWrap   UILineBreakModeWordWrap
# define MMIATextAlignment           UITextAlignment


# define MMIATextAlignmentCenter    UITextAlignmentCenter
# define MMIATextAlignmentLeft      UITextAlignmentLeft
# define MMIATextAlignmentRight     UITextAlignmentRight
#endif



//end add


#endif
