//
//  YJYOrderNightCareController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/1/24.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYViewController.h"


typedef void(^YJYOrderNightCareDidBackBlock)();

@interface YJYOrderNightCareController : YJYTableViewController
@property (copy, nonatomic) NSString *orderId;


@property (assign, nonatomic) YJYOrderPaymentAdjustType jumpType;
@property (copy, nonatomic) YJYOrderNightCareDidBackBlock didBackBlock;
@end
