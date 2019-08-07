//
//  YJYOrderInsureWaitReviewController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/3/7.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYInsureReviewListController : YJYTableViewController

@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;

/// id
@property(nonatomic, readwrite) NSString *orderId;

@end
