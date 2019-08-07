//
//  YJYPayOffDetailController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/8/2.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYPayOffDetailController : YJYViewController
@property(nonatomic, readwrite) NSString *orderId;

@property (copy, nonatomic) YJYDidDoneBlock didDoneBlock;
@end
