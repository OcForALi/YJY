//
//  YJYPaymentManager.h
//  Scaffold
//
//  Created by wusonghe on 2017/2/23.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaoFuAggregatePay/WXApi.h>
#import <AlipaySDK/AlipaySDK.h>

#define CDMWECHATURLNAME @"weixin"
#define CDMALIPAYURLNAME @"alipay"

typedef NS_ENUM(NSInteger){
    CDMStateCodeSuccess,// 成功
    CDMStateCodeFailure,// 失败
    CDMStateCodeCancel// 取消
}CDMPayStateCode;

typedef void(^CDMPayCompleteCallBack)(CDMPayStateCode stateCode ,NSString *stateMsg);
typedef void(^CDMPayCompleteSuccessCallBack)();



@interface YJYPaymentManager : NSObject

@property (strong, nonatomic) NSString *payResult;


+ (instancetype)sharedInstance;

//处理跳转url，回到应用，需要在delegate中实现
- (BOOL)cdm_handleUrl:(NSURL *)handleUrl;

//注册App，需要在 didFinishLaunchingWithOptions 中调用
- (void)cdm_registerApp;
/*
 * @param orderMessage 传入订单信息,如果是字符串，则对应是跳转支付宝支付；如果传入PayReq 对象，这跳转微信支付,注意，不能传入空字符串或者nil
 * @param callBack     回调，有返回状态信息
 */
- (void)cdm_payOrderMessage:(id)orderMessage callBack:(CDMPayCompleteCallBack)callBack;

/*
  构建Rq
 
 */
- (PayReq *)wechatPayReqWithOrderString:(NSString *)orderString;

/*
 
 处理结果
 
 */

- (void)handleStateCode:(CDMPayStateCode)stateCode vc:(UIViewController *)vc isOrder:(BOOL)isOrder isRoot:(BOOL)isRoot complete:(CDMPayCompleteSuccessCallBack)complete;
@end
