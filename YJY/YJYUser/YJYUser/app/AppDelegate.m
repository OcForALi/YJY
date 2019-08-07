//
//  AppDelegate.m
//  Scaffold
//
//  Created by wusonghe on 2017/2/17.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "AppDelegate.h"
#import "YJYNetworkManager.h"
#import "XHLaunchAd.h"
#import <UserNotifications/UserNotifications.h>
#import "Model.pbobjc.h"
#import "OpenShareHeader.h"
#import "YJYLaunchScreenController.h"
#import "YJYTabController.h"
#import "YJYNotificationController.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif



#import <BaoFuAggregatePay/BaoFuAggregatePay.h>
#define kWXPayAPPIDPayKey @"wx593e1845a56bac8a://pay"

@interface AppDelegate ()
<XHLaunchAdDelegate,
UNUserNotificationCenterDelegate,
JPUSHRegisterDelegate>


@property (strong, nonatomic) YJYLaunchScreenController *launchVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    [self addLaunchAD];

    
    //JPush
    
    [JPUSHService setupWithOption:launchOptions appKey:JiGuang_Push_AppID channel:nil apsForProduction:NO];
    
    
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        
        [KeychainManager saveWithKey:kJPushToken Value:registrationID];

    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didPushed:) name:kJPFNetworkDidLoginNotification object:nil];
    //AMapServices
    
    [AMapServices sharedServices].apiKey =@"837a350155be16000435d0742be30a7e";
    [AMapServices sharedServices].enableHTTPS = YES;
        
    //pay
    
//    [BaoFuApi registerApp:@"wx593e1845a56bac8a"];
    [[YJYPaymentManager sharedInstance] cdm_registerApp];

   
    //share
    
    [OpenShare connectQQWithAppId:QQAPPID];
    [OpenShare connectWeiboWithAppKey:SINAAPPID];
    [OpenShare connectWeixinWithAppId:WECHATAPPID];
   
    
    //
    
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = YES;
    [YJYPaymentManager sharedInstance];
    
   
    UMConfigInstance.appKey = UMengAppID;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    

    return YES;

}

- (void)launch {
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [YJYTabController instanceWithStoryBoard];
    [self.window makeKeyAndVisible];

}




- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];

}



- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url {
    
//
    if ([BaoFuApi handleOpenURL:url delegate:[BaoFuClient sharedManager]]){

        return YES;
    }
    
    return [[YJYPaymentManager sharedInstance] cdm_handleUrl:url];
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    
    if ([BaoFuApi handleOpenURL:url delegate:[BaoFuClient sharedManager]]){

        return YES;
    }

    if ([[YJYPaymentManager sharedInstance] cdm_handleUrl:url]) {
        return YES;

    }
    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{

    if ([BaoFuApi handleOpenURL:url delegate:[BaoFuClient sharedManager]]){

        return YES;
    }

    return [[YJYPaymentManager sharedInstance] cdm_handleUrl:url];

}
#pragma mark - debug

#pragma mark - Push
- (void)didPushed:(id)noti {

}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UNNotificationSettings *)notificationSettings {

    [application registerForRemoteNotifications];

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
   
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带的弹出框
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    [self reloadUserInfo:userInfo];
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
   
}

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    [self reloadUserInfo:userInfo];
//
//    
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [self reloadUserInfo:userInfo];

//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
    completionHandler();  // 系统要求执行这个方法
}


//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [self reloadUserInfo:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    [self reloadUserInfo:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - Launch Page


- (void)addLaunchAD {
    
    
    [YJYNetworkManager requestWithUrlString:GetSplash message:nil controller:nil command:APP_COMMAND_AppgetSplashScreen success:^(id response) {
        
      
        GetSplashScreenRsp *rsp = [GetSplashScreenRsp parseFromData:response error:nil];

        if (rsp.hasSplashScreenModel) {
            
            SplashScreenModel *model = rsp.splashScreenModel;
            //配置广告数据
            
            
            XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
            imageAdconfiguration.duration = model.duration;
            imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            imageAdconfiguration.imageNameOrURLString = model.imgURL;
            imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
            imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
            imageAdconfiguration.openURLString = model.URL;
            imageAdconfiguration.skipButtonType = SkipTypeTimeText;
            imageAdconfiguration.showEnterForeground = NO;
            imageAdconfiguration.viewController = self.launchVC;
            imageAdconfiguration.showFinishAnimate = ShowFinishAnimateFadein;
            
            //显示开屏广告
            [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((model.duration - 0.1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                
                [self reloadMainStoryBoard];

            });
            
        }else {
        
            
            XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
            imageAdconfiguration.duration = 1;
            imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            imageAdconfiguration.imageNameOrURLString = @"launch_img@2x";
            imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
            imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
            imageAdconfiguration.skipButtonType = SkipTypeTimeText;
            imageAdconfiguration.showEnterForeground = NO;
            imageAdconfiguration.viewController = self.launchVC;
            imageAdconfiguration.showFinishAnimate = ShowFinishAnimateFadein;
            
            //显示开屏广告
            [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((1 - 0.1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                
                [self reloadMainStoryBoard];
                
            });
        }
        
        
    } failure:^(NSError *error) {
        
        XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
        imageAdconfiguration.duration = 1;
        imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        imageAdconfiguration.imageNameOrURLString = @"launch_img";
        imageAdconfiguration.imageOption = XHLaunchAdImageDefault;
        imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
        imageAdconfiguration.skipButtonType = SkipTypeTimeText;
        imageAdconfiguration.showEnterForeground = NO;
        imageAdconfiguration.viewController = self.launchVC;
        imageAdconfiguration.showFinishAnimate = ShowFinishAnimateFadein;
        
        //显示开屏广告
        [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((1 - 0.1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [self reloadMainStoryBoard];
            
        });

    }];
    
    

    
    
    
}

- (void)xhLaunchAd:(XHLaunchAd *)launchAd imageDownLoadFinish:(UIImage *)image {
    
    self.launchVC.imageView.image = image;
}

- (void)xhLaunchShowFinish:(XHLaunchAd *)launchAd {

    [self reloadMainStoryBoard];

}

- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenURLString:(NSString *)openURLString {


}


- (void)reloadMainStoryBoard {

    
    if (![self.window.rootViewController isKindOfClass:[YJYTabController class]]) {
        [self launch];

    }


    
}
/*
{
    "_j_business" = 2;
    "_j_msgid" = 123243;
    "_j_uid" = 9424776323;
    aps =
        alert = 1111;
        badge = 5;
        sound = happy;
    };
    url = 111;
}
*/



- (void)reloadUserInfo:(NSDictionary *)userInfo {

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    YJYNavigationController *nav = [[YJYNavigationController alloc]initWithRootViewController:[YJYNotificationController instanceWithStoryBoard]];
    [[UIWindow currentViewController] presentViewController:nav animated:YES completion:nil];
    
    
//
//    if (userInfo[@"url"]) {
//        [YJYProtocolManager pushViewControllerFrom:[UIWindow currentViewController] url:userInfo[@"url"] type:YJYProtocolFromTypePush];
//    }
    
   

}



@end
