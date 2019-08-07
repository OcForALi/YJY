//
//  YJYPublic.h
//  Scaffold
//
//  Created by wusonghe on 2017/2/23.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#ifndef YJYPublic_h
#define YJYPublic_h


#endif /* YJYPublic_h */

//全局AppDelegate
#define YJYAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

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
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

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
#define kRoleId @"roleId"
#define kHgType @"hgType"

#define IS_ENTERPRICE NO
//#define IS_ENTERPRICE YES
//#define AppColor kColorAlpha(83,189,177,1) //82CBC5

#define kScreenSize [UIScreen mainScreen].bounds.size
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#define APPHEXVALUE @"2bd6bd"
#define APPHEXCOLOR [UIColor colorWithHexString:@"#2bd6bd"]
#define APPNaviGrayCOLOR [UIColor blackColor]

#define APPSaasF4Color [UIColor colorWithHexString:@"F4F4F4"]
#define APPSaasF8Color [UIColor colorWithHexString:@"F8F8F8"]

#define APPNurseDarkGrayCOLOR [UIColor colorWithHexString:@"1d1d26"]
#define APPNurseGrayRGBCOLOR kColorAlpha(206,209,208,1)
#define APPNurseGrayCOLOR [UIColor colorWithHexString:@"1d1d26" alpha:0.5]
#define APPNurseGray30COLOR [UIColor colorWithHexString:@"1d1d26" alpha:0.3]
#define APPNurseHugeGrayCOLOR kColorAlpha(233,233,233,1)

#define APPNurseGray10COLOR [UIColor colorWithHexString:@"E7E8EA"]

#define APPExtraGrayCOLOR [UIColor colorWithHexString:@"f1f2f6"]

#define APPGrayCOLOR [UIColor colorWithHexString:@"cccccc"]
#define APPDarkGrayCOLOR [UIColor colorWithHexString:@"999999"]
#define APPDarkCOLOR [UIColor colorWithHexString:@"333333"]
#define APPMiddleGrayCOLOR [UIColor colorWithHexString:@"666666"]


#define APPNAVICOLOR [UIColor colorWithHexString:@"#f1f2f6"]
#define APPBLACKCOLOR [UIColor colorWithHexString:@"#333333"]
#define APPBLUECOLOR [UIColor colorWithHexString:@"#48a0dc"]
#define APPYELLOWCOLOR [UIColor colorWithHexString:@"#F6A623"]
#define APPPurpleCOLOR [UIColor colorWithHexString:@"#6563A4"]

#define APPORANGECOLOR [UIColor colorWithHexString:@"#FF3366"]
#define APPGREENCOLOR [UIColor colorWithHexString:@"#50E3C2"]
#define APPREDCOLOR [UIColor colorWithHexString:@"#FF3366"]
#define APPSMALLPURPLECOLOR [UIColor colorWithHexString:@"#D667CD"]
#define APPMIDDLEPURPLECOLOR [UIColor colorWithHexString:@"#8C88FF"]
#define APPDARKPURPLECOLOR [UIColor colorWithHexString:@"#6563A4"]



#define kOrderDailyColors @[APPORANGECOLOR,APPGREENCOLOR,APPSMALLPURPLECOLOR,APPMIDDLEPURPLECOLOR,APPDARKPURPLECOLOR,APPREDCOLOR]
#define kOrderDailyColorNameList  @[@"orange",@"green",@"small_purple",@"middle_purple",@"dark_purple",@"red"]

//Notification

#define kYJYOrderDidCreateNotification @"kYJYOrderDidCreateNotification"
#define kYJYTabBarIndexSelectNotification @"kYJYTabBarIndexSelectNotification"
#define kYJYHomeIndexSelectNotification @"kYJYHomeIndexSelectNotification"
#define kYJYMessageIndexSelectNotification @"kYJYMessageIndexSelectNotification"

#define kYJYOrderListUpdateNotification @"kYJYOrderListUpdateNotification"
#define kYJYBookUpdateNotification @"kYJYBookUpdateNotification"
#define kYJYAssessUpdateNotification @"kYJYAssessUpdateNotification"
#define kYJYOrderUpdateNotification @"kYJYOrderUpdateNotification"
#define kYJYOrderDetailUpdateNotification @"kYJYOrderDetailUpdateNotification"
#define kYJYOrderListFilterNotification @"kYJYOrderListFilterNotification"


#define kYJYWorkBenchChangeOrderListNotification @"kYJYWorkBenchChangeOrderListNotification"
#define kYJYWorkBenchDidLoginNotification @"kYJYWorkBenchDidLoginNotification"

//The 3rd Party

#define RongYunAppKey @"qd46yzrfq0mzf"
#define RongYunAppSecret  @"14oXoAR0PzIb2D"

#define JiGuang_Push_AppID @"48a178e8207f23c4533fd6c0"
#define JiGuang_Push_Master_Secret @"2137a231c450a7710161b247"


#define QQAPPID @"1106002173"
#define SINAAPPID @"2479949691"
#define WECHATAPPID @"wx593e1845a56bac8a"
#define GAODEMAP @"837a350155be16000435d0742be30a7e"
#define AMapKey @"34ab61eac62d48a0e3d8deba67f8dfb1"

//env
#define DEV @"dev"
#define TEST @"test"
#define WWW @"www"


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



typedef void(^CompleteNoneBlock)();
typedef void(^FailureNoneBlock)();











