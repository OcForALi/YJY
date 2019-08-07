//
//  YJYInsureBackVisitListController.h
//  YJYUser
//
//  Created by wusonghe on 2018/3/5.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYInsureBackVisitListController : YJYViewController
@property (strong, nonatomic) GetInsureOrderDetailRsp *orderDetailRsp;
/// 状态 0-全部，1-历史记录
@property(nonatomic, readwrite) uint32_t status;
@end
