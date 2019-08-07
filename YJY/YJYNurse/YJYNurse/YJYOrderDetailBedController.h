//
//  YJYOrderDetailBedController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/12/20.
//  Copyright © 2017年 samwuu. All rights reserved.
//

#import "YJYViewController.h"


typedef void(^YJYOrderDetailBedDidComfireBlock)();
@interface YJYOrderDetailBedController : YJYViewController

@property (copy, nonatomic) NSString *orderId;
@property (copy, nonatomic) YJYOrderDetailBedDidComfireBlock didComfireBlock;
@property (assign, nonatomic) BOOL isYesterday;
@end
