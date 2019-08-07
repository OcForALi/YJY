//
//  YJYProtocolManager.m
//  YJYUser
//
//  Created by wusonghe on 2017/3/27.
//  No Comment © 2017年 samwuu. All rights reserved.
//
/*
 
 1，扫码
 yjy://scanqrcode/?token=xxxxxxxxx
 2，居家预约下单
 yjy://yuyue/jujia?serviceId=n
 3，机构预约下单
 yjy://yuyue/jigou?serviceId=n
 4，分享页
 yjy://share/callback?sharetype=n&title=标题&content=内容&imageurl=strurl&link=linkurl
 5，我的主页
 yjy://my/
 6，微信支付
 yjy://wxpay/callback?pre_payid=xxxx
 7，支付宝支付
 yjy://zfbpay/callback?pay_info=xxxx
 8，服务协议
 yjy://protocol/
 9，订单列表
 yjy://order/list/?key=xxx
 10，订单详情（结算列表）
 yjy://order/detail?orderId=xxxx
 11，http|https
 12，长护险申请列表
 yjy://insure/list
 13，长护险申请详情
 yjy://insure/detail?insreNO=xxxx
 
 14，消息列表
 yjy://msglist?msgType=n
 15，长护险补贴明细
 yjy://insureAccountDetail?orderId=xxxx
 16，长护险介绍页
 yjy://insureInfo
 17，消息详情页（1-去消息详情）
 yjy://msgDetail?type=1
 18，变更记录明细
 yjy://changeRecord?orderId=xxxx
 
 19，照护详情
 
 yjy://orderTend?orderId=xxx&tendId=xxx
 20，回访详情
 
 yjy://insureOrderVisitDetail?orderId=xxx&visitId=xxx
 21 ，自照考核列表
 
 yjy://insureOrderCheckList?orderId=xxx
 22 ，长护险订单详情页
 
 yjy://insureorder?orderId=xxx&serviceType=xxx
 23 ，带教记录
 
 yjy://insureOrderTeach?teachId=xxx
 */


#import "YJYProtocolManager.h"
#import "YJYOrderCreateController.h"

#import "YJYInsureCarePlanDetailController.h"
#import "YJYInsureBackVisitController.h"
#import "YJYInsureReviewListController.h"
#import "YJYInsureOrderDetailController.h"
#import "YJYInsureGuideTeachListController.h"

@implementation YJYProtocolManager

+ (NSDictionary *)viewControllerMaps {

    //@"share/callback":@"YJYScanLoginController",
    //@"wxpay/callback":@"YJYScanLoginController",
//    @"zfbpay/callback":@"YJYScanLoginController",

    
    NSDictionary *map = @{@"scanqrcode/":@"YJYScanLoginController",
                          @"protocol/":@"YJYUserAgreementController",
                          @"order/list":@"YJYOrdersController", //订单列表
                          @"order/detail":@"YJYOrderDetailController", //订单详情
                          @"insure/list":@"YJYInsureManagerController", //评估列表
                          @"insure/detail":@"YJYInsureDetailController", //评估详情
                          @"insureorder/detail":@"YJYInsureOrderDetailController",
                          @"insureAccountDetail":@"YJYInsureBonusController",
                          @"changeRecord":@"YJYOrderModifyDetailController",
                          @"orderTend":@"YJYInsureCarePlanDetailController", //照护详情
                          @"insureOrderVisitDetail":@"YJYInsureBackVisitController",
                          @"insureOrderCheckList":@"YJYInsureReviewListController",
                          @"insureorder":@"YJYInsureOrderDetailController",
                          @"insureOrderTeach":@"YJYInsureGuideTeachListController",
                          @"feedbackList":@"YJYSuggestListController"
                          };
    
    return map;
    
}

+ (id)viewControllerWithProtocol:(NSString *)protocol {
    
    protocol = [protocol stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * url = [NSURL URLWithString:protocol];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in [url.query componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [params setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    
    if ([url.scheme isEqualToString:@"yjy"]) {
        
        NSMutableString *urlM = [NSMutableString string];
        [urlM appendString:url.host];
        if ([url pathComponents]) {
            [urlM appendString:[[url pathComponents] componentsJoinedByString:@""]];
        }
        
        if (![urlM containsString:@"callback"]) {
            
            NSString *vcName = [[self viewControllerMaps] objectForKey:urlM];
            id VC;
            
            @try {
                VC = [NSClassFromString(vcName) instanceWithStoryBoard];
                if (!VC) {
                    VC = [NSClassFromString(vcName) new];
                }
                if (params) {
                    [self assginToPropertyWithDictionary:params object:VC];
                }
                
            } @catch (NSException *exception) {
                VC = [NSClassFromString(vcName) new];
            } @finally {
                
            }
            
            
            return VC;
        }
        
        
    }
    
    return nil;
    
}
+ (void) assginToPropertyWithDictionary: (NSDictionary *) data object:(id)object{
    
    if (data == nil) {
        return;
    }
    
    ///1.获取字典的key
    NSArray *dicKey = [data allKeys];
    
    ///2.循环遍历字典key, 并且动态生成实体类的setter方法，把字典的Value通过setter方法
    ///赋值给实体类的属性
    for (int i = 0; i < dicKey.count; i ++) {
        
        ///2.1 通过getSetterSelWithAttibuteName 方法来获取实体类的set方法
        SEL setSel = [self creatSetterWithPropertyName:dicKey[i]];
        
        if ([object respondsToSelector:setSel]) {
            ///2.2 获取字典中key对应的value
            NSString  *value = [NSString stringWithFormat:@"%@", data[dicKey[i]]];
            
            ///2.3 把值通过setter方法赋值给实体类的属性
            [object performSelectorOnMainThread:setSel
                                   withObject:value
                                waitUntilDone:[NSThread isMainThread]];
        }
        
    }
    
}
#pragma mark -- 通过字符串来创建该字符串的Setter方法，并返回
+ (SEL) creatSetterWithPropertyName: (NSString *) propertyName{
    
    //1.首字母大写
    
    if (propertyName && propertyName.length > 0) {
        
        NSRange firstRange = NSMakeRange(0, 1);
        NSString *fitstAlpha = [propertyName substringWithRange:firstRange];
        
        propertyName = [propertyName stringByReplacingCharactersInRange:firstRange withString:[fitstAlpha uppercaseString]];
        
        //2.拼接上set关键字
        propertyName = [NSString stringWithFormat:@"set%@:", propertyName];
        
        //3.返回set方法
        return NSSelectorFromString(propertyName);
        
    }
    
    return nil;
    
    
}

+ (void)pushViewControllerFrom:(UIViewController *)fromVC url:(NSString *)url type:(YJYProtocolFromType)type {

    
    if ([YJYProtocolManager viewControllerWithProtocol:url]) {
        
        id vc = [YJYProtocolManager viewControllerWithProtocol:url];
        [fromVC.navigationController pushViewController:vc animated:YES];

    }
}

@end
