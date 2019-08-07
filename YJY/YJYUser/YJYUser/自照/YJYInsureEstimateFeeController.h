//
//  YJYInsureEstimateFeeController.h
//  YJYUser
//
//  Created by wusonghe on 2018/3/3.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYInsureEstimateFeeController : YJYTableViewController

@property(nonatomic, readwrite) NSString *orderId;
@property (strong, nonatomic) GetHomeOrderDetailRsp *orderDetailRsp;


@end
