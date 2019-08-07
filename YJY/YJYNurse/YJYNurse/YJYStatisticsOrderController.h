//
//  YJYStatisticsOrderController.h
//  YJYNurse
//
//  Created by wusonghe on 2018/5/25.
//  Copyright © 2018年 samwuu. All rights reserved.
//

#import "YJYTableViewController.h"

@interface YJYStatisticsOrderController : YJYTableViewController
/// 操作类型 1-出院 2-入院 3-未下单
@property(nonatomic, readwrite) uint32_t type;
@property (strong, nonatomic) GPBUInt64Array *branchIdArray;
@property (strong, nonatomic) NSString  *currentDate;

@end
