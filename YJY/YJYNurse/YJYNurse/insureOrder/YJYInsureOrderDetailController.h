//
//  YJYInsureOrderController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/3/6.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

@interface YJYInsureOrderDetailController : YJYViewController

@property (strong, nonatomic) OrderVO *orderVO;

/// 订单id
@property(nonatomic, readwrite) NSString *orderId;
@property(nonatomic, readwrite) NSString *insureNo;
@property(nonatomic, readwrite) NSInteger orderState;


@property (assign, nonatomic) BOOL hasToBackRoot;

@end
