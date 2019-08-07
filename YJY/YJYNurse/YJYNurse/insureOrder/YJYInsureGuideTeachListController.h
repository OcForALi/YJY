//
//  YJYInsureGuideTeachListController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/3/23.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYInsureGuideTeachListController : YJYTableViewController
@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;

@property(nonatomic, readwrite) uint64_t teachId;
@property(nonatomic, readwrite, copy) NSString *orderId;

@end
