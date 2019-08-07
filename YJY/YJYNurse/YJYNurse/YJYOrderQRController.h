//
//  YJYOrderQRController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/12/13.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

@interface YJYOrderQRController : YJYViewController

/// 链接类型 0 - 不做操作（登录） 1 - 跳订单详情（支付预付款） 2 - 跳结算页 3 - 跳充值预付款    4 - 跳订单详情(跟中间支付) 5-订单合并结算
@property(nonatomic, readwrite) uint32_t URLType;

/// 订单id
@property(nonatomic, copy) NSString *orderId;

@property (copy, nonatomic) YJYDidDoneBlock didDoneBlock;



@end
