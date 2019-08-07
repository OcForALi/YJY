//
//  YJYBranchOrderInfoController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/3/29.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

typedef void(^YJYBranchOrderInfoDidDoneBlock)(ConfirmNewOrderRsp *rsp);


@interface YJYBranchOrderInfoController : YJYViewController
/// 原订单id
@property(nonatomic, readwrite) NSString *orderId;

/// 新科室id
@property(nonatomic, readwrite) uint64_t branchId;

/// 新服务定价id
@property(nonatomic, readwrite) uint64_t priceId;


@property (copy, nonatomic) YJYBranchOrderInfoDidDoneBlock didDoneBlock;
@end
