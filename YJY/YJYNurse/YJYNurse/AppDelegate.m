//
//  AppDelegate.m
//  YJYNurse
//
//  Created by wusonghe on 2017/5/18.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import "AppDelegate.h"
#import "YJYLoginController.h"
#import "YJYTabController.h"
#import "YJYProtocolManager.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <UMMobClick/MobClick.h>
#import "YJYNotificationController.h"

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>

@property (strong, nonatomic) AMapLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@property (strong, nonatomic) GetSettingRsp *rsp;
@property (assign, nonatomic) BOOL isUpdateTip;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [YJYSettingManager sharedInstance].env = DEV;//DEV TEST WWW;
    [AMapServices sharedServices].apiKey = AMapKey;
    [AMapServices sharedServices].enableHTTPS = YES;
    [self setupJPushWithlaunchOptions:launchOptions];
    [self setupKeyboard];
    [self setupLocationManager];
    //网络原因提交不成功订单 5分钟重新请求一次
    [self networkFailureRequest];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *sid = [KeychainManager getValueWithKey:SID];

        if (sid) {
           
            self.window.rootViewController = [YJYTabController instanceWithStoryBoard];
            
        }else {
            YJYLoginController *vc =[YJYLoginController instanceWithStoryBoard];
            vc.didSuccessLoginComplete = ^(id response) {
                
                [self changeRootViewController:[YJYTabController instanceWithStoryBoard]];
            };
            self.window.rootViewController = vc;
            
        }
    });
    
    //tint
    [UITextField appearance].tintColor = APPHEXCOLOR;
    [UITextView appearance].tintColor = APPHEXCOLOR;
    
    UMConfigInstance.appKey = @"5968adbc8f4a9d3986000538";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    return YES;

}


- (void)applicationWillResignActive:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

}


- (void)changeRootViewController:(UIViewController*)viewController {
    
    if (!self.window.rootViewController) {
        self.window.rootViewController = viewController;
        return;
    }
    
    UIView *snapShot = [self.window snapshotViewAfterScreenUpdates:YES];
    
    [viewController.view addSubview:snapShot];
    
    self.window.rootViewController = viewController;
    
    [UIView animateWithDuration:0.5 animations:^{
        snapShot.layer.opacity = 0;
        snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5);
    } completion:^(BOOL finished) {
        [snapShot removeFromSuperview];
    }];
}

#pragma mark - JPush

- (void)setupJPushWithlaunchOptions:(NSDictionary *)launchOptions {
    
    //JPush
    
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|UNAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
//    [JPUSHService setupWithOption:launchOptions appKey:JiGuang_Push_AppID channel:nil apsForProduction:NO];
//    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
//    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        // 可以添加自定义categories
//        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
//        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
//    }
//    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
//
//        [KeychainManager saveWithKey:kJPushToken Value:registrationID];
//
//    }];
}
#pragma mark - Push

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

#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {

    completionHandler(UNNotificationPresentationOptionAlert);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [self reloadUserInfo:userInfo];
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
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)reloadUserInfo:(NSDictionary *)userInfo {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    

    [[NSNotificationCenter defaultCenter]postNotificationName:kYJYOrderDetailUpdateNotification object:nil];

    YJYNotificationController *vc = [YJYNotificationController instanceWithStoryBoard];
    YJYNavigationController *nav = [[YJYNavigationController alloc]initWithRootViewController:vc];
    vc.isFromPush = YES;
    vc.title = @"消息通知";

    [[UIWindow currentViewController] presentViewController:nav animated:YES completion:nil];
    
    
    
}
#pragma mark - IQKeyboardManager
- (void)setupKeyboard {
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条
    keyboardManager.toolbarDoneBarButtonItemText = @"完成";
    keyboardManager.shouldShowTextFieldPlaceholder = NO;
    
}

#pragma mark - Setup


- (void)setupLocationManager {
    
    //locationManager
    
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error)
            {
                self.location = location;
                [YJYSettingManager sharedInstance].adcode = (uint32_t)[regeocode.adcode integerValue];
                [KeychainManager saveWithKey:kAdcode Value:regeocode.adcode];
                
                
            }
            [self loadSettingData];
        });
        
    }];
    [self loadSettingData];

    
}
- (void)loadSettingData {
    
    
    GetSettingReq *req = [GetSettingReq new];
    req.adcode = [YJYSettingManager sharedInstance].adcode;
    if (self.location) {
        req.lat = self.location.coordinate.latitude;
        req.lng = self.location.coordinate.longitude;
    }
    [YJYSettingManager sharedInstance].urlTypeStr  = @"http";
    
    [YJYNetworkManager requestWithUrlString:SAASAPPGetSettings message:req controller:nil command:APP_COMMAND_SaasappgetSettings success:^(id response) {
        
        @try {
            GetSettingRsp *rsp = [GetSettingRsp parseFromData:response error:nil];
            
            
            //city
            
            [YJYSettingManager sharedInstance].citys = rsp.citysArray;
            
            //items
            
            [YJYSettingManager sharedInstance].items = rsp.itemsArray;
            
            
            
            //language
            
            [YJYSettingManager sharedInstance].languageList = rsp.languageListArray;
            
            
            //hospital
            [YJYSettingManager sharedInstance].currentOrgVo = rsp.orgVo;
            
            
            [YJYSettingManager sharedInstance].medicareListArray = rsp.medicareListArray;
            
            [YJYSettingManager sharedInstance].urlTypeStr = rsp.URLTypeStr;
            
            self.rsp = rsp;
            if (!self.isUpdateTip) {
                [self showUpdateAction];
                
            }
            self.isUpdateTip = YES;
            
            
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }

    } failure:^(NSError *error) {
        
    }];
    
}

- (void)showUpdateAction {
    
    // 1-更新提醒 2-强制更新
    if (self.rsp.updateFlag == 1) {
        
        [UIAlertController showAlertInViewController:[UIApplication sharedApplication].keyWindow.rootViewController withTitle:@"有新版本需要更新" message:@"应用功能需要更新后才可以使用" alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            if (buttonIndex == 1) {
                NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",@"1259828749"];
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }
            
            
            
        }];
        
    }else if (self.rsp.updateFlag == 2) {
        
        [UIAlertController showAlertInViewController:[UIApplication sharedApplication].keyWindow.rootViewController withTitle:@"有新版本需要更新" message:@"应用功能需要更新后才可以使用" alertControllerStyle:UIAlertControllerStyleAlert cancelButtonTitle:nil destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            
            NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",@"1259828749"];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
                
            }];
            
            
        }];
        
    }
}
//开启网络失败重新请求 5分钟启动一次
- (void)networkFailureRequest{
    
    self.mTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    
}

- (void)timeAction{
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *requestArray = [NSMutableArray array];

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"notOrderList"] isKindOfClass:[NSArray class]]) {
        [array addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"notOrderList"]];
    }
    
    if (array.count <= 0) {
        [self.mTimer invalidate];
        return;
    }
    
    for (int i = 0; i < array.count; i ++) {
        
        NSDictionary *dict = array[i];
        
        NSArray *keyArray = [dict allKeys];
        
        NSString *timeString = keyArray[0];
        NSDate *oldDate = [NSDate dateString:timeString Format:YYYY_MM_DD_HH_MM];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit = NSCalendarUnitHour;
        NSDateComponents *delta = [calendar components:unit fromDate:oldDate toDate:[NSDate date] options:0];
        
        if (delta.hour > 5) {
             [array removeObjectAtIndex:i];
            
            if (array.count > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"notOrderList"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"notOrderList"];
            }

        }else{
            
            CreateOrderReq *createOrderReq = [CreateOrderReq new];
            [createOrderReq setValuesForKeysWithDictionary:[dict objectForKey:timeString]];
            [requestArray addObject:createOrderReq];
            
        }
        
    }
    
    [self notReqeust:requestArray count:0];
    
}

- (void)notReqeust:(NSArray *)array count:(NSInteger)count{
    
    if (array.count == count) {
        return;
    }
    
    NSMutableArray *listArray = [NSMutableArray array];
    [listArray addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"notOrderList"]];
    
    [YJYNetworkManager requestWithUrlString:SAASAPPCreateOrder message:array[count] controller:self.window.rootViewController command:APP_COMMAND_SaasappcreateOrder success:^(id response) {
        
        if (response != nil) {
            
            [listArray removeObjectAtIndex:count];
            
            if (listArray.count > 0) {
                [[NSUserDefaults standardUserDefaults] setObject:listArray forKey:@"notOrderList"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"notOrderList"];
            }
            
        }
        
        [self notReqeust:array count:count + 1];
        
    } failure:^(NSError *error) {
        
        [listArray removeObjectAtIndex:count];
        
        if (listArray.count > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:listArray forKey:@"notOrderList"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"notOrderList"];
        }
        
        [self notReqeust:array count:count + 1];
        
    }];
    
}

- (void)stopTimer{
    [self.mTimer invalidate];
}

@end
