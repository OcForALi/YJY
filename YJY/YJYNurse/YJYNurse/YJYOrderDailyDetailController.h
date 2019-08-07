//
//  YJYOrderDailyDetailController.h
//  YJYNurse
//
//  Created by wusonghe on 2017/6/1.
//  No Comment © 2017年 samwuu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJYOrderDailyDetailController : YJYTableViewController

///订单ID
@property(nonatomic, copy) NSString *orderId;

///所属结算日期
@property(nonatomic, copy) NSString *settDate;

@end
