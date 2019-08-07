//
//  BaofooPayClient.h
//  BaofooWebchatSDK
//
//  Created by 路 on 16/7/25.
//  Copyright © 2016年 baofoo. All rights reserved.
//
/*--------------------------------------------------------------------------------------------
 版权所有：宝付网络科技（上海）有限公司
 版本号：2.1.0
 首次发版日期：20170823
 SDK名称：宝付聚合支付SDK
 文件描述：
 作者:
 创建描述：
 修改标示：
 修改描述：
 *--------------------------------------------------------------------------------------------
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"

/**
 *  SDK代理，遵守代理获取支付结果（必须实现）
 *
 */
@protocol BaofooWebchatPaySDKDelegate <NSObject>

/**
 *  代理方法 支付结果回调
 *
 *  @param statusCode 0000:支付成功,其它支付失败,详细信息请查阅《宝付聚合支付sdk（iOS）对接文档》文档
 *  @param message  描述信息
 */
@required
-(void)callBack:(NSString*)statusCode andMessage:(NSString *)message;

@end


/*
 *支付渠道
 *
 * channel_alipay                    支付宝支付
 * channel_weChat                    微信支付
 */
typedef NS_ENUM(NSInteger,channelState){
    channel_alipay = 0,
    channel_weChat
};

@interface BaofooPayClient : NSObject
/**
 *  sdk唯一初始化方法（必须实现）
 *
 *  @param tokenID  商户服务端获取
 *  @param channel  渠道信息
 */
-(void)payWebchatWithTokenID:(NSString *)tokenID channelState:(channelState)channel withSelf:(UIViewController*)controller;

/**
 *  手动查询支付结果
 *
 */
-(void)manualQuery;

@property(nonatomic,weak)id<BaofooWebchatPaySDKDelegate>delegate;

@end

/**
 *注意：烦请商户技术人员对接sdk前阅读下列注意事项，结合对接文档可大量节省对接时间，减少对接问题。
 *（1）、宝付聚合支付sdk支持最低版本为iOS8.0，如有特殊需求请联系宝付技术支持。为满足不同商户需求宝付提供6种.framework格式的包，宝付建议开发阶段使用Debug-universally（真机模拟器混合版本），上线时使用Release-iphoneos（真机版本）或者Release-universally。
 *（2）、sdk初始化方法仅且必须使用宝付提供的方法，参数为必须传入值。
 *（3）、sdk代理为必须实现代理，支付结果会在代理中回调。
 *（4）、如有特殊商户需要单独使用微信官方sdk支付功能，请勿重复导入微信支付sdk！只需在使用处导入#import <BaoFuAggregatePay/BaoFuAggregatePay.h>头文件，该头文件（BaoFuAggregatePay.h）中引用了微信WXApi.h，WXApiObject.h，WechatAuthSDK.h三个头文件。微信libSPaySDK.a文件被宝付sdk当做资源文件引用。
 *（5）、宝付集成的微信支付sdk为官方（1.8.0版本，包含支付功能）地址:https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419319164&lang=zh_CN
 *（6）、如需更新微信sdk请用在微信官方（第5条中的地址）下载微信最新sdk，然后替换资源文件libSPaySDK.a即可。
 *（7）、sdk启动支付时会自动检测用户手机是否安装微信，是否微信版本过低，是否安装支付宝，若为否会引导用户跳转到苹果应用商店下载微信或支付宝。
 */

/**
 *  内部保留部分，外部请勿调用
 *
 */
@interface BaoFuClient : NSObject<WXApiDelegate>
+ (instancetype)sharedManager;

@end










