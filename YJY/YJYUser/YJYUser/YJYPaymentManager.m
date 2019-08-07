//
//  YJYPaymentManager.m
//  Scaffold
//
//  Created by wusonghe on 2017/2/23.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYPaymentManager.h"
#import "YJYChargeMoneyController.h"
#import "YJYChargeSuccessController.h"

@interface YJYPaymentManager()<WXApiDelegate>

//回调
@property (nonatomic,copy)CDMPayCompleteCallBack callBack;
//appScheme
@property (nonatomic,strong)NSMutableDictionary *appSchemeDict;


@end

@implementation YJYPaymentManager

+ (instancetype)sharedInstance
{
    static YJYPaymentManager *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[YJYPaymentManager alloc] init];
    });
    
    return sharedManager;
}

- (BOOL)cdm_handleUrl:(NSURL *)url{
    
    if ([url.host isEqualToString:@"pay"]) {// 微信
        return [WXApi handleOpenURL:url delegate:self];
    }
    else if ([url.host isEqualToString:@"safepay"]) {// 支付宝
        // 支付跳转支付宝钱包进行支付，处理支付结果(在app被杀模式下，通过这个方法获取支付结果）
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSString *resultStatus = resultDic[@"resultStatus"];
            NSString *errStr = resultDic[@"memo"];
            CDMPayStateCode errorCode = CDMStateCodeSuccess;
            switch (resultStatus.integerValue) {
                case 9000:// 成功
                    errorCode = CDMStateCodeSuccess;
                    break;
                case 6001:// 取消
                    errorCode = CDMStateCodeCancel;
                    break;
                default:
                    errorCode = CDMStateCodeFailure;
                    break;
            }
            if ([YJYPaymentManager sharedInstance].callBack) {
                [YJYPaymentManager sharedInstance].callBack(errorCode,errStr);
            }
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        return YES;
    }
    else{
        return NO;
    }
}

- (void)cdm_registerApp{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *urlTypes = dict[@"CFBundleURLTypes"];
    for (NSDictionary *urlTypeDict in urlTypes) {
        NSString *urlName = urlTypeDict[@"CFBundleURLName"];
        NSArray *urlSchemes = urlTypeDict[@"CFBundleURLSchemes"];
        // 一般对应只有一个
        NSString *urlScheme = urlSchemes.lastObject;
        if ([urlName isEqualToString:CDMWECHATURLNAME]) {
            [self.appSchemeDict setValue:urlScheme forKey:CDMWECHATURLNAME];
            // 注册微信
            [WXApi registerApp:urlScheme];
        }
        else if ([urlName isEqualToString:CDMALIPAYURLNAME]){
            // 保存支付宝scheme，以便发起支付使用
            [self.appSchemeDict setValue:urlScheme forKey:CDMALIPAYURLNAME];
        }
        else{
            
        }
    }
}

- (void)cdm_payOrderMessage:(id)orderMessage callBack:(CDMPayCompleteCallBack)callBack{
    // 缓存block
    self.callBack = callBack;
    // 发起支付
    if ([orderMessage isKindOfClass:[PayReq class]]) {
        // 微信
        [WXApi sendReq:(PayReq *)orderMessage];
    }
    else if ([orderMessage isKindOfClass:[NSString class]]){
        // 支付宝
        [[AlipaySDK defaultService] payOrder:(NSString *)orderMessage fromScheme:self.appSchemeDict[CDMALIPAYURLNAME] callback:^(NSDictionary *resultDic){
            NSString *resultStatus = resultDic[@"resultStatus"];
            NSString *errStr = resultDic[@"memo"];
            CDMPayStateCode errorCode = CDMStateCodeSuccess;
            switch (resultStatus.integerValue) {
                case 9000:// 成功
                    errorCode = CDMStateCodeSuccess;
                    break;
                case 6001:// 取消
                    errorCode = CDMStateCodeCancel;
                    break;
                default:
                    errorCode = CDMStateCodeFailure;
                    break;
            }
            if ([YJYPaymentManager sharedInstance].callBack) {
                [YJYPaymentManager sharedInstance].callBack(errorCode,errStr);
            }
        }];
    }
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    // 判断支付类型
    if([resp isKindOfClass:[PayResp class]]){
        //支付回调
        CDMPayStateCode errorCode = CDMStateCodeSuccess;
        NSString *errStr = resp.errStr;
        switch (resp.errCode) {
            case 0:
                errorCode = CDMStateCodeSuccess;
                errStr = @"订单支付成功";
                break;
            case -1:
                errorCode = CDMStateCodeFailure;
                errStr = resp.errStr;
                break;
            case -2:
                errorCode = CDMStateCodeCancel;
                errStr = @"用户中途取消";
                break;
            default:
                errorCode = CDMStateCodeFailure;
                errStr = resp.errStr;
                break;
        }
        if (self.callBack) {
            self.callBack(errorCode,errStr);
        }
    }
}

#pragma mark -- Setter & Getter

- (NSMutableDictionary *)appSchemeDict{
    if (_appSchemeDict == nil) {
        _appSchemeDict = [NSMutableDictionary dictionary];
    }
    return _appSchemeDict;
}

#pragma mark - Private
- (PayReq *)wechatPayReqWithOrderString:(NSString *)orderString{
    
    
    
    NSArray *hashs = [orderString componentsSeparatedByString:@"&"];
    NSMutableDictionary *dictionart = [NSMutableDictionary dictionary];
    for (NSString *hash in hashs) {
        
        NSRange range = [hash rangeOfString:@"="];
        if (range.location != NSNotFound) {
            
            NSString *key =  [hash substringToIndex:range.location];
            NSString *value =  [hash substringFromIndex:range.location+1];
            [dictionart addEntriesFromDictionary:@{key:value}];        }
        
        
        
    }
    // 调起微信支付
    
    NSMutableString *stamp = [dictionart objectForKey:@"timestamp"];
    PayReq *req   = [[PayReq alloc] init];
    req.partnerId = [dictionart objectForKey:@"partnerid"];
    req.prepayId  = [dictionart objectForKey:@"prepayid"];
    req.nonceStr  = [dictionart objectForKey:@"noncestr"];
    req.timeStamp = stamp.intValue;
    req.package   = [dictionart objectForKey:@"package"];
    req.sign      = [dictionart objectForKey:@"sign"];
    
    
    
    return req;
    
    
    
    
}

- (void)callbackWithOrderID:(NSString *)payRes payType:(NSInteger)payType{
    
    
    GetDoPayReq *req = [GetDoPayReq new];
    req.payRes = payRes;
    req.payType = (uint32_t)payType;
    
    
    [YJYNetworkManager requestWithUrlString:GetDoPay message:req controller:nil command:APP_COMMAND_GetDoPay success:^(id response) {
        
        GetDoPayRsp *rsp = [GetDoPayRsp parseFromData:response error:nil];
        
        
        
        if (rsp.res == 1) {
            [SYProgressHUD showSuccessText:@"支付成功"];
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kWxPayResult];
            
        }else {
            // [SYProgressHUD showFailureText:@"请重试"];
            
        }
        
    } failure:^(NSError *error) {
        
        [SYProgressHUD showFailureText:@"支付失败"];
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:kWxPayResult];
        
        
    }];
    
    
}

- (void)handleStateCode:(CDMPayStateCode)stateCode vc:(UIViewController *)vc isOrder:(BOOL)isOrder isRoot:(BOOL)isRoot complete:(CDMPayCompleteSuccessCallBack)complete{
    
    if (stateCode == CDMStateCodeSuccess) {
        
        [SYProgressHUD hide];
        YJYChargeSuccessController *cvc = [YJYChargeSuccessController instanceWithStoryBoard];
        [[UIWindow currentViewController] presentViewController:cvc animated:YES completion:nil];

        cvc.didDismissBlock = ^{
            
            if (complete) {
                complete();
            }
            
        };
        
        

   
       
        
        
        
        
    }else if (stateCode == CDMStateCodeFailure){
        
        [SYProgressHUD showToCenterText:@"支付被取消"];
    }else{
        [SYProgressHUD showToCenterText:@"支付失败"];
        
    }
    
}


@end
