//
//  YJYPublic.h
//  Scaffold
//
//  Created by wusonghe on 2017/2/23.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#ifndef YJYPublic_h
#define YJYPublic_h


#endif /* YJYPublic_h */

#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kColorAlpha(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define DEVICE_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define DEVICE_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVIGATIONBAR_HEIGHT self.navigationController.navigationBar.frame.size.height

#define IS_IPHONE_6Plus ([[UIScreen mainScreen ] bounds].size.height == 736)
#define IS_IPHONE_6     ([[UIScreen mainScreen ] bounds].size.height == 667)
#define IS_IPHONE_5     ([[UIScreen mainScreen ] bounds].size.height == 568)
#define IS_IPHONE_4     ([[UIScreen mainScreen ] bounds].size.height == 480)


//十六进制颜色
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HEXCOLORALPHA(rgbValue,alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]



#define SID @"sid"
//field

#define kHeadimg @"headimg"
#define kIdcard  @"idcard"
#define kUsername @"username"
#define kUserphone @"userphone"
#define kUserheadimg @"userheadimg"
#define kUserRongToken @"token"
#define kWxPayResult @"wxPayResult"
#define kAdcode @"adcode"
#define kPayResultNumber @"kPayResultNumber"
#define kJPushToken @"kJPushToken"
#define kDoorBanTipFirst @"kDoorBanTipFirst"


#define IS_ENTERPRICE NO
//#define IS_ENTERPRICE YES
//#define AppColor kColorAlpha(83,189,177,1) //82CBC5


#define APPHEXVALUE @"2bd6bd"
#define APPHEXCOLOR [UIColor colorWithHexString:@"#2bd6bd"]
#define APPExtraGrayCOLOR [UIColor colorWithHexString:@"f1f2f6"]

#define APPGrayCOLOR [UIColor colorWithHexString:@"cccccc"]
#define APPDarkGrayCOLOR [UIColor colorWithHexString:@"999999"]
#define APPDarkCOLOR [UIColor colorWithHexString:@"333333"]
#define APPMiddleGrayCOLOR [UIColor colorWithHexString:@"666666"]


#define APPNAVICOLOR [UIColor colorWithHexString:@"#f1f2f6"]
#define APPORANGECOLOR [UIColor colorWithHexString:@"#ffc360"]
#define APPBLACKCOLOR [UIColor colorWithHexString:@"#333333"]
#define APPREDCOLOR [UIColor colorWithHexString:@"#ff5257"]
#define APPBLUECOLOR [UIColor colorWithHexString:@"#48a0dc"]


#define kWaitPayPrefeeColor [UIColor colorWithHexString:@"ff5454"]
#define kWaitAssignColor [UIColor colorWithHexString:@"ffcd7d"]
#define kServiceIngColor [UIColor colorWithHexString:@"2BD6BD"]
#define kWaitCheckoutColor [UIColor colorWithHexString:@"ff5454"]
#define kWaitAppraiseColor [UIColor colorWithHexString:@"ffcd7d"]
#define kOrderCompleteColor [UIColor colorWithHexString:@"333333"]


//Notification

#define kYJYOrderDidCreateNotification @"kYJYOrderDidCreateNotification"
#define kYJYTabBarIndexSelectNotification @"kYJYTabBarIndexSelectNotification"
#define kYJYHomeIndexSelectNotification @"kYJYHomeIndexSelectNotification"

#define kYJYOrderListUpdateNotification @"kYJYOrderListUpdateNotification"

//The 3rd Party

#define RongYunAppKey @"qd46yzrfq0mzf"
#define RongYunAppSecret  @"14oXoAR0PzIb2D"

#define JiGuang_Push_AppID @"a27df55888ba00c2e5f7a78b"
#define JiGuang_Push_Master_Secret @"0e2a0ec1d98c5a5c63f2d83b"


#define UMengAppID @"593650f0a40fa33d5a001700"

#define QQAPPID @"1106002173"

#define SINAAPPID @"2479949691"

#define WECHATAPPID @"wx593e1845a56bac8a"

#define GAODEMAP @"837a350155be16000435d0742be30a7e"

#define kScreenSize [UIScreen mainScreen].bounds.size
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height


// 获取沙盒主目录路径
#define kHomeDir NSHomeDirectory()
// 获取Documents目录路径
#define kDocDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
// 获取Library的目录路径
#define kLibDir [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
// 获取Caches目录路径
#define kCachesDir  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
// 获取tmp目录路径
#define kTmpDir  NSTemporaryDirectory()
