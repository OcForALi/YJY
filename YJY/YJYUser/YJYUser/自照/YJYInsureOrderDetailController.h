//
//  YJYInsureOrderDetailController.h
//  YJYUser
//
//  Created by wusonghe on 2018/2/24.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYViewController.h"

@interface YJYInsureOrderDetailController : YJYViewController

/// 订单id
@property(nonatomic, readwrite) NSString *orderId;
@property(nonatomic, readwrite) NSString *insureNo;
@property(nonatomic, readwrite) NSInteger orderState;

@end
