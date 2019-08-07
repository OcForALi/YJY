//
//  BaoFuApi.h
//  BaoFuAggregatePayDemo
//
//  Created by 路国良 on 2017/8/23.
//  Copyright © 2017年 baofoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
@interface BaoFuApi : NSObject
/*! @brief WXApi的成员函数，向微信终端程序注册第三方应用。
 *
 * 需要在每次启动第三方应用程序时调用。第一次调用后，会在微信的可用应用列表中出现，默认开启MTA数据上报。
 * iOS7及以上系统需要调起一次微信才会出现在微信的可用应用列表中。
 * @attention 请保证在主线程中调用此函数
 * @param appid 微信开发者ID
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) registerApp:(NSString *)appid;

/*! @brief 处理微信通过URL启动App时传递的数据
 *
 * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 * @param url 微信启动第三方应用时传递过来的URL
 * @param delegate  WXApiDelegate对象，用来接收微信触发的消息。
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) handleOpenURL:(NSURL *) url delegate:(id<WXApiDelegate>) delegate;
@end
