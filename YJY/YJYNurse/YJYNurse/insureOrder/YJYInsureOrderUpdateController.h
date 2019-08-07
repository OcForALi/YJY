//
//  YJYInsureOrderUpdateController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/3/13.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"
typedef void(^YJYInsureOrderUpdateDidDoneBlock)();

@interface YJYInsureOrderUpdateController : YJYTableViewController
@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;
@property (copy, nonatomic) YJYInsureOrderUpdateDidDoneBlock didDoneBlock;

@end
